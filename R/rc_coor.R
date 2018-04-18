get_coor <- function(RC, SRS= '', Province = '',Municipality = ''){
  
  
  # PARAMETERS TO THE QUERY  
  ua <- user_agent(paste0("CatastRo", " (https://github.com/DelgadoPanadero/CatastRo)"))
  url <- 'http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC'
  query.parms <- list(Provincia=Province, Municipio=Municipality, SRS=SRS, RC=RC)
  
  
  # QUERY
  res <- GET(url, query = query.parms, ua)
  stop_for_status(res)
  res <- xmlToList(xmlParse(res))
  
  
  #TEXT MINING
  if(is.null(res$lerr$err$des)){

    lon <- res$coordenadas$coord$geo$xcen
    lat <- res$coordenadas$coord$geo$ycen
    SRS <- res$coordenadas$coord$geo$srs
    
    res <- list('coord' = as.numeric(c(lat,lon)), 'SRS' = SRS)
  }
  
  
  else if(res$lerr$err$des == "LA PROVINCIA ES OBLIGATORIA"){
    
    stop("LA PROVINCIA ES OBLIGATORIA")
    
  }
  
  
  else{res <- NA}
  
  return(res)
}
