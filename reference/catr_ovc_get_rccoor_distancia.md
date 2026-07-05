# OVCCoordenadas: reverse geocode cadastral references near coordinates

Query the OVCCoordenadas [Consulta RCCOOR
Distancia](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR_Distancia)
service to retrieve cadastral references near a pair of coordinates. If
no exact match is found, the API searches within 50 square meters of the
requested coordinates.

## Usage

``` r
catr_ovc_get_rccoor_distancia(lat, lon, srs = 4326, verbose = FALSE)
```

## Arguments

- lat:

  Latitude for the query, expressed in the CRS/SRS defined by `srs`.

- lon:

  Longitude for the query, expressed in the CRS/SRS defined by `srs`.

- srs:

  SRS/CRS to use in the query. To see allowed values, use
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
  specifically the `ovc_service` column.

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) as
described in **Details**. Returns `NULL` if the request fails.

## Details

If the API returns no results, this function returns a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
containing only the input arguments.

On a successful query, this function returns a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) with
one row per cadastral reference, including the following columns:

- `geo.xcen`, `geo.ycen`, `geo.srs`: Input arguments of the query.

- `refcat`: Cadastral reference.

- `address`: Address as recorded in the Cadastre.

- `cmun_ine`: Municipality code as registered on the INE (National
  Statistics Institute).

- Remaining fields: See the API documentation.

## References

[Consulta RCCOOR
Distancia](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR_Distancia).

## See also

Convert coordinates and cadastral references:
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md)

Work with cadastral references:
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
