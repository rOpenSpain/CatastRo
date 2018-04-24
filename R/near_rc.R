near_rc_srs <- function(lat,lon,SRS){

  # PARAMETERS TO THE QUERY  
  ua <- user_agent(paste0("CatastRo", " (https://github.com/DelgadoPanadero/CatastRo)"))
  url <- 'http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR_Distancia'
  query.parms <- list(Coordenada_X=lon,Coordenada_Y=lat,SRS=SRS)
  
  
  # QUERY
  res <- GET(url, query = query.parms, ua)
  stop_for_status(res)
  res <- xmlToList(xmlParse(res))
  
  
  distancia <- res$coordenadas_distancias$coordd$lpcd$pcd$dis
  
  # TEXT MINING
  if(is.null(res$coordenadas_distancias$coordd$lpcd)){
    
    # If the arenÂ´t any cadastral register neither in the coordeinates nor the nearby area
    
    res <- data.frame(address = NA, RC = NA, SRS  = NA, stringsAsFactors = F)
    
  } 
    
  else if (!is.null(res$coordenadas_distancias$coordd$lpcd) && distancia == '0'){
    
    # if the coordenates are inside the space of a cadastral register
      
      address <- res$coordenadas_distancias$coordd$lpcd$pcd$ldt 
      RC <- paste0(res$coordenadas_distancias$coordd$lpcd$pcd$pc$pc1,
                   res$coordenadas_distancias$coordd$lpcd$pcd$pc$pc2)
      
      res <- data.frame(address = address, RC = RC, SRS  = SRS, stringsAsFactors = F)
      
    }
    
  else if (!is.null(res$coordenadas_distancias$coordd$lpcd) && distancia != '0'){
      
    # The most general, the coordinates doesn't match any cadrastral register, but there are one or more nearby
    
      address <- lapply(res$coordenadas_distancias$coordd$lpcd,FUN = '[[',3)
      address <- do.call(rbind,address)
      address <- as.vector(address)
      
      RC <- lapply(res$coordenadas_distancias$coordd$lpcd,FUN = '[[',1)
      RC <- do.call(rbind,RC)
      RC <- as.data.frame(RC, row.names = F)
      RC <- as.vector(paste0(RC$pc1,RC$pc2))
      
      res <- data.frame(address = address, RC = RC, SRS  = SRS, stringsAsFactors = F)

  }
    
  else {
    
    # This case should never happend, however, just in case...
    
    res <- data.frame(address = NA, RC = NA, SRS  = NA, stringsAsFactors = F)
    }    


  return(res)
}




  
  
  



near_rc <- function(lat,lon,SRS = NA, sleep_time = NA){
  
  # QUERY FOR THE SRS
  
  if (SRS %in% coordinates){
    res <- near_rc_srs(lat,lon,SRS)
  }
  
  
  # QUERY FOR ALL POSSIBLES SRS
  
  else{
    res <- lapply(coordinates, function(x){near_rc_srs(lat,lon,x)})
    res <- data.frame(do.call(rbind,res),stringsAsFactors = F)
    res <- res[!(is.na(res$address) & is.na(res$RC)),]
  }
  
  # ADDING SLEEPING TIME
  
  if(is.numeric(sleep_time)){Sys.sleep(sleep_time)}
  
  return(res)
}


