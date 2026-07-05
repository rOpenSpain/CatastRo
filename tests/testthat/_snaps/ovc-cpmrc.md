# Test offline

    Code
      fend <- catr_ovc_get_cpmrc("9872023VH5797S")
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Test 404 all

    Code
      fend <- catr_ovc_get_cpmrc("9872023VH5797S")
    Message
      x HTTP error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC?RC=9872023VH5797S&SRS=EPSG%3A4326&Provincia=&Municipio=>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      > Returning "NULL" because the request failed.

