#' OVCCoordenadas: Geocode a cadastral reference
#'
#' @description
#' Implementation of the OVCCoordenadas service
#' [Consulta CPMRC](`r ovcurl("CPMRC")`).
#'
#' Return the coordinates for a specific cadastral reference.
#'
#' @references
#' [Consulta CPMRC](`r ovcurl("CPMRC")`).
#'
#' @family OVCCoordenadas
#' @family cadastral references
#' @seealso [catr_srs_values], `vignette("ovcservice", package = "CatastRo")`
#' @inheritParams catr_ovc_get_rccoor
#'
#' @param rc The cadastral reference to be geocoded.
#' @param province,municipality Optional, used for narrowing the search.
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
#' On a successful query, the function returns a [`tibble`][tibble::tibble]
#' with one row by cadastral reference, including the following columns:
#' * `xcoord`, `ycoord`: X and Y coordinates in the specified SRS.
#' * `refcat`: Cadastral Reference.
#' * `address`: Address as it is recorded on the Cadastre.
#' * Rest of fields: Check the API Docs.
#'
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
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
catr_ovc_get_cpmrc <- function(rc,
                               srs = 4326,
                               province = NULL,
                               municipality = NULL,
                               verbose = FALSE) {
  # Sanity checks
  valid_srs <- CatastRo::catr_srs_values
  valid_srs <- tibble::as_tibble(valid_srs)
  valid_srs <- valid_srs[valid_srs$ovc_service == TRUE, "SRS"]
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


# Helper
ovcurl <- function(x) {
  # nocov start
  base <- "https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc"


  app <- switch(x,
    "CPMRC" = "ovccoordenadas.asmx?op=Consulta_CPMRC",
    "mun" = "ovccallejerocodigos.asmx?op=ConsultaMunicipioCodigos",
    "prov" = "ovccallejerocodigos.asmx?op=ConsultaProvincia",
    "RCCOORD" = "ovccoordenadas.asmx?op=Consulta_RCCOOR_Distancia",
    "RCCOOR" = "ovccoordenadas.asmx?op=Consulta_RCCOOR",
    NULL
  )

  if (x == "RCCOORD") base <- gsub("https", "http", base)

  paste0(c(base, app), collapse = "/")
  # nocov end
}
