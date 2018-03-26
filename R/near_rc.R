near_rc_srs <- function(lat,lon,SRS = 'EPSG:4230'){

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
    
    res <- data.frame(address = NA, RC = NA, SRS  = NA)
    
  }
    
    
  else if (!is.null(res$coordenadas_distancias$coordd$lpcd) && distancia == '0'){
      
      address <- res$coordenadas_distancias$coordd$lpcd$pcd$ldt 
      RC <- paste0(res$coordenadas_distancias$coordd$lpcd$pcd$pc$pc1,
                   res$coordenadas_distancias$coordd$lpcd$pcd$pc$pc2)
      
    }
    
  else if (!is.null(res$coordenadas_distancias$coordd$lpcd) && distancia != '0'){
      
      address <- lapply(res$coordenadas_distancias$coordd$lpcd,FUN = '[[',3)
      address <- do.call(rbind,address)
      address <- as.vector(address)
      
      RC <- lapply(res$coordenadas_distancias$coordd$lpcd,FUN = '[[',1)
      RC <- do.call(rbind,RC)
      RC <- as.data.frame(RC, row.names = F)
      RC <- paste0(RC$pc1,RC$pc2)

    
    
    res <- data.frame(address = address, RC = RC, SRS  = SRS)
    
    }
    
    
 else{res <- data.frame(address = NA, RC = NA, SRS  = NA)}
  
  return(res)
}



  
  
  



near_rc <- function(lat,lon,SRS = NA){
  
  # QUERY FOR THE SRS
  
  if (SRS %in% coordinates){
    res <- near_rc_srs(lat,lon,SRS)
  }
  
  
  # QUERY FOR ALL POSSIBLES SRS
  
  else{
    res <- lapply(coordinates, function(x){near_rc_srs(lat,lon,x)})
    res <- data.frame(do.call(rbind,res))
    res <- res[!(is.na(res$address) & is.na(res$RC)),]
  }
  
  return(res)
}