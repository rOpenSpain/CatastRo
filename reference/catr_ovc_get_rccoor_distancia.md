# OVCCoordenadas: Reverse geocode cadastral references on a region

Implementation of the OVCCoordenadas service [Consulta RCCOOR
Distancia](http://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR_Distancia).

Return the cadastral reference found on a set of coordinates. If no
cadastral references are found, the API returns a list of the cadastral
references found on an area of 50 square meters around the requested
coordinates.

## Usage

``` r
catr_ovc_get_rccoor_distancia(lat, lon, srs = 4326, verbose = FALSE)
```

## Arguments

- lat:

  Latitude to use on the query. It should be specified in the same in
  the CRS/SRS `specified` by `srs`.

- lon:

  Longitude to use on the query. It should be specified in the same in
  the CRS/SRS `specified` by `srs`.

- srs:

  SRS/CRS to use on the query. To check the admitted values check
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
  specifically the `ovc_service` column.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html). See
**Details**

## Details

When the API does not provide any result, the function returns a
[`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with the
input parameters only.

On a successful query, the function returns a
[`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with one
row by cadastral reference, including the following columns:

- `geo.xcen`, `geo.ycen`, `geo.srs`: Input parameters of the query.

- `refcat`: Cadastral reference.

- `address`: Address as it is recorded on the Cadastre.

- `cmun_ine`: Municipality code as registered on the INE (National
  Statistics Institute).

- Rest of fields: Check the API Docs.

## References

[Consulta RCCOOR
Distancia](http://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR_Distancia).

## See also

[catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
[`vignette("ovcservice", package = "CatastRo")`](https://ropenspain.github.io/CatastRo/articles/ovcservice.md)

OVCCoordenadas API:
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md),
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md)

Other cadastral references:
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md)

## Examples

``` r
# \donttest{
catr_ovc_get_rccoor_distancia(
  lat = 40.963200,
  lon = -5.671420,
  srs = 4326
)
#> # A tibble: 7 × 14
#>   geo.xcen geo.ycen geo.srs   refcat  address cmun_ine pc.pc1 pc.pc2 dt.loine.cp
#>      <dbl>    <dbl> <chr>     <chr>   <chr>   <chr>    <chr>  <chr>  <chr>      
#> 1    -5.67     41.0 EPSG:4326 528380… CL SAN… 37274    52838… TL735… 37         
#> 2    -5.67     41.0 EPSG:4326 528383… CT SAN… 37274    52838… TL735… 37         
#> 3    -5.67     41.0 EPSG:4326 528341… CL SAN… 37274    52834… TL735… 37         
#> 4    -5.67     41.0 EPSG:4326 538380… CT SAN… 37274    53838… TL735… 37         
#> 5    -5.67     41.0 EPSG:4326 538480… CL GAR… 37274    53848… TL735… 37         
#> 6    -5.67     41.0 EPSG:4326 538380… CL ENC… 37274    53838… TL735… 37         
#> 7    -5.67     41.0 EPSG:4326 528383… CL SAN… 37274    52838… TL735… 37         
#> # ℹ 5 more variables: dt.loine.cm <chr>, dt.lourb.dir.cv <chr>,
#> #   dt.lourb.dir.pnp <chr>, ldt <chr>, dis <chr>
# }
```
