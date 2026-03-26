#' OVCCoordenadas: Geocode a cadastral reference
#'
#' @description
#' Implementation of the OVCCoordenadas service
#' [Consulta CPMRC](`r ovcurl("CPMRC")`).
#'
#' Returns the coordinates for a specific cadastral reference.
#'
#' @encoding UTF-8
#' @family OVCCoordenadas
#' @family cadastral references
#' @inheritParams catr_set_cache_dir
#' @export
#'
#' @references
#' [Consulta CPMRC](`r ovcurl("CPMRC")`).
#'
#' @seealso [catr_srs_values], `vignette("ovcservice", package = "CatastRo")`
#'
#' @param rc The cadastral reference to be geocoded.
#' @param province,municipality Optional, used for narrowing the search.
#' @param srs SRS/CRS to use on the query. To see allowed values, use
#'   [catr_srs_values], specifically the `ovc_service` column.
#'
#' @return A [tibble][tibble::tbl_df]. See **Details**
#'
#' @details
#' When the API does not provide any result, the function returns a
#' [tibble][tibble::tbl_df] with the input arguments only.
#'
#' On a successful query, the function returns a [tibble][tibble::tbl_df]
#' with one row per cadastral reference, including the following columns:
#' - `xcoord`, `ycoord`: X and Y coordinates in the specified SRS.
#' - `refcat`: Cadastral Reference.
#' - `address`: Address as it is recorded on the Cadastre.
#' - Rest of fields: Check the API Docs.
#'
#' @examplesIf run_example()
#' \donttest{
#'
#' # using all the arguments
#' catr_ovc_get_cpmrc("13077A01800039",
#'   4230,
#'   province = "CIUDAD REAL",
#'   municipality = "SANTA CRUZ DE MUDELA"
#' )
#'
#' # only the cadastral reference
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
  # Sanity checks
  rc <- validate_non_empty_arg(rc)

  valid_srs <- CatastRo::catr_srs_values
  valid <- as.character(valid_srs[valid_srs$ovc_service, ]$SRS)

  srs <- match_arg_pretty(srs, valid)
  srs <- paste0("EPSG:", srs)

  # Prepare query
  ##  Build url
  api_entry <- paste0(
    "http://ovc.catastro.meh.es/ovcservweb/",
    "OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC?",
    "Provincia=&Municipio=&SRS=&RC="
  )

  # Replace NAs and NULL on optional params
  province <- ensure_null(province)
  municipality <- ensure_null(municipality)

  api_entry <- httr2::url_modify_query(
    api_entry,
    RC = rc,
    SRS = srs,
    Provincia = ifelse(is.null(province), "", province),
    Municipio = ifelse(is.null(municipality), "", municipality)
  )

  # Extract results
  resp <- get_request_body(api_entry, verbose = verbose)

  if (is.null(resp)) {
    return(NULL)
  }

  content_list <- xml2::as_list(httr2::resp_body_xml(resp))

  # Check API custom error
  err <- content_list[["consulta_coordenadas"]]

  if (("lerr" %in% names(err))) {
    df <- tibble::as_tibble_row(unlist(err["lerr"]))

    cli::cli_alert_danger(
      paste0("Error code: ", df[1, 1], ". ", df[1, 2])
    )

    empty <- tibble::tibble(
      r = rc,
      srs = srs
    )

    names(empty) <- c("refcat", "geo.srs")
    return(empty)
  }

  res <- content_list[["consulta_coordenadas"]][["coordenadas"]][["coord"]]

  # Get info of the query
  overall <- tibble::as_tibble_row(unlist(res))

  # Extract helper info
  rc_help <- tibble::tibble(
    xcoord = as.double(overall$geo.xcen),
    ycoord = as.double(overall$geo.ycen),
    refcat = paste0(overall$pc.pc1, overall$pc.pc2),
    address = overall$ldt
  )

  # Join all

  out <- dplyr::bind_cols(
    rc_help,
    overall
  )

  out
}
