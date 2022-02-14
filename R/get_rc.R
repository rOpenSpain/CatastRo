#' @name get_rc
#' @aliases get_rc
#'
#' @title Interface to query Consulta_RCCOOR
#'
#' @description
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' **This function was deprecated to adapt it to the new interface. Use**
#' [catr_ovc_rccoor()] instead.
#'
#' Returns the Cadastral Reference of the state as well as the
#' address (municipality, street and number) being given its coordinates and
#' the SRS.
#'
#' @usage get_rc(lat,lon,SRS="Google")
#'
#' @inheritParams get_coor
#'
#' @param lat Latitude coordinate.
#' @param lon Longitude coordinate.
#'
#' @return A data.frame with the the addresses of the states and the cadastral
#'   references for every SRS requested.
#' @references http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx?op=Consulta_RCCOOR
#'
#' @author Angel Delgado Panadero.
#'
#'
#' @export
#' @keywords internal







get_rc <- function(lat, lon, SRS = "Google") {
  lifecycle::deprecate_stop("0.2.0", "get_rc()", "catr_ovc_rccoor()")
}
