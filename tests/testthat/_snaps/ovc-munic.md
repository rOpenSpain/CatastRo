# Test offline

    Code
      fend <- catr_ovc_get_cod_munic(4, 5)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Test 404 all

    Code
      fend <- catr_ovc_get_cod_munic(4, 5)
    Message
      x HTTP error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaMunicipioCodigos?%2FCodigoProvincia=&CodigoProvincia=4&CodigoMunicipio=5&CodigoMunicipioIne=>.
      ! If this looks like a package bug, please open an issue at <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL" because the request failed.

# Callejero munic

    Code
      catr_ovc_get_cod_munic(2)
    Condition
      Error in `catr_ovc_get_cod_munic()`:
      ! Provide a non-"NULL" value for either `cmun` or `cmun_ine`.

