# Test offline

    Code
      fend <- catr_ovc_get_cod_provinces()
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Test 404 all

    Code
      fend <- catr_ovc_get_cod_provinces()
    Message
      x HTTP error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaProvincia?>.
      ! If this looks like a package bug, please open an issue at <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL" because the request failed.

