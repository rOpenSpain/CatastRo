# OVCCoordenadas: Geocode a cadastral reference

Implementation of the OVCCoordenadas service [Consulta
CPMRC](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_CPMRC).

Return the coordinates for a specific cadastral reference.

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

  SRS/CRS to use on the query. To check the admitted values check
  [catr_srs_values](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
  specifically the `ovc_service` column.

- province, municipality:

  Optional, used for narrowing the search.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

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

- `xcoord`, `ycoord`: X and Y coordinates in the specified SRS.

- `refcat`: Cadastral Reference.

- `address`: Address as it is recorded on the Cadastre.

- Rest of fields: Check the API Docs.

## References

[Consulta
CPMRC](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx?op=Consulta_CPMRC).

## See also

[catr_srs_values](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
[`vignette("ovcservice", package = "CatastRo")`](https://ropenspain.github.io/CatastRo/dev/articles/ovcservice.md)

OVCCoordenadas API:
[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor_distancia.md),
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md)

Other cadastral references:
[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor.md),
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor_distancia.md)

## Examples

``` r
if (FALSE) { # tolower(Sys.info()[["sysname"]]) != "linux"
# \donttest{

# using all the arguments
catr_ovc_get_cpmrc("13077A01800039",
  4230,
  province = "CIUDAD REAL",
  municipality = "SANTA CRUZ DE MUDELA"
)

# only the cadastral reference
catr_ovc_get_cpmrc("9872023VH5797S")
# }
}
```
