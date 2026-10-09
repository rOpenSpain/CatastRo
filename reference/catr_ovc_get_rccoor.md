# OVCCoordenadas: Reverse geocode coordinates

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

  Y coordinate for the query, expressed in the SRS/CRS defined by `srs`.
  For geographic coordinates, this is the latitude.

- lon:

  X coordinate for the query, expressed in the SRS/CRS defined by `srs`.
  For geographic coordinates, this is the longitude.

- srs:

  SRS/CRS to use in the query. To see allowed values, use
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
  specifically the `ovc_service` column.

- verbose:

  Logical. Whether to display informational messages.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) as
described in **Details**. Returns
[`NULL`](https://rdrr.io/r/base/NULL.html) if the request fails.

## Details

If the API returns no results or reports an error, the result is a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
containing only query information.

On a successful query, this function returns a tibble with one row per
cadastral reference, including the following columns:

- `geo.xcen`, `geo.ycen`, `geo.srs`: Input arguments of the query.

- `refcat`: Cadastral reference.

- `address`: Address as recorded in the Spanish Cadastre.

- Remaining fields: See the API documentation.

## References

[Consulta
RCCOOR](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_RCCOOR).

## See also

[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)
also searches a nearby area when no exact match is found.
[`catr_wfs_get_parcels_parcel()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)
retrieves parcel geometries using the returned cadastral references.

Work with cadastral references:
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)

Query OVC web services:
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md),
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cpmrc.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)

## Examples

``` r
# \donttest{
catr_ovc_get_rccoor(
  lat = 38.6196566583596,
  lon = -3.45624183836806,
  srs = 4326
)
#> ✖ HTTP error 403 (Forbidden): <http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_RCCOOR?SRS=EPSG%3A4326&Coordenada_X=-3.456242&Coordenada_Y=38.61966>.
#> ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
#> Returning `NULL` because the request failed.
#> NULL
# }
```
