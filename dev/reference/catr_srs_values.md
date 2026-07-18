# Reference SRS codes for [CatastRo](https://CRAN.R-project.org/package=CatastRo) services

A [tibble](https://dplyr.tidyverse.org/reference/defunct.html)
containing valid SRS values, also known as CRS values, for each API
service. Values are represented as [EPSG
codes](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset).

## Format

A [tibble](https://dplyr.tidyverse.org/reference/defunct.html) with 16
rows and columns:

- SRS:

  Spatial reference system (SRS) value, also known as a coordinate
  reference system (CRS), identified by the corresponding
  [EPSG](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset)
  code.

- Description:

  Description of the SRS/EPSG code.

- ovc_service:

  Logical. Whether this code is valid for OVC services.

- wfs_service:

  Logical. Whether this code is valid for WFS INSPIRE services.

## Details

Table: Content of catr_srs_values

|         |                          |                 |                 |
|---------|--------------------------|-----------------|-----------------|
| **SRS** | **Description**          | **ovc_service** | **wfs_service** |
| `3785`  | `Web Mercator`           | `FALSE`         | `TRUE`          |
| `3857`  | `Web Mercator`           | `FALSE`         | `TRUE`          |
| `4230`  | `Geográficas en ED 50`   | `TRUE`          | `FALSE`         |
| `4258`  | `Geográficas en ETRS89`  | `TRUE`          | `TRUE`          |
| `4326`  | `Geográficas en WGS 84`  | `TRUE`          | `TRUE`          |
| `23029` | `UTM huso 29N en ED50`   | `TRUE`          | `FALSE`         |
| `23030` | `UTM huso 30N en ED50`   | `TRUE`          | `FALSE`         |
| `23031` | `UTM huso 31N en ED50`   | `TRUE`          | `FALSE`         |
| `25829` | `UTM huso 29N en ETRS89` | `TRUE`          | `TRUE`          |
| `25830` | `UTM huso 30N en ETRS89` | `TRUE`          | `TRUE`          |
| `25831` | `UTM huso 31N en ETRS89` | `TRUE`          | `TRUE`          |
| `32627` | `UTM huso 27N en WGS 84` | `TRUE`          | `FALSE`         |
| `32628` | `UTM huso 28N en WGS 84` | `TRUE`          | `FALSE`         |
| `32629` | `UTM huso 29N en WGS 84` | `TRUE`          | `FALSE`         |
| `32630` | `UTM huso 30N en WGS 84` | `TRUE`          | `FALSE`         |
| `32631` | `UTM huso 31N en WGS 84` | `TRUE`          | `FALSE`         |

## References

- [OVCCoordenadas](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx).

- [WFS INSPIRE
  service](https://www.catastro.hacienda.gob.es/webinspire/index.html).

## See also

[`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html).

## Examples

``` r
data("catr_srs_values")

# OVC valid codes
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

catr_srs_values |> filter(ovc_service)
#> # A tibble: 14 × 4
#>    SRS   Description            ovc_service wfs_service
#>    <chr> <chr>                  <lgl>       <lgl>      
#>  1 4230  Geográficas en ED 50   TRUE        FALSE      
#>  2 4258  Geográficas en ETRS89  TRUE        TRUE       
#>  3 4326  Geográficas en WGS 84  TRUE        TRUE       
#>  4 23029 UTM huso 29N en ED50   TRUE        FALSE      
#>  5 23030 UTM huso 30N en ED50   TRUE        FALSE      
#>  6 23031 UTM huso 31N en ED50   TRUE        FALSE      
#>  7 25829 UTM huso 29N en ETRS89 TRUE        TRUE       
#>  8 25830 UTM huso 30N en ETRS89 TRUE        TRUE       
#>  9 25831 UTM huso 31N en ETRS89 TRUE        TRUE       
#> 10 32627 UTM huso 27N en WGS 84 TRUE        FALSE      
#> 11 32628 UTM huso 28N en WGS 84 TRUE        FALSE      
#> 12 32629 UTM huso 29N en WGS 84 TRUE        FALSE      
#> 13 32630 UTM huso 30N en WGS 84 TRUE        FALSE      
#> 14 32631 UTM huso 31N en WGS 84 TRUE        FALSE      

# WFS valid codes

catr_srs_values |> filter(wfs_service)
#> # A tibble: 7 × 4
#>   SRS   Description            ovc_service wfs_service
#>   <chr> <chr>                  <lgl>       <lgl>      
#> 1 3785  Web Mercator           FALSE       TRUE       
#> 2 3857  Web Mercator           FALSE       TRUE       
#> 3 4258  Geográficas en ETRS89  TRUE        TRUE       
#> 4 4326  Geográficas en WGS 84  TRUE        TRUE       
#> 5 25829 UTM huso 29N en ETRS89 TRUE        TRUE       
#> 6 25830 UTM huso 30N en ETRS89 TRUE        TRUE       
#> 7 25831 UTM huso 31N en ETRS89 TRUE        TRUE       

# Use with sf::st_crs()

catr_srs_values |>
  filter(wfs_service & ovc_service) |>
  print() |>
  # Select the first value.
  slice_head(n = 1) |>
  pull(SRS) |>
  # Convert to a CRS.
  sf::st_crs(.)
#> # A tibble: 5 × 4
#>   SRS   Description            ovc_service wfs_service
#>   <chr> <chr>                  <lgl>       <lgl>      
#> 1 4258  Geográficas en ETRS89  TRUE        TRUE       
#> 2 4326  Geográficas en WGS 84  TRUE        TRUE       
#> 3 25829 UTM huso 29N en ETRS89 TRUE        TRUE       
#> 4 25830 UTM huso 30N en ETRS89 TRUE        TRUE       
#> 5 25831 UTM huso 31N en ETRS89 TRUE        TRUE       
#> Error in st_crs.character(pull(slice_head(print(filter(catr_srs_values,     wfs_service & ovc_service)), n = 1), SRS), .): invalid crs: 4258
```
