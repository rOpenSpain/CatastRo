#' @rdname get_coor
#'
#' @title Interface to query Consulta_CPMRC
#'
#' @description
#'
#' `r lifecycle::badge("deprecated")`
#'
#' **This function was deprecated to adapt it to the new interface. Use**
#' [catr_ovc_get_cpmrc()] instead.
#'
#'
#'
#' @param RC Cadastral reference of the state.
#' @param SRS The Spatial Reference System desired for the coordinates, if it
#'   is missed, the returned coordinates will be given in the Spatial Reference
#'   System used by Googlemaps ('EPSG:4326'). The set of the available SRS to
#'   use are available in the vector `coordinates` from this package. Apart
#'   from that, the function accept as a SRS argument the values "Google" and
#'   "Oficial". The first uses the SRS value used by Google maps ('EPSG:4326')
#'   while the latter uses the official SRS ('EPSG:4258') in Europe. If no SRS
#'   is given, the function by default choose the "Google" SRS.
#' @param Province A string with the Province of the state. It is not case
#'   sensitive.
#' @param Municipality A string with the Municipality of the state. It is not
#'   case sensitive.
#'
#' @return A list consisting on two numeric values: the coordinates (latitude,
#' longitude) and the reference system in which they are expressed.
#'
#' @references http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx?op=Consulta_CPMRC
#'
#' @author Angel Delgado Panadero.
#'
#'
#' @export
#' @keywords internal
#' @family deprecated functions
get_coor <- function(RC, SRS = "Google", Province = "", Municipality = "") {
  lifecycle::deprecate_stop("0.2.0", "get_coor()", "catr_ovc_get_cpmrc()")
}

#' @rdname get_rc
#'
#' @title Interface to query Consulta_RCCOOR
#'
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' **This function was deprecated to adapt it to the new interface. Use**
#' [catr_ovc_get_rccoor()] instead.
#'
#'
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
#' @family deprecated functions
get_rc <- function(lat, lon, SRS = "Google") {
  lifecycle::deprecate_stop("0.2.0", "get_rc()", "catr_ovc_get_rccoor()")
}


#' @rdname near_rc
#'
#' @title Interface to query Consulta_RCCOOR_Distancia
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' **This function was deprecated to adapt it to the new interface. Use**
#' [catr_ovc_get_rccoor_distancia()] instead.
#'
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
#' @family deprecated functions
near_rc <- function(lat, lon, SRS = "Google") {
  lifecycle::deprecate_stop("0.2.0", "near_rc()", "catr_ovc_get_rccoor_distancia()")
}
