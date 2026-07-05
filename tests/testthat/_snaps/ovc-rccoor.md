# Test offline

    Code
      fend <- catr_ovc_get_rccoor(lat = 40.9632, lon = -5.67142, srs = 4326)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Test 404 all

    Code
      fend <- catr_ovc_get_rccoor(lat = 40.9632, lon = -5.67142, srs = 4326)
    Message
      x HTTP error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR?SRS=EPSG%3A4326&Coordenada_X=-5.67142&Coordenada_Y=40.9632>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      > Returning "NULL" because the request failed.

