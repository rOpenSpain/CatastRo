lat =  38.6196566583596
lon = -3.45624183836806
srs = 4326

# Sanity checks

valid_srs <- CatastRo::catr_srs_values
valid_srs <- valid_srs[valid_srs$ovc_service == TRUE, "SRS"]
valid <- as.character(valid_srs$SRS)

if (!as.character(srs) %in% valid){
  stop("'srs' for OVC should be one of ",
       paste0("'", valid, "'", collapse =", " ),
       ".\n\nSee CatastRo::catr_srs_values")
}

srs = paste0("EPSG:", srs)

# Prepare query
##  Build url

https://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR_Distancia?SRS=EPSG:4326&Coordenada_X=-3.45624183836806&Coordenada_Y=38.6196566583596
api_entry <- paste0("https://ovc.catastro.meh.es/ovcservweb",
                    "OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR_Distancia?"




params <- list(SRS = paste0("EPSG:", srs),
                  Coordenada_X = lon,
                  Coordenada_Y = lat)


# Get params
endparams <- paste0(paste0(names(params),"=", params), collapse = "&")

# Build full url
url <- utils::URLencode(
  paste0(api_entry,endparams)
)



# Tempfile

filename = basename(tempfile(fileext = ".xml"))

httr::GET(url)

catr_hlp_dwnload(url, filename = filename,
                 cache = TRUE,
                 cache_dir = tempdir(),
                 update_cache = FALSE,
                 verbose = TRUE)


download.file(url,
              "a.xml")


# Get

res <- GET(
  url = "http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR_Distancia",
  query = list(Coordenada_X = lon, Coordenada_Y = lat, SRS = srs),
  ua = user_agent("CatastRo (pack)")
)
httr::set_config(httr::config(ssl_verifypeer = FALSE))
result <- httr::GET(url)

