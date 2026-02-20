# Test offline

    Code
      fend <- catr_ovc_get_cpmrc("9872023VH5797S")
    Message
      x Offline
      > Returning "NULL"

# Test 404 all

    Code
      fend <- catr_ovc_get_cpmrc("9872023VH5797S")
    Message
      x Error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC?RC=9872023VH5797S&SRS=EPSG%3A4326&Provincia=&Municipio=>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

