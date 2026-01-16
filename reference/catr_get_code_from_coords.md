# Get the cadastral municipality code from coordinates

This function takes as an input a pair of coordinates of a
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object and
returns the corresponding municipality code for that coordinates.

See also
[`mapSpain::esp_get_munic_siane()`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic.html)
and
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md).

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
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
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
  [`mapSpain::esp_get_munic_siane`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic.html)

  `year`

  :   Release year. See **Details** for years available.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
with the format described in
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md).

## Details

When `x` is a numeric vector, make sure that the `srs` matches the
coordinate values.

When `x` is a [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object, only the first value would be used. The function would extract
the coordinates using `sf::st_centroid(x, of_largest_polygon = TRUE)`.

## See also

[`mapSpain::esp_get_munic_siane()`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic.html),
[`sf::st_centroid()`](https://r-spatial.github.io/sf/reference/geos_unary.html).

Other search:
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md),
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)

## Examples

``` r
# \donttest{
# Use with coords
catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326)
#> # A tibble: 1 × 12
#>   munic  catr_to catr_munic catrcode cpro  cmun  inecode nm    cd    cmc   cp   
#>   <chr>  <chr>   <chr>      <chr>    <chr> <chr> <chr>   <chr> <chr> <chr> <chr>
#> 1 SANTA… 38      900        38900    38    038   38038   SANT… 38    900   38   
#> # ℹ 1 more variable: cm <chr>

# Use with sf
prov <- mapSpain::esp_get_prov("Caceres")
catr_get_code_from_coords(prov)
#> # A tibble: 1 × 12
#>   munic  catr_to catr_munic catrcode cpro  cmun  inecode nm    cd    cmc   cp   
#>   <chr>  <chr>   <chr>      <chr>    <chr> <chr> <chr>   <chr> <chr> <chr> <chr>
#> 1 MONROY 10      128        10128    10    125   10125   MONR… 10    128   10   
#> # ℹ 1 more variable: cm <chr>
# }
```
