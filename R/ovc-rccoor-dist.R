#' OVCCoordenadas: find cadastral references near coordinates
#'
#' @description
#' Query the OVCCoordenadas
#' [Consulta RCCOOR Distancia](`r ovcurl("RCCOORD")`) service to retrieve
#' cadastral references near a pair of coordinates. If no exact match is found,
#' the API searches within 50 square meters of the requested coordinates.
#'
#' @details
#' If the API returns no results, this function returns a
#' [tibble][dplyr::tbl_df] containing only query information.
#'
#' On a successful query, this function returns a [tibble][dplyr::tbl_df] with
#' one row per cadastral reference, including the following columns:
#' - `geo.xcen`, `geo.ycen`, `geo.srs`: Input arguments of the query.
#' - `refcat`: Cadastral reference.
#' - `address`: Address as recorded in the Spanish Cadastre.
#' - `cmun_ine`: Municipality code as registered on the INE (National
#'    Statistics Institute).
#' - Remaining fields: See the API documentation.
#'
#' @param lat Latitude for the query, expressed in the SRS/CRS defined by
#'   `srs`.
#' @param lon Longitude for the query, expressed in the SRS/CRS defined by
#'   `srs`.
#'
#' @inheritParams catr_ovc_get_cpmrc
#' @inherit catr_ovc_get_cpmrc return seealso
#'
#' @references
#' [Consulta RCCOOR Distancia](`r ovcurl("RCCOORD")`).
#'
#' @family ovc_coordinates
#' @family cadastral_references
#' @encoding UTF-8
#' @export
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
  # Validate arguments.
  lat <- validate_non_empty_arg(lat)
  lon <- validate_non_empty_arg(lon)

  srs <- ovc_validate_srs(srs)

  # Build the query URL.
  api_entry <- ovc_base_url(paste0(
    "OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR_Distancia?",
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

  # nolint start
  res <- content_list[["consulta_coordenadas_distancias"]][[
    "coordenadas_distancias"
  ]][["coordd"]]
  # nolint end

  # Extract overall query information.
  overall <- unlist(res["geo"])
  overall <- ovc_as_tibble_row(overall)

  # Extract cadastral reference information.
  rc <- res[["lpcd"]]

  if (is.null(rc)) {
    cli::cli_alert_warning("The query returned no cadastral references.")
    return(overall)
  }

  rc_all <- ovc_as_tibble_rows(rc)

  # Build additional cadastral reference, address and municipality fields.
  rc_help <- dplyr::bind_cols(
    ovc_ref_address(rc_all),
    dplyr::tibble(cmun_ine = paste0(rc_all$dt.loine.cp, rc_all$dt.loine.cm))
  )

  # Join helper fields and the raw API response.

  out <- dplyr::bind_cols(overall, rc_help, rc_all)

  ovc_numeric_coords(out)
}
