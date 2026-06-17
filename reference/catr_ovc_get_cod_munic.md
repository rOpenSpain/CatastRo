# OVCCallejero: extract the code of a municipality

Implementation of the OVCCallejero service
[ConsultaMunicipioCodigos](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaMunicipioCodigos).
Returns names and codes of a municipality according to the Cadastre and
the INE (National Statistics Institute).

## Usage

``` r
catr_ovc_get_cod_munic(cpro, cmun = NULL, cmun_ine = NULL, verbose = FALSE)
```

## Arguments

- cpro:

  The code of a province, as provided by
  [`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md).

- cmun, cmun_ine:

  Code of a municipality, as recorded on the Spanish Cadastre (`cmun`)
  or the National Statistics Institute. Either `cmun` or `cmun_ine` must
  be provided.

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).
See **Details**.

## Details

On a successful query, this function returns a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) with
one row including the following columns:

- `munic`: Name of the municipality according to the Cadastre.

- `catr_to`: Cadastral territorial office code.

- `catr_munic`: Municipality code as recorded on the Cadastre.

- `catrcode`: Full Cadastral code for the municipality.

- `cpro`: Province code according to the INE.

- `cmun`: Municipality code according to the INE.

- `inecode`: Full INE code for the municipality.

- Remaining fields: Check the API documentation.

## References

[ConsultaMunicipioCodigos](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaMunicipioCodigos).

## See also

[`mapSpain::esp_get_munic_siane()`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic_siane.html)
to get shapes of municipalities, including the INE code.

Related OVCCallejero functions:
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)

Other search:
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md),
[`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/reference/catr_get_code_from_coords.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)

## Examples

``` r
# \donttest{
# Get municipality by cadastral code
ab <- catr_ovc_get_cod_munic(cpro = 2, cmun = 900)
#> ✖ OVC service error 0: problemas tecnicos. Tiempo estimado desde las 15.15H hasta las 19.H.
#> 
#> Disculpe las molestias.

ab
#> # A tibble: 1 × 1
#>   name 
#>   <lgl>
#> 1 NA   

# Same query using the INE code

ab2 <- catr_ovc_get_cod_munic(cpro = 2, cmun_ine = 3)
#> ✖ OVC service error 0: problemas tecnicos. Tiempo estimado desde las 15.15H hasta las 19.H.
#> 
#> Disculpe las molestias.

ab2
#> # A tibble: 1 × 1
#>   name 
#>   <lgl>
#> 1 NA   
# }
```
