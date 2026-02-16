# OVCCallejero: Extract a list of provinces with their codes

Implementation of the OVCCallejero service
[ConsultaProvincia](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaProvincia).

Return a list of the provinces included on the Spanish Cadastre.

## Usage

``` r
catr_ovc_get_cod_provinces(verbose = FALSE)
```

## Arguments

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html).

## References

[ConsultaProvincia](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaProvincia).

## See also

OVCCoordenadas API:
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md)

Other search:
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md),
[`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/reference/catr_get_code_from_coords.md),
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md)

## Examples

``` r
if (FALSE) { # tolower(Sys.info()[["sysname"]]) != "linux"
# \donttest{

catr_ovc_get_cod_provinces()
# }
}
```
