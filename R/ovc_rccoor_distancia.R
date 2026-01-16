#' OVCCoordenadas: Reverse geocode cadastral references on a region
#'
#' @description
#' Implementation of the OVCCoordenadas service
#' [Consulta RCCOOR Distancia](`r ovcurl("RCCOORD")`).
#'
#' Return the cadastral reference found on a set of coordinates. If no cadastral
#' references are found, the API returns a list of the cadastral references
#' found on an area of 50 square meters around the requested coordinates.
#'
#' @references
#' [Consulta RCCOOR Distancia](`r ovcurl("RCCOORD")`).
#'
#' @family OVCCoordenadas
#' @family cadastral references
#' @seealso [catr_srs_values], `vignette("ovcservice", package = "CatastRo")`
#' @inheritParams catr_atom_get_address
#'
#' @param lat Latitude to use on the query. It should be specified in the same
#'  in the CRS/SRS `specified` by `srs`.
#' @param lon Longitude to use on the query. It should be specified in the same
#'  in the CRS/SRS `specified` by `srs`.
#' @param srs SRS/CRS to use on the query. To check the admitted values check
#'   [catr_srs_values], specifically the `ovc_service` column.
#'
#' @return A [`tibble`][tibble::tibble]. See **Details**
#'
#' @export
#'
#' @details
#'
#' When the API does not provide any result, the function returns a
#' [`tibble`][tibble::tibble] with the input parameters only.
#'
#' On a successful query, the function returns a [`tibble`][tibble::tibble] with
#' one row by cadastral reference, including the following columns:
#' * `geo.xcen`, `geo.ycen`, `geo.srs`: Input parameters of the query.
#' * `refcat`: Cadastral reference.
#' * `address`: Address as it is recorded on the Cadastre.
#' * `cmun_ine`: Municipality code as registered on the INE (National
#'    Statistics Institute).
#' * Rest of fields: Check the API Docs.
#'
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
#' \donttest{
#' catr_ovc_get_rccoor_distancia(
#'   lat = 40.963200,
#'   lon = -5.671420,
#'   srs = 4326
#' )
#' }
catr_ovc_get_rccoor_distancia <- function(
  lat,
  lon,
  srs = 4326,
  verbose = FALSE
) {
  # Sanity checks
  valid_srs <- CatastRo::catr_srs_values
  valid_srs <- tibble::as_tibble(valid_srs)
  valid_srs <- valid_srs[valid_srs$ovc_service, "SRS"]
  valid <- tibble::deframe(valid_srs)
  valid <- as.character(valid)

  if (!as.character(srs) %in% valid) {
    stop(
      "'srs' for OVC should be one of ",
      paste0("'", valid, "'", collapse = ", "),
      ".\n\nSee CatastRo::catr_srs_values"
    )
  }

  srs <- paste0("EPSG:", srs)

  # Prepare query
  ##  Build url
  api_entry <- paste0(
    "http://ovc.catastro.meh.es/ovcservweb/",
    "OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR_Distancia"
  )

  query <- list(
    SRS = srs,
    Coordenada_X = lon,
    Coordenada_Y = lat
  )

  ## GET
  url <- httr2::url_parse(api_entry)
  url$query <- query
  url <- httr2::url_build(url)

  if (verbose) {
    message("Querying url:\n\t", url)
  }

  api_res <- httr2::request(url)
  api_res <- httr2::req_perform(api_res)

  # Check error on status
  httr2::resp_check_status(api_res)

  # Extract results
  content <- httr2::resp_body_xml(api_res)
  content_list <- xml2::as_list(content)
  # nolint start
  res <- content_list[["consulta_coordenadas_distancias"]][[
    "coordenadas_distancias"
  ]][["coordd"]]
  # nolint end

  # Get overall info of the query
  overall <- unlist(res["geo"])
  overall <- tibble::as_tibble_row(overall)

  # Extract Ref Cast info
  rc <- res[["lpcd"]]

  if (is.null(rc)) {
    message("Query does not produce results")
    return(overall)
  }

  rc_all <- lapply(rc, function(x) {
    tibble::as_tibble_row(unlist(x))
  })
  rc_all <- dplyr::bind_rows(rc_all)

  # Build additional fields, as the RC, address and munic (INE)
  rc_help <- tibble::tibble(
    refcat = paste0(rc_all$pc.pc1, rc_all$pc.pc2),
    address = rc_all$ldt,
    cmun_ine = paste0(rc_all$dt.loine.cp, rc_all$dt.loine.cm)
  )

  # Join all

  out <- dplyr::bind_cols(
    overall,
    rc_help,
    rc_all
  )

  # Numeric
  out["geo.xcen"] <- as.numeric(out[["geo.xcen"]])
  out["geo.ycen"] <- as.numeric(out[["geo.ycen"]])

  return(out)
}
