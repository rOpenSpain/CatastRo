# Test offline

    Code
      fend <- catr_ovc_get_cod_munic(4, 5)
    Message
      x Offline
      > Returning "NULL"

# Test 404 all

    Code
      fend <- catr_ovc_get_cod_munic(4, 5)
    Message
      x Error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaMunicipioCodigos?%2FCodigoProvincia=&CodigoProvincia=4&CodigoMunicipio=5&CodigoMunicipioIne=>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

# Callejero munic

    Code
      catr_ovc_get_cod_munic(2)
    Condition
      Error in `catr_ovc_get_cod_munic()`:
      ! Please provide a non-"NULL" value either on `cmun` or `cmun_ine`.

