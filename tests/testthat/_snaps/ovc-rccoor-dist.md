# Test offline

    Code
      fend <- catr_ovc_get_rccoor_distancia(lat = 40.9632, lon = -5.67142, srs = 4326)
    Message
      x Offline
      > Returning "NULL"

# Test 404 all

    Code
      fend <- catr_ovc_get_rccoor_distancia(lat = 40.9632, lon = -5.67142, srs = 4326)
    Message
      x Error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR_Distancia?SRS=EPSG%3A4326&Coordenada_X=-5.67142&Coordenada_Y=40.9632>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

