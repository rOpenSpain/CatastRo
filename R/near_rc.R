#' @name near_rc
#' @aliases near_rc
#'
#' @title Interface to query Consulta_RCCOOR_Distancia
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' **This function was deprecated to adapt it to the new interface. Use**
#' [catr_ovc_rccoor_distancia()] instead.
#'
#' Returns the Cadastral Reference of the state as well as the address
#' (municipality, street and number) given its coordinates and the Spatial Reference
#' System. In case that there is not any cadastral reference in the exact point, the
#' function returns all the cadastral references in a square 50 meters long centered
#' in the current point.
#'
#' @usage  near_rc(lat, lon, SRS = "Google")
#'
#' @inheritParams get_coor
#'
#' @param lat Latitude coordinate.
#' @param lon Longitude coordinate.
#'
#' @return A data.frame with the the addresses of the states and the cadastral
#'   references in the nearby area of the location given for every SRS
#'   requested.
#'
#' @references http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx?op=Consulta_RCCOOR_Distancia
#'
#' @author Angel Delgado Panadero.
#'
#'
#' @export
#' @keywords internal



near_rc <- function(lat, lon, SRS = "Google") {
  lifecycle::deprecate_stop("0.2.0", "near_rc()", "catr_ovc_rccoor_distancia()")
}
