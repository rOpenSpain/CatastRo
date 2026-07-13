# OVCCoordenadas: find cadastral references near coordinates

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

  Latitude for the query, expressed in the SRS/CRS defined by `srs`.

- lon:

  Longitude for the query, expressed in the SRS/CRS defined by `srs`.

- srs:

  SRS/CRS to use in the query. To see allowed values, use
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
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
#> ✖ The request could not be completed.
#> ! Failed to perform HTTP request.
#> Caused by error in `curl::curl_fetch_memory()`:
#> ! Failure when receiving data from the peer [ovc.catastro.meh.es]:
#> Recv failure: Connection reset by peer
#> → Returning "NULL" because the request failed.
#> NULL
# }
```
