# Reference SRS codes for [CatastRo](https://CRAN.R-project.org/package=CatastRo) APIs

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html)
including the valid SRS (also known as CRS) values that may be used on
each API service. The values are provided as [EPSG
codes](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset).

## Format

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with 16
rows and columns:

- SRS:

  Spatial Reference System (CRS) value, identified by the corresponding
  [EPSG](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset)
  code.

- Description:

  Description of the SRS/EPSG code.

- ovc_service:

  Logical. Is this code valid on OVC services?

- wfs_service:

  Logical. Is this code valid on INSPIRE WFS services?

## Details

Table: Content of catr_srs_values

|         |                          |                 |                 |
|---------|--------------------------|-----------------|-----------------|
| **SRS** | **Description**          | **ovc_service** | **wfs_service** |
| `3785`  | `Web Mercator`           | `FALSE`         | `TRUE`          |
| `3857`  | `Web Mercator`           | `FALSE`         | `TRUE`          |
| `4230`  | `Geográficas en ED 50`   | `TRUE`          | `FALSE`         |
| `4258`  | `Geográficas en ETRS89`  | `TRUE`          | `TRUE`          |
| `4326`  | `Geográficas en WGS 80`  | `TRUE`          | `TRUE`          |
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

- [INSPIRE WFS
  Service](https://www.catastro.hacienda.gob.es/webinspire/index.html).

## See also

[`sf::st_crs()`](https://r-spatial.github.io/sf/reference/st_crs.html).

Other databases:
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md)

Other INSPIRE WFS services:
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)

OVCCoordenadas API:
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)

## Examples

``` r
data("catr_srs_values")

# OVC valid codes
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

catr_srs_values %>% filter(ovc_service == TRUE)
#> # A tibble: 14 × 4
#>      SRS Description            ovc_service wfs_service
#>    <dbl> <chr>                  <lgl>       <lgl>      
#>  1  4230 Geográficas en ED 50   TRUE        FALSE      
#>  2  4258 Geográficas en ETRS89  TRUE        TRUE       
#>  3  4326 Geográficas en WGS 80  TRUE        TRUE       
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

catr_srs_values %>% filter(wfs_service == TRUE)
#> # A tibble: 7 × 4
#>     SRS Description            ovc_service wfs_service
#>   <dbl> <chr>                  <lgl>       <lgl>      
#> 1  3785 Web Mercator           FALSE       TRUE       
#> 2  3857 Web Mercator           FALSE       TRUE       
#> 3  4258 Geográficas en ETRS89  TRUE        TRUE       
#> 4  4326 Geográficas en WGS 80  TRUE        TRUE       
#> 5 25829 UTM huso 29N en ETRS89 TRUE        TRUE       
#> 6 25830 UTM huso 30N en ETRS89 TRUE        TRUE       
#> 7 25831 UTM huso 31N en ETRS89 TRUE        TRUE       

# Use with sf::st_crs()

catr_srs_values %>%
  filter(wfs_service == TRUE & ovc_service == TRUE) %>%
  print() %>%
  # First value
  slice_head(n = 1) %>%
  pull(SRS) %>%
  # As crs
  sf::st_crs(.)
#> # A tibble: 5 × 4
#>     SRS Description            ovc_service wfs_service
#>   <dbl> <chr>                  <lgl>       <lgl>      
#> 1  4258 Geográficas en ETRS89  TRUE        TRUE       
#> 2  4326 Geográficas en WGS 80  TRUE        TRUE       
#> 3 25829 UTM huso 29N en ETRS89 TRUE        TRUE       
#> 4 25830 UTM huso 30N en ETRS89 TRUE        TRUE       
#> 5 25831 UTM huso 31N en ETRS89 TRUE        TRUE       
#> Coordinate Reference System:
#>   User input: EPSG:4258 
#>   wkt:
#> GEOGCRS["ETRS89",
#>     ENSEMBLE["European Terrestrial Reference System 1989 ensemble",
#>         MEMBER["European Terrestrial Reference Frame 1989"],
#>         MEMBER["European Terrestrial Reference Frame 1990"],
#>         MEMBER["European Terrestrial Reference Frame 1991"],
#>         MEMBER["European Terrestrial Reference Frame 1992"],
#>         MEMBER["European Terrestrial Reference Frame 1993"],
#>         MEMBER["European Terrestrial Reference Frame 1994"],
#>         MEMBER["European Terrestrial Reference Frame 1996"],
#>         MEMBER["European Terrestrial Reference Frame 1997"],
#>         MEMBER["European Terrestrial Reference Frame 2000"],
#>         MEMBER["European Terrestrial Reference Frame 2005"],
#>         MEMBER["European Terrestrial Reference Frame 2014"],
#>         MEMBER["European Terrestrial Reference Frame 2020"],
#>         ELLIPSOID["GRS 1980",6378137,298.257222101,
#>             LENGTHUNIT["metre",1]],
#>         ENSEMBLEACCURACY[0.1]],
#>     PRIMEM["Greenwich",0,
#>         ANGLEUNIT["degree",0.0174532925199433]],
#>     CS[ellipsoidal,2],
#>         AXIS["geodetic latitude (Lat)",north,
#>             ORDER[1],
#>             ANGLEUNIT["degree",0.0174532925199433]],
#>         AXIS["geodetic longitude (Lon)",east,
#>             ORDER[2],
#>             ANGLEUNIT["degree",0.0174532925199433]],
#>     USAGE[
#>         SCOPE["Spatial referencing."],
#>         AREA["Europe - onshore and offshore: Albania; Andorra; Austria; Belgium; Bosnia and Herzegovina; Bulgaria; Croatia; Czechia; Denmark; Estonia; Faroe Islands; Finland; France; Germany; Gibraltar; Greece; Hungary; Ireland; Italy; Kosovo; Latvia; Liechtenstein; Lithuania; Luxembourg; Malta; Moldova; Monaco; Montenegro; Netherlands; North Macedonia; Norway including Svalbard and Jan Mayen; Poland; Portugal - mainland; Romania; San Marino; Serbia; Slovakia; Slovenia; Spain - mainland and Balearic islands; Sweden; Switzerland; United Kingdom (UK) including Channel Islands and Isle of Man; Vatican City State."],
#>         BBOX[33.26,-16.1,84.73,38.01]],
#>     ID["EPSG",4258]]
```
