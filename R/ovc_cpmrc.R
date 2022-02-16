#' **OVCCoordenadas**: Geocode a cadastral reference
#'
#' @description
#' Implementation of the OVCCoordenadas service
#' [Consulta_CPMRC](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_CPMRC).
#' Return the coordinates for a specific cadastral reference.
#'
#' @references
#' [Consulta_CPMRC](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_CPMRC)
#'
#' @family OVCCoordenadas
#' @family cadastral references
#' @seealso [catr_srs_values], `vignette("ovcservice")`
#' @inheritParams catr_ovc_rccoor
#'
#' @param rc The cadastral reference to be geocoded.
#' @param province,municipality Optional, used for narrowing the search.
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
#' * `xcoord`, `ycoord`: X and Y coordinates in the specified SRS.
#' * `refcat`: Cadastral Reference.
#' * `address`: Address as it is recorded on the Cadastre.
#' * Rest of fields: Check the API Docs on [Consulta_CPMRC](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_CPMRC)
#'
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
#' \donttest{
#'
#' # using all the arguments
#' catr_ovc_cpmrc("13077A01800039",
#'   4230,
#'   province = "CIUDAD REAL",
#'   municipality = "SANTA CRUZ DE MUDELA"
#' )
#'
#' # only the cadastral reference
#' catr_ovc_cpmrc("9872023VH5797S")
#' }
#'
catr_ovc_cpmrc <- function(rc,
                           srs = 4326,
                           province = NULL,
                           municipality = NULL,
                           verbose = FALSE) {


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
    "OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC"
  )

  # Replace NAs and NULL on optional params

  if (is.null(province) || is.na(province)) province <- ""
  if (is.null(municipality) || is.na(municipality)) municipality <- ""

  query <- list(
    RC = rc,
    SRS = srs,
    Provincia = province,
    Municipio = municipality
  )



  ## GET

  if (verbose) {
    url <- httr::parse_url(api_entry)
    url <- httr::modify_url(url, query = query)

    message("Querying url:\n\t", url)
  }



  api_res <- httr::GET(api_entry, query = query)


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

  return(out)
}
