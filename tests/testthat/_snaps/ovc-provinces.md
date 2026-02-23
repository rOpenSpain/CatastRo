# Test offline

    Code
      fend <- catr_ovc_get_cod_provinces()
    Message
      x Offline
      > Returning "NULL"

# Test 404 all

    Code
      fend <- catr_ovc_get_cod_provinces()
    Message
      x Error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaProvincia?>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

