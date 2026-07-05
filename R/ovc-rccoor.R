#' OVCCoordenadas: reverse geocode coordinates
#'
#' @description
#' Query the OVCCoordenadas
#' [Consulta RCCOOR](`r ovcurl("RCCOOR")`) service to retrieve the cadastral
#' reference associated with a pair of coordinates.
#'
#' @details
#' If the API returns no results, this function returns a
#' [tibble][tibble::tbl_df] containing only query information.
#'
#' On a successful query, this function returns a [tibble][tibble::tbl_df] with
#' one row per cadastral reference, including the following columns:
#' - `geo.xcen`, `geo.ycen`, `geo.srs`: Input arguments of the query.
#' - `refcat`: Cadastral reference.
#' - `address`: Address as recorded in the Spanish Cadastre.
#' - Remaining fields: See the API documentation.
#'
#' @inheritParams catr_ovc_get_rccoor_distancia
#'
#' @inherit catr_ovc_get_rccoor_distancia return
#' @inherit catr_ovc_get_cpmrc seealso
#'
#' @references
#' [Consulta RCCOOR](`r ovcurl("RCCOOR")`).
#'
#' @family ovc_coordinates
#' @family cadastral_references
#' @encoding UTF-8
#' @export
#' @examplesIf run_example()
#' \donttest{
#' catr_ovc_get_rccoor(
#'   lat = 38.6196566583596,
#'   lon = -3.45624183836806,
#'   srs = 4326
#' )
#' }
catr_ovc_get_rccoor <- function(lat, lon, srs = 4326, verbose = FALSE) {
  # Validate arguments.
  lat <- validate_non_empty_arg(lat)
  lon <- validate_non_empty_arg(lon)

  srs <- ovc_validate_srs(srs)

  # Build the query URL.
  api_entry <- ovc_base_url(paste0(
    "OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR?",
    "SRS=&Coordenada_X=&Coordenada_Y="
  ))

  api_entry <- httr2::url_modify_query(
    api_entry,
    SRS = srs,
    Coordenada_X = lon,
    Coordenada_Y = lat
  )

  # Extract results.
  content_list <- ovc_get_xml(api_entry, verbose = verbose)
  if (is.null(content_list)) {
    return(NULL)
  }

  # Check for API-level errors.
  err <- content_list[["consulta_coordenadas"]]

  if (ovc_has_error(err)) {
    ovc_report_error(err)
    empty <- tibble::tibble(a = lat, b = lon, srs = srs)

    names(empty) <- c("geo.xcen", "geo.ycen", "geo.srs")
    return(empty)
  }

  res <- content_list[["consulta_coordenadas"]][["coordenadas"]][["coord"]]

  # Extract query information.
  overall <- ovc_as_tibble_row(res)

  # Build helper fields.
  rc_help <- ovc_ref_address(overall)

  # Join helper fields and the raw API response.

  out <- dplyr::bind_cols(rc_help, overall)

  ovc_numeric_coords(out)
}
