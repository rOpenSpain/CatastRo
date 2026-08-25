# OVCCallejero: Get province codes

Query the OVCCallejero
[ConsultaProvincia](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaProvincia)
service to retrieve provinces and their Spanish Cadastre codes.

## Usage

``` r
catr_ovc_get_cod_provinces(verbose = FALSE)
```

## Arguments

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

A [tibble](https://dplyr.tidyverse.org/reference/defunct.html) with
province names and codes. Returns `NULL` if the request fails.

## References

[ConsultaProvincia](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaProvincia).

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
