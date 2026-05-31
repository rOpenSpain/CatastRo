#' OVCCoordenadas: geocode a cadastral reference
#'
#' @description
#' Implementation of the OVCCoordenadas service
#' [Consulta CPMRC](`r ovcurl("CPMRC")`). Returns coordinates for a
#' specific cadastral reference.
#'
#' @details
#' When the API does not provide any result, this function returns a
#' [tibble][tibble::tbl_df] with the input arguments only.
#'
#' On a successful query, this function returns a [tibble][tibble::tbl_df]
#' with one row per cadastral reference, including the following columns:
#' - `xcoord`, `ycoord`: X and Y coordinates in the specified SRS.
#' - `refcat`: Cadastral reference.
#' - `address`: Address as recorded in the Cadastre.
#' - Remaining fields: Check the API documentation.
#'
#' @param rc The cadastral reference to be geocoded.
#' @param province,municipality Optional, used for narrowing the search.
#' @param srs SRS/CRS to use in the query. To see allowed values, use
#'   [catr_srs_values], specifically the `ovc_service` column.
#'
#' @inheritParams catr_set_cache_dir
#' @return A [tibble][tibble::tbl_df]. See **Details**.
#'
#' @references
#' [Consulta CPMRC](`r ovcurl("CPMRC")`).
#'
#' @seealso [catr_srs_values], `vignette("ovcservice", package = "CatastRo")`
#'
#' @family OVCCoordenadas
#' @family cadastral references
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' \donttest{
#'
#' # Using all arguments
#' catr_ovc_get_cpmrc("13077A01800039",
#'   4230,
#'   province = "CIUDAD REAL",
#'   municipality = "SANTA CRUZ DE MUDELA"
#' )
#'
#' # Only the cadastral reference
#' catr_ovc_get_cpmrc("9872023VH5797S")
#' }
#'
catr_ovc_get_cpmrc <- function(
  rc,
  srs = 4326,
  province = NULL,
  municipality = NULL,
  verbose = FALSE
) {
  # Validate arguments.
  rc <- validate_non_empty_arg(rc)

  srs <- ovc_validate_srs(srs)

  # Build the query URL.
  api_entry <- ovc_base_url(paste0(
    "OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC?",
    "Provincia=&Municipio=&SRS=&RC="
  ))

  # Normalize missing optional parameters.
  province <- ensure_null(province)
  municipality <- ensure_null(municipality)

  api_entry <- httr2::url_modify_query(
    api_entry,
    RC = rc,
    SRS = srs,
    Provincia = ifelse(is.null(province), "", province),
    Municipio = ifelse(is.null(municipality), "", municipality)
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
    empty <- tibble::tibble(r = rc, srs = srs)

    names(empty) <- c("refcat", "geo.srs")
    return(empty)
  }

  res <- content_list[["consulta_coordenadas"]][["coordenadas"]][["coord"]]

  # Extract query information.
  overall <- ovc_as_tibble_row(res)

  # Build helper fields.
  rc_help <- dplyr::bind_cols(
    tibble::tibble(
      xcoord = as.double(overall$geo.xcen),
      ycoord = as.double(overall$geo.ycen)
    ),
    ovc_ref_address(overall)
  )

  # Join helper fields and the raw API response.

  out <- dplyr::bind_cols(rc_help, overall)

  out
}
