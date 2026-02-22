# OVCCoordenadas: Reverse geocode a cadastral reference

Implementation of the OVCCoordenadas service [Consulta
RCCOOR](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR).

Returns the cadastral reference found for a set of specific coordinates.

## Usage

``` r
catr_ovc_get_rccoor(lat, lon, srs = 4326, verbose = FALSE)
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
  [catr_srs_values](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
  specifically the `ovc_service` column.

- verbose:

  logical. If `TRUE` displays informational messages.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).
See **Details**

## Details

When the API does not provide any result, the function returns a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) with
the input parameters only.

On a successful query, the function returns a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) with
one row by cadastral reference, including the following columns:

- `geo.xcen`, `geo.ycen`, `geo.srs`: Input parameters of the query.

- `refcat`: Cadastral Reference.

- `address`: Address as it is recorded on the Cadastre.

- Rest of fields: Check the API Docs.

## References

[Consulta
RCCOOR](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR).

## See also

[catr_srs_values](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
[`vignette("ovcservice", package = "CatastRo")`](https://ropenspain.github.io/CatastRo/dev/articles/ovcservice.md)

OVCCoordenadas API:
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor_distancia.md),
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md)

Other cadastral references:
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor_distancia.md)

## Examples

``` r
if (FALSE) { # tolower(Sys.info()[["sysname"]]) != "linux"
# \donttest{
catr_ovc_get_rccoor(
  lat = 38.6196566583596,
  lon = -3.45624183836806,
  srs = 4326
)
# }
}
```
