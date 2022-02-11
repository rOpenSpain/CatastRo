#' @name near_rc
#' @aliases near_rc
#'
#' @title Interface to query Consulta_RCCOOR_Distancia
#'
#' @description Returns the Cadastral Reference of the state as well as the address
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
#' @examples
#' direction <- near_rc(40.96002, -5.663408)
#' print(direction)
#' @export



near_rc <- function(lat, lon, SRS = "Google") {

  # SRS REPLACE
  SRS <- ifelse(tolower(SRS) == "google", "EPSG:4326", SRS)
  SRS <- ifelse(tolower(SRS) == "oficial", "EPSG:4258", SRS)

  # QUERY
  res <- GET(
    url = "http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR_Distancia",
    query = list(Coordenada_X = lon, Coordenada_Y = lat, SRS = SRS),
    ua = user_agent("CatastRo (https://github.com/DelgadoPanadero/CatastRo)")
  )

  stop_for_status(res)
  res <- xmlToList(xmlParse(res))
  distancia <- res$coordenadas_distancias$coordd$lpcd$pcd$dis

  # TEXT MINING
  if (is.null(res$coordenadas_distancias$coordd$lpcd)) {

    # If the are not any cadastral register neither in the coordeinates nor the nearby area
    res <- data.frame(address = NA, RC = NA, SRS = NA, stringsAsFactors = F)
  } else if (!is.null(res$coordenadas_distancias$coordd$lpcd) && distancia == "0") {

    # if the coordenates are inside the space of a cadastral register
    address <- res$coordenadas_distancias$coordd$lpcd$pcd$ldt
    RC <- paste0(
      res$coordenadas_distancias$coordd$lpcd$pcd$pc$pc1,
      res$coordenadas_distancias$coordd$lpcd$pcd$pc$pc2
    )

    res <- data.frame(address = address, RC = RC, SRS = SRS, stringsAsFactors = F)
  } else if (!is.null(res$coordenadas_distancias$coordd$lpcd) && distancia != "0") {

    # The most general case, the coordinates doesn't match any cadrastral register, but there are one or more nearby
    address <- lapply(res$coordenadas_distancias$coordd$lpcd, FUN = "[[", 3)
    address <- do.call(rbind, address)
    address <- as.vector(address)

    RC <- lapply(res$coordenadas_distancias$coordd$lpcd, FUN = "[[", 1)
    RC <- do.call(rbind, RC)
    RC <- as.data.frame(RC, row.names = F)
    RC <- as.vector(paste0(RC$pc1, RC$pc2))

    res <- data.frame(address = address, RC = RC, SRS = SRS, stringsAsFactors = F)
  } else {

    # If there is nothing near...
    res <- data.frame(address = NA, RC = NA, SRS = NA, stringsAsFactors = F)
  }

  Sys.sleep(1)

  return(res)
}
