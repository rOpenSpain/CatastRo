# OVCCoordenadas: Geocode a cadastral reference

Query the OVCCoordenadas [Consulta
CPMRC](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_CPMRC)
service to retrieve coordinates for a parcel reference. The returned
coordinates locate the parcel centroid.

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

  A 14-character cadastral parcel reference to geocode.

- srs:

  SRS/CRS to use in the query. To see allowed values, use
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
  specifically the `ovc_service` column.

- province, municipality:

  Optional character strings used to narrow the search. `province` is
  required when `municipality` is provided.

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

Work with cadastral references:
[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)

Query OVC web services:
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md),
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
#> ✖ HTTP error 403 (Forbidden): <http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC?RC=13077A01800039&SRS=EPSG%3A4230&Provincia=CIUDAD%20REAL&Municipio=SANTA%20CRUZ%20DE%20MUDELA>.
#> ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
#> Returning `NULL` because the request failed.
#> NULL

# Only the cadastral reference
catr_ovc_get_cpmrc("9872023VH5797S")
#> ✖ HTTP error 403 (Forbidden): <http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC?RC=9872023VH5797S&SRS=EPSG%3A4326&Provincia=&Municipio=>.
#> ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
#> Returning `NULL` because the request failed.
#> NULL
# }
```
