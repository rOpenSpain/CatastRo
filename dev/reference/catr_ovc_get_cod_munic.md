# OVCCallejero: Get municipality codes

Query the OVCCallejero
[ConsultaMunicipioCodigos](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaMunicipioCodigos)
service to retrieve municipality names and codes from the Spanish
Cadastre and the National Statistics Institute (INE).

## Usage

``` r
catr_ovc_get_cod_munic(cpro, cmun = NULL, cmun_ine = NULL, verbose = FALSE)
```

## Arguments

- cpro:

  Province code returned by
  [`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_provinces.md).

- cmun, cmun_ine:

  Municipality code as recorded by the Spanish Cadastre (`cmun`) or the
  National Statistics Institute (`cmun_ine`). Either `cmun` or
  `cmun_ine` must be provided.

- verbose:

  Logical. Whether to display informational messages.

## Value

A [tibble](https://dplyr.tidyverse.org/reference/defunct.html) as
described in **Details**. Returns `NULL` if the request fails.

## Details

On a successful query, this function returns a one-row
[tibble](https://dplyr.tidyverse.org/reference/defunct.html) with the
following columns:

- `munic`: Municipality name used by the Spanish Cadastre.

- `catr_to`: Cadastral territorial office code.

- `catr_munic`: Municipality code as recorded by the Cadastre.

- `catrcode`: Full cadastral code for the municipality.

- `cpro`: Province code according to the INE.

- `cmun`: Municipality code according to the INE.

- `inecode`: Full INE code for the municipality.

- Remaining fields: See the API documentation.

## References

[ConsultaMunicipioCodigos](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaMunicipioCodigos).

## See also

[`mapSpain::esp_get_munic_siane()`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic_siane.html)
to get shapes of municipalities, including the INE code.

Search for cadastral identifiers:
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md),
[`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_get_code_from_coords.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_provinces.md)

Query OVC web services:
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_provinces.md),
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor_distancia.md)

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
