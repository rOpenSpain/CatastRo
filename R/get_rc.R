get_rc_srs <- function(lat,lon,SRS){
  
  # Parameters to the query 
  ua <- user_agent(paste0("CatastRo", " (https://github.com/DelgadoPanadero/CatastRo)"))
  url <- 'http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR'
  query.parms <- list(Coordenada_X=lon,Coordenada_Y=lat,SRS=SRS)
  
  
  
  
  # Query
  res <- GET(url, query = query.parms, ua)
  stop_for_status(res)
  res <- xmlToList(xmlParse(res))
  
  
  
  
  # Text Mining
  if(!is.null(res$coordenadas$coord$ldt) | !is.null(res$coordenadas$coord$ldt)){
    
    
    address <- res$coordenadas$coord$ldt
    RC <- paste0(res$coordenadas$coord$pc$pc1,res$coordenadas$coord$pc$pc2)
    
    
    res <- data.frame(address = address, RC = RC, SRS  = SRS,stringsAsFactors = F)
  }
  
  else{res <- data.frame(address = NA, RC = NA, SRS  = NA, stringsAsFactors = F)}
  
  return(res)
}










get_rc <- function(lat,lon,SRS = NA, sleep_time = NA){
  
  # Query for the given SRS
  
  if (SRS %in% coordinates){
    res <- get_rc_srs(lat,lon,SRS)
    res <- as.data.frame(res)
  }
  
  
  # Query for all the possible SRS
  
  else{
    res <- lapply(coordinates, function(x){get_rc_srs(lat,lon,x)})
    res <- data.frame(do.call(rbind,res),stringsAsFactors = F)
    res <- res[!(is.na(res$address) & is.na(res$RC)),]
    
    if (nrow(res)==0){
      res <- data.frame(address = NA, RC = NA, SRS  = NA, stringsAsFactors = F)
    }

  }
  
  # ADDING SLEEPING TIME
  
  if(is.numeric(sleep_time)){Sys.sleep(sleep_time)}
  
  return(res)
}
