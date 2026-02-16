# Get the cadastral municipality code from coordinates

This function takes as an input a pair of coordinates of a
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object and
returns the corresponding municipality code for that coordinates.

See also
[`mapSpain::esp_get_munic_siane()`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic_siane.html)
and
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_munic.md).

## Usage

``` r
catr_get_code_from_coords(x, srs, verbose = FALSE, cache_dir = NULL, ...)
```

## Arguments

- x:

  It could be:

  - A pair of coordinates c(x,y).

  - A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.
    See **Details**.

- srs:

  SRS/CRS to use on the query. To check the admitted values check
  [catr_srs_values](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
  specifically the `wfs_service` column. See **Details**.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

- cache_dir:

  A path to a cache directory. On `NULL` value (the default) the
  function would store the cached files on the
  [`tempdir`](https://rdrr.io/r/base/tempfile.html).

- ...:

  Arguments passed on to
  [`mapSpain::esp_get_munic_siane`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic_siane.html)

  `year`

  :   character string or number. Release year, it must be in formats
      `YYYY` (assuming end of year) or `YYYY-MM-DD`. Historical
      information starts as of 2005.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
with the format described in
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_munic.md).

## Details

When `x` is a numeric vector, make sure that the `srs` matches the
coordinate values.

When `x` is a [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object, only the first value would be used. The function would extract
the coordinates using `sf::st_centroid(x, of_largest_polygon = TRUE)`.

## See also

[`mapSpain::esp_get_munic_siane()`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic_siane.html),
[`sf::st_centroid()`](https://r-spatial.github.io/sf/reference/geos_unary.html).

Other search:
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md),
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_munic.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_provinces.md)

## Examples

``` r
if (FALSE) { # tolower(Sys.info()[["sysname"]]) != "linux"
# \donttest{
# Use with coords
catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326)

# Use with sf
prov <- mapSpain::esp_get_prov("Caceres")
catr_get_code_from_coords(prov)
# }
}
```
