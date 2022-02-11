#'@name get_rc
#'@aliases get_rc
#'
#'@title Interface to query Consulta_RCCOOR
#'
#'@description Returns the Cadastral Reference of the state as well as the address
#'(municipality, street and number) being given its coordinates and the SRS.
#'
#'@usage get_rc(lat,lon,SRS="Google")
#'
#'@param lat Latitude coordinate.
#'@param lon Longitude coortinate.
#'@param SRS The Spatial Reference System used for the coordinates. There is a vector
#'       with all the allowed SRSs in the variable from the package called coordinates.
#'
#'       The set of the available SRS to use are available in the vector `coordinates`
#'       from this package. A part from that, the function accept as a SRS argument
#'       the values "Google" and "Oficial". The first uses the SRS value used by Google
#'       maps ('EPSG:4326') while the latter uses the oficial SRS ('EPSG:4258') in
#'       Europe. If no SRS is given, the function by default choose the "Google" SRS.
#'
#'@return A data.frame with the the addresses of the states and the cadastral references
#'        for every SRS requested.
#'@references http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx?op=Consulta_RCCOOR
#'
#'@author Angel Delgado Panadero.
#'
#'@examples
#'direction <- get_rc(38.6196566583596,-3.45624183836806, 'EPSG:4230')
#'print(direction)
#'
#'directions <- get_rc(38.6196566583596,-3.45624183836806)
#'print(directions)
#'
#'
#'@export







get_rc <- function(lat,lon,SRS="Google"){

  # SRS REPLACE
  SRS <- ifelse(tolower(SRS) == "google", 'EPSG:4326', SRS)
  SRS <- ifelse(tolower(SRS) == "oficial", 'EPSG:4258', SRS)

  # REQUEST
  res <- GET(url = 'http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR',
             query = list(Coordenada_X=lon,Coordenada_Y=lat,SRS=SRS),
             ua = user_agent("CatastRo (https://github.com/rOpenSpain/CatastRo)"))

  stop_for_status(res)
  res <- xmlToList(xmlParse(res))

  # TEXT MINING
  if(!is.null(res$coordenadas$coord$ldt) | !is.null(res$coordenadas$coord$ldt)){

    address <- res$coordenadas$coord$ldt
    RC <- paste0(res$coordenadas$coord$pc$pc1,res$coordenadas$coord$pc$pc2)
    res <- data.frame(address = address, RC = RC, SRS  = SRS,stringsAsFactors = F)
  }

  else{res <- data.frame(address = NA, RC = NA, SRS  = NA, stringsAsFactors = F)}

  Sys.sleep(1)
  return(res)
}
