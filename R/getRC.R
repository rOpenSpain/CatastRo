library(httr)
library(XML)

getRC <- function(X,Y,SRS = 'EPSG:4230'){
  
  ua <- user_agent(paste0("castastRo", " (https://github.com/DelgadoPanadero/CatastRo)"))
  url <- 'http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR'
  
  query.parms <- list(Coordenada_X=X,Coordenada_Y=Y,SRS=SRS)
  res <- GET(url, query = query.parms, ua)
  stop_for_status(res)
  res <- xmlToList(xmlParse(res))
  
  if(is.null(res$coordenadas$coord$ldt)){stop('NO EXISTE ESE REGISTRO')}
  else{res$coordenadas$coord$ldt}
}
