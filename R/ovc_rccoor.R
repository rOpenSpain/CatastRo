#' **OVCCoordenadas**: Reverse geocode a cadastral reference
#'
#' @description
#' Implementation of the OVCCoordenadas service
#' [Consulta_RCCOOR](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR).
#' Return the cadastral reference found of a set of specific coordinates.
#'
#' @references
#' [Consulta_RCCOOR](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR)
#'
#' @family OVCCoordenadas
#' @family cadastral references
#' @seealso [catr_srs_values], `vignette("ovcservice")`
#' @inheritParams catr_ovc_rccoor_distancia
#'
#' @return A tibble. See **Details**
#'
#' @export
#'
#' @details
#'
#' When the API does not provide any result, the function returns a tibble with
#' the input parameters only.
#'
#' On a successful query, the function returns a tibble with one row by
#' cadastral reference, including the following columns:
#' * `geo.xcen`, `geo.ycen`, `geo.srs`: Input parameters of the query.
#' * `refcat`: Cadastral Reference.
#' * `address`: Address as it is recorded on the Cadastre.
#' * Rest of fields: Check the API Docs on [Consulta_RCCOOR](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR)
#'
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
#' \donttest{
#' catr_ovc_rccoor(
#'   lat = 38.6196566583596,
#'   lon = -3.45624183836806,
#'   srs = 4326
#' )
#' }
catr_ovc_rccoor <- function(lat, lon, srs = 4326, verbose = FALSE) {

  # Sanity checks
  valid_srs <- CatastRo::catr_srs_values
  valid_srs <- valid_srs[valid_srs$ovc_service == TRUE, "SRS"]
  valid <- as.character(valid_srs$SRS)

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
    "OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR"
  )


  ## GET

  if (verbose) {
    url <- httr::parse_url(api_entry)
    url <- httr::modify_url(url, query = list(
      SRS = srs,
      Coordenada_X = lon,
      Coordenada_Y = lat
    ))

    message("Querying url:\n\t", url)
  }



  api_res <- httr::GET(api_entry, query = list(
    SRS = srs,
    Coordenada_X = lon,
    Coordenada_Y = lat
  ))


  # Check error on status
  httr::stop_for_status(api_res)


  # Extract results
  content <- httr::content(api_res)
  content_list <- xml2::as_list(content)

  # Check API custom error
  err <- content_list[["consulta_coordenadas"]]



  if (("lerr" %in% names(err))) {
    df <- tibble::as_tibble_row(unlist(err["lerr"]))

    message("Error code: ", df[1, 1], ". ", df[1, 2])

    empty <- tibble::tibble(
      a = lat,
      b = lon,
      srs = srs
    )

    names(empty) <- c("geo.xcen", "geo.ycen", "geo.srs")
    return(empty)
  }

  res <- content_list[["consulta_coordenadas"]][["coordenadas"]][["coord"]]

  # Get info of the query
  overall <- tibble::as_tibble_row(unlist(res))

  # Extract helper info
  rc_help <- tibble::tibble(
    refcat = paste0(overall$pc.pc1, overall$pc.pc2),
    address = overall$ldt
  )

  # Join all

  out <- dplyr::bind_cols(
    rc_help,
    overall
  )

  # Numeric
  out["geo.xcen"] <- as.numeric(out[["geo.xcen"]])
  out["geo.ycen"] <- as.numeric(out[["geo.ycen"]])

  return(out)
}
