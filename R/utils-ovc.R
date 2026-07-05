#' OVCCallejero and OVCCoordenadas base URL
#'
#' @noRd
ovc_base_url <- function(service) {
  paste0("http://ovc.catastro.meh.es/ovcservweb/", service)
}

#' Validate and format an OVC SRS value
#'
#' @noRd
ovc_validate_srs <- function(srs) {
  valid_srs <- CatastRo::catr_srs_values
  valid <- as.character(valid_srs[valid_srs$ovc_service, ]$SRS)

  srs <- match_arg_pretty(srs, valid)
  paste0("EPSG:", srs)
}

#' Download and parse an OVC XML response
#'
#' @noRd
ovc_get_xml <- function(url, verbose = FALSE) {
  resp <- get_request_body(url, verbose = verbose)

  if (is.null(resp)) {
    return(NULL)
  }

  xml2::as_list(httr2::resp_body_xml(resp))
}

#' Convert an OVC XML node to a one-row tibble
#'
#' @noRd
ovc_as_tibble_row <- function(x) {
  tibble::as_tibble_row(unlist(x))
}

#' Convert OVC XML nodes to a tibble
#'
#' @noRd
ovc_as_tibble_rows <- function(x) {
  dplyr::bind_rows(lapply(x, ovc_as_tibble_row))
}

#' Report an OVC service error
#'
#' @noRd
ovc_report_error <- function(err) {
  df <- ovc_as_tibble_row(err["lerr"])

  cli::cli_alert_danger(
    paste0("OVC service error {.val ", df[1, 1], "}: ", df[1, 2])
  )
}

#' Detect an OVC API error
#'
#' @noRd
ovc_has_error <- function(x) {
  "lerr" %in% names(x)
}

#' Create common cadastral reference and address fields
#'
#' @noRd
ovc_ref_address <- function(x) {
  tibble::tibble(refcat = paste0(x$pc.pc1, x$pc.pc2), address = x$ldt)
}

#' Convert common OVC coordinate columns to numeric
#'
#' @noRd
ovc_numeric_coords <- function(x) {
  x["geo.xcen"] <- as.numeric(x[["geo.xcen"]])
  x["geo.ycen"] <- as.numeric(x[["geo.ycen"]])

  x
}
