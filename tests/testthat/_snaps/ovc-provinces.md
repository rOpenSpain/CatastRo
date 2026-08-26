# catr_ovc_get_cod_provinces() returns NULL when offline

    Code
      fend <- catr_ovc_get_cod_provinces()
    Message
      x No internet connection detected.
      Returning "NULL" because the request cannot run.

# catr_ovc_get_cod_provinces() returns NULL after an HTTP 404

    Code
      fend <- catr_ovc_get_cod_provinces()
    Message
      x HTTP error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaProvincia?>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      Returning "NULL" because the request failed.

# catr_ovc_get_cod_provinces() returns matching province codes

    Code
      df <- catr_ovc_get_cod_provinces(verbose = TRUE)
    Message
      i Requesting <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaProvincia?>.
      v Request succeeded.

