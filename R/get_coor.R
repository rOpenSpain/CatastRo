#' @name get_coor
#' @aliases get_coor
#'
#' @title Interface to query Consulta_CPMRC
#'
#' @description
#' Returns the coordinate of a state in a SRS given the Province, Municipality
#' and Cadastral Reference of the state.
#'
#' @usage get_coor(RC, SRS= 'Google', Province = '',Municipality = '')
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
#' @family OVCCoordenadas
#'
#' @examples
#' # using all the arguments
#' coordinates <- get_coor("13077A01800039", "EPSG:4230", "CIUDAD REAL", "SANTA CRUZ DE MUDELA")
#' print(coordinates)
#' #
#' # only the cadastral reference
#' coordinates <- get_coor("9872023VH5797S")
#' print(coordinates)
#' @export






get_coor <- function(RC, SRS = "Google", Province = "", Municipality = "") {

  # SRS REPLACE
  SRS <- ifelse(tolower(SRS) == "google", "EPSG:4326", SRS)
  SRS <- ifelse(tolower(SRS) == "oficial", "EPSG:4258", SRS)

  # REQUEST
  res <- GET(
    url = "http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC",
    query = list(Provincia = Province, Municipio = Municipality, SRS = SRS, RC = RC),
    ua = user_agent(paste0("CatastRo (https://github.com/rOpenSpain/CatastRo)"))
  )

  stop_for_status(res)
  res <- xmlToList(xmlParse(res))

  # TEXT MINING
  if (is.null(res$lerr$err$des)) {
    lon <- res$coordenadas$coord$geo$xcen
    lat <- res$coordenadas$coord$geo$ycen
    SRS <- res$coordenadas$coord$geo$srs
    res <- list("coord" = as.numeric(c(lat, lon)), "SRS" = SRS)
  } else if (res$lerr$err$des == "LA PROVINCIA ES OBLIGATORIA") {
    stop("LA PROVINCIA ES OBLIGATORIA")
  } else {
    res <- NA
  }
  Sys.sleep(1)
  return(res)
}
