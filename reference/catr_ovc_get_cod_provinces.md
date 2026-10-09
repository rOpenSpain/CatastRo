# OVCCallejero: Get province codes

Query the OVCCallejero
[ConsultaProvincia](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaProvincia)
service to retrieve provinces and their INE codes. Only provinces within
the jurisdiction of the Directorate General for Cadastre are included.

## Usage

``` r
catr_ovc_get_cod_provinces(verbose = FALSE)
```

## Arguments

- verbose:

  Logical. Whether to display informational messages.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
with province names and codes. Returns
[`NULL`](https://rdrr.io/r/base/NULL.html) if the request fails.

## References

[ConsultaProvincia](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaProvincia).

## See also

[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md)
uses a province code as `cpro` to look up municipality codes.

Search for cadastral identifiers:
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md),
[`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/reference/catr_get_code_from_coords.md),
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md)

Query OVC web services:
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md),
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)

## Examples

``` r
# \donttest{
catr_ovc_get_cod_provinces()
#> ✖ HTTP error 403 (Forbidden): <http://ovc.catastro.meh.es/ovcservweb//ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaProvincia?>.
#> ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
#> Returning `NULL` because the request failed.
#> NULL
# }
```
