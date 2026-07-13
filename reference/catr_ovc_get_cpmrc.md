# OVCCoordenadas: geocode a cadastral reference

Query the OVCCoordenadas [Consulta
CPMRC](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_CPMRC)
service to retrieve coordinates for a cadastral reference.

## Usage

``` r
catr_ovc_get_cpmrc(
  rc,
  srs = 4326,
  province = NULL,
  municipality = NULL,
  verbose = FALSE
)
```

## Arguments

- rc:

  The cadastral reference to be geocoded.

- srs:

  SRS/CRS to use in the query. To see allowed values, use
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
  specifically the `ovc_service` column.

- province, municipality:

  Optional character strings used to narrow the search.

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

- `xcoord`, `ycoord`: X and Y coordinates in the specified SRS.

- `refcat`: Cadastral reference.

- `address`: Address as recorded in the Spanish Cadastre.

- Remaining fields: See the API documentation.

## References

[Consulta
CPMRC](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_CPMRC).

## See also

- [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md)
  lists supported SRS values.

- [`vignette("ovcservice", package = "CatastRo")`](https://ropenspain.github.io/CatastRo/articles/ovcservice.md)
  describes the OVC services.

Convert coordinates and cadastral references:
[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)

Work with cadastral references:
[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)

## Examples

``` r
# \donttest{

# Using all arguments
catr_ovc_get_cpmrc("13077A01800039",
  4230,
  province = "CIUDAD REAL",
  municipality = "SANTA CRUZ DE MUDELA"
)
#> ✖ The request could not be completed.
#> ! Failed to perform HTTP request.
#> Caused by error in `curl::curl_fetch_memory()`:
#> ! Failure when receiving data from the peer [ovc.catastro.meh.es]:
#> Recv failure: Connection reset by peer
#> → Returning "NULL" because the request failed.
#> NULL

# Only the cadastral reference
catr_ovc_get_cpmrc("9872023VH5797S")
#> ✖ The request could not be completed.
#> ! Failed to perform HTTP request.
#> Caused by error in `curl::curl_fetch_memory()`:
#> ! Failure when receiving data from the peer [ovc.catastro.meh.es]:
#> Recv failure: Connection reset by peer
#> → Returning "NULL" because the request failed.
#> NULL
# }
```
