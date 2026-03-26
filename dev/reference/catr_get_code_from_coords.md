# Get the cadastral municipality code from coordinates

This function takes as input a pair of coordinates of a
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object and
returns the corresponding municipality code for those coordinates using
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_munic.md).

## Usage

``` r
catr_get_code_from_coords(
  x,
  srs = NULL,
  verbose = FALSE,
  cache_dir = NULL,
  ...
)
```

## Arguments

- x:

  It can be:

  - A pair of coordinates `c(x,y)`. In this case the `srs` of the
    coordinates should be provided.

  - A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.
    If the object has several geometries only the first value will be
    used. The function will extract the coordinates using
    `sf::st_centroid(x, of_largest_polygon = TRUE)`.

- srs:

  SRS/CRS to use on the query. To see allowed values, use
  [catr_srs_values](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
  specifically the `ovc_service` column.

- verbose:

  logical. If `TRUE` displays informational messages.

- cache_dir:

  A path to a cache directory. On `NULL` the function stores cached
  files in a temporary directory (see
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

- ...:

  Arguments passed on to
  [`mapSpain::esp_get_munic_siane`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic_siane.html)

  `year`

  :   character string or number. Release year, it must be in formats
      `YYYY` (assuming end of year) or `YYYY-MM-DD`. Historical
      information starts as of 2005.

  `resolution`

  :   character string or number. Resolution of the geospatial data. One
      of:

      - "10": 1:10 million.

      - "6.5": 1:6.5 million.

      - "3": 1:3 million.

  `region`

  :   Optional. A vector of region names, NUTS or ISO codes (see
      [`esp_dict_region_code()`](https://ropenspain.github.io/mapSpain/reference/esp_dict.html)).

  `munic`

  :   character string. A name or
      [`regex`](https://rdrr.io/r/base/grep.html) expression with the
      names of the required municipalities. `NULL` will return all
      municipalities.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).
See **Details**

## Details

On a successful query, the function returns a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) with
one row including the following columns:

- `munic`: Name of the municipality as per the Cadastre.

- `catr_to`: Cadastral territorial office code.

- `catr_munic`: Municipality code as recorded on the Cadastre.

- `catrcode`: Full Cadastral code for the municipality.

- `cpro`: Province code as per the INE.

- `catr_munic`: Municipality code as per the INE.

- `catrcode`: Full INE code for the municipality.

- Rest of fields: Check the API Docs.

## See also

[`mapSpain::esp_get_munic_siane()`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic_siane.html),
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_munic.md),
[`sf::st_centroid()`](https://r-spatial.github.io/sf/reference/geos_unary.html).

Other search:
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md),
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_munic.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_provinces.md)

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
