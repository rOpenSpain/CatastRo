#' OVCCoordenadas: Reverse geocode cadastral references on a region
#'
#' @description
#' Implementation of the OVCCoordenadas service
#' [Consulta RCCOOR Distancia](`r ovcurl("RCCOORD")`).
#'
#' Returns the cadastral reference found for a set of coordinates. If no
#' cadastral references are found, the API returns a list of the cadastral
#' references found in an area of 50 square meters around the requested
#' coordinates.
#'
#' @encoding UTF-8
#' @family OVCCoordenadas
#' @family cadastral references
#' @inheritParams catr_ovc_get_cpmrc
#' @export
#' @inherit catr_ovc_get_cpmrc return
#'
#' @references
#' [Consulta RCCOOR Distancia](`r ovcurl("RCCOORD")`).
#'
#' @param lat Latitude to use on the query. It should be specified in the same
#'  in the CRS/SRS `specified` by `srs`.
#' @param lon Longitude to use on the query. It should be specified in the same
#'  in the CRS/SRS `specified` by `srs`.
#'
#' @seealso [catr_srs_values], `vignette("ovcservice", package = "CatastRo")`
#'
#' @details
#' When the API does not provide any result, the function returns a
#' [tibble][tibble::tbl_df] with the input arguments only.
#'
#' On a successful query, the function returns a [tibble][tibble::tbl_df] with
#' one row by cadastral reference, including the following columns:
#' - `geo.xcen`, `geo.ycen`, `geo.srs`: Input arguments of the query.
#' - `refcat`: Cadastral reference.
#' - `address`: Address as it is recorded on the Cadastre.
#' - `cmun_ine`: Municipality code as registered on the INE (National
#'    Statistics Institute).
#' - Rest of fields: Check the API Docs.
#'
#' @examplesIf run_example()
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
  lat <- validate_non_empty_arg(lat)
  lon <- validate_non_empty_arg(lon)

  valid_srs <- CatastRo::catr_srs_values
  valid <- as.character(valid_srs[valid_srs$ovc_service, ]$SRS)

  srs <- match_arg_pretty(srs, valid)
  srs <- paste0("EPSG:", srs)

  # Prepare query
  ##  Build url
  api_entry <- paste0(
    "http://ovc.catastro.meh.es/ovcservweb/",
    "OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR_Distancia?",
    "SRS=&Coordenada_X=&Coordenada_Y="
  )

  api_entry <- httr2::url_modify_query(
    api_entry,
    SRS = srs,
    Coordenada_X = lon,
    Coordenada_Y = lat
  )

  # Extract results
  resp <- get_request_body(api_entry, verbose = verbose)

  if (is.null(resp)) {
    return(NULL)
  }

  content_list <- xml2::as_list(httr2::resp_body_xml(resp))

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
    cli::cli_alert_warning("Query does not produce results.")
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

  out
}
