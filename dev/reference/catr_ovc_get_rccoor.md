# OVCCoordenadas: reverse geocode coordinates

Query the OVCCoordenadas [Consulta
RCCOOR](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR)
service to retrieve the cadastral reference associated with a pair of
coordinates.

## Usage

``` r
catr_ovc_get_rccoor(lat, lon, srs = 4326, verbose = FALSE)
```

## Arguments

- lat:

  Latitude for the query, expressed in the SRS/CRS defined by `srs`.

- lon:

  Longitude for the query, expressed in the SRS/CRS defined by `srs`.

- srs:

  SRS/CRS to use in the query. To see allowed values, use
  [catr_srs_values](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
  specifically the `ovc_service` column.

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

A [tibble](https://dplyr.tidyverse.org/reference/defunct.html) as
described in **Details**. Returns `NULL` if the request fails.

## Details

If the API returns no results, this function returns a
[tibble](https://dplyr.tidyverse.org/reference/defunct.html) containing
only query information.

On a successful query, this function returns a
[tibble](https://dplyr.tidyverse.org/reference/defunct.html) with one
row per cadastral reference, including the following columns:

- `geo.xcen`, `geo.ycen`, `geo.srs`: Input arguments of the query.

- `refcat`: Cadastral reference.

- `address`: Address as recorded in the Spanish Cadastre.

- Remaining fields: See the API documentation.

## References

[Consulta
RCCOOR](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR).

## See also

Convert coordinates and cadastral references:
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor_distancia.md)

Work with cadastral references:
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor_distancia.md)

## Examples

``` r
# \donttest{
catr_ovc_get_rccoor(
  lat = 38.6196566583596,
  lon = -3.45624183836806,
  srs = 4326
)
#> # A tibble: 1 × 8
#>   refcat         address           pc.pc1 pc.pc2 geo.xcen geo.ycen geo.srs ldt  
#>   <chr>          <chr>             <chr>  <chr>     <dbl>    <dbl> <chr>   <chr>
#> 1 13077A01800011 DS DISEMINADO  P… 13077… 18000…    -3.46     38.6 EPSG:4… DS D…
# }
```
