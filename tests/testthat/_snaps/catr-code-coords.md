# Test offline

    Code
      fend <- catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326,
      cache_dir = cdir)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

---

    Code
      fend <- catr_get_code_from_coords(mapSpain::esp_get_prov_siane("Caceres"),
      cache_dir = cdir)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Test 404 all

    Code
      fend <- catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326,
      cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaMunicipioCodigos?%2FCodigoProvincia=&CodigoProvincia=38&CodigoMunicipio=&CodigoMunicipioIne=038>.
      ! If this looks like a package bug, please open an issue at <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL" because the request failed.

---

    Code
      fend <- catr_get_code_from_coords(mapSpain::esp_get_prov_siane("Caceres"),
      cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaMunicipioCodigos?%2FCodigoProvincia=&CodigoProvincia=10&CodigoMunicipio=&CodigoMunicipioIne=125>.
      ! If this looks like a package bug, please open an issue at <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL" because the request failed.

# Test 404 mapSpain

    Code
      fend <- catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326,
      cache_dir = cdir)
    Message
      i Mocking mapSpain

