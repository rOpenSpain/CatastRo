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

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).

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
# \donttest{

catr_ovc_get_cod_provinces()
#> # A tibble: 48 × 2
#>    cpine np       
#>    <chr> <chr>    
#>  1 15    A CORUÑA 
#>  2 03    ALACANT  
#>  3 02    ALBACETE 
#>  4 04    ALMERIA  
#>  5 33    ASTURIAS 
#>  6 05    AVILA    
#>  7 06    BADAJOZ  
#>  8 08    BARCELONA
#>  9 09    BURGOS   
#> 10 10    CACERES  
#> # ℹ 38 more rows
# }
```
