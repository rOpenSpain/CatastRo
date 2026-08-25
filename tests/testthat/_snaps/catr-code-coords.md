# coordinate lookup returns NULL when offline

    Code
      fend <- catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326,
      cache_dir = cdir)
    Message
      x No internet connection detected.
      Returning "NULL" because the request cannot run.

---

    Code
      fend <- catr_get_code_from_coords(mapSpain::esp_get_prov_siane("Caceres"),
      cache_dir = cdir)
    Message
      x No internet connection detected.
      Returning "NULL" because the request cannot run.

# coordinate lookup returns NULL after an HTTP 404

    Code
      fend <- catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326,
      cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaMunicipioCodigos?%2FCodigoProvincia=&CodigoProvincia=38&CodigoMunicipio=&CodigoMunicipioIne=038>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      Returning "NULL" because the request failed.

---

    Code
      fend <- catr_get_code_from_coords(mapSpain::esp_get_prov_siane("Caceres"),
      cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaMunicipioCodigos?%2FCodigoProvincia=&CodigoProvincia=10&CodigoMunicipio=&CodigoMunicipioIne=125>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      Returning "NULL" because the request failed.

# coordinate lookup returns NULL when the mapSpain request fails

    Code
      fend <- catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326,
      cache_dir = cdir)
    Message
      i Mocking mapSpain

# coordinate lookup returns the municipality code for a location

    Code
      df <- catr_get_code_from_coords(c(0, 0))
    Condition
      Error in `validate_vector_with_srs()`:
      ! You must also provide `srs` when `x` is a double vector.

---

    Code
      df <- catr_get_code_from_coords(c(0, 0, 0))
    Condition
      Error in `validate_vector_with_srs()`:
      ! `x` must have length 2, not 3.

---

    Code
      df <- catr_get_code_from_coords(c(0, 0), srs = 4326)
    Message
      ! No municipality found for these coordinates.

---

    Code
      catr_get_code_from_coords(m, cache_dir = cdir)
    Message
      i Using the first geometry because 2 were provided.
    Output
      # A tibble: 1 x 12
        munic  catr_to catr_munic catrcode cpro  cmun  inecode nm    cd    cmc   cp   
        <chr>  <chr>   <chr>      <chr>    <chr> <chr> <chr>   <chr> <chr> <chr> <chr>
      1 SANTO~ 33      064        33064    33    064   33064   SANT~ 33    64    33   
      # i 1 more variable: cm <chr>

