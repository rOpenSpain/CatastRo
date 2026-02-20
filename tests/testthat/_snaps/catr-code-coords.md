# Test offline

    Code
      fend <- catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326,
      cache_dir = cdir)
    Message
      x Offline
      > Returning "NULL"

---

    Code
      fend <- catr_get_code_from_coords(mapSpain::esp_get_prov("Caceres"), cache_dir = cdir)
    Message
      x Offline
      > Returning "NULL"

# Test 404 all

    Code
      fend <- catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326,
      cache_dir = cdir)
    Message
      x Error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaMunicipioCodigos?%2FCodigoProvincia=&CodigoProvincia=38&CodigoMunicipio=&CodigoMunicipioIne=038>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

---

    Code
      fend <- catr_get_code_from_coords(mapSpain::esp_get_prov("Caceres"), cache_dir = cdir)
    Message
      x Error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaMunicipioCodigos?%2FCodigoProvincia=&CodigoProvincia=10&CodigoMunicipio=&CodigoMunicipioIne=125>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

# Test 404 mapSpain

    Code
      fend <- catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326,
      cache_dir = cdir)
    Message
      i Mocking mapSpain

