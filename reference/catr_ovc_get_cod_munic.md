# OVCCallejero: Extract the code of a municipality

Implementation of the OVCCallejero service
[ConsultaMunicipioCodigos](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaMunicipioCodigos).
Returns names and codes of a municipality as per the Cadastre and the
INE (National Statistics Institute).

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
See **Details**

## Details

On a successful query, the function returns a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) with
one row including the following columns:

- `munic`: Name of the municipality as per the Cadastre.

- `catr_to`: Cadastral territorial office code.

- `catr_munic`: Municipality code as recorded on the Cadastre.

- `catrcode`: Full Cadastral code for the municipality.

- `cpro`: Province code as per the INE.

- `cmun`: Municipality code as per the INE.

- `inecode`: Full INE code for the municipality.

- Rest of fields: Check the API Docs.

## References

[ConsultaMunicipioCodigos](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaMunicipioCodigos).

## See also

[`mapSpain::esp_get_munic_siane()`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic_siane.html)
to get shapes of municipalities, including the INE code.

OVCCoordenadas API:
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

ab
#> # A tibble: 1 × 12
#>   munic  catr_to catr_munic catrcode cpro  cmun  inecode nm    cd    cmc   cp   
#>   <chr>  <chr>   <chr>      <chr>    <chr> <chr> <chr>   <chr> <chr> <chr> <chr>
#> 1 ALBAC… 02      900        02900    02    003   02003   ALBA… 2     900   2    
#> # ℹ 1 more variable: cm <chr>

# Same query using the INE code

ab2 <- catr_ovc_get_cod_munic(cpro = 2, cmun_ine = 3)

ab2
#> # A tibble: 1 × 12
#>   munic  catr_to catr_munic catrcode cpro  cmun  inecode nm    cd    cmc   cp   
#>   <chr>  <chr>   <chr>      <chr>    <chr> <chr> <chr>   <chr> <chr> <chr> <chr>
#> 1 ALBAC… 02      900        02900    02    003   02003   ALBA… 2     900   2    
#> # ℹ 1 more variable: cm <chr>
# }
```
