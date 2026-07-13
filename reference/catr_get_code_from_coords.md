# Get the cadastral municipality code from coordinates

Retrieve the municipality code associated with an
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object or a
coordinate pair.

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

  Coordinate input. It can be:

  - A pair of coordinates `c(x, y)`. In this case the `srs` of the
    coordinates must be provided.

  - A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.
    If the object has several geometries, only the first geometry is
    used. This function extracts coordinates using
    `sf::st_centroid(x, of_largest_polygon = TRUE)`.

- srs:

  SRS/CRS to use in the query. To see allowed values, use
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
  specifically the `ovc_service` column.

- verbose:

  Logical. If `TRUE`, displays informational messages.

- cache_dir:

  Path to a cache directory. If `NULL` or `FALSE`, the function stores
  cached files in a temporary directory. See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html).

- ...:

  Arguments passed on to
  [`mapSpain::esp_get_munic_siane`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic_siane.html)

  `year`

  :   Character string or number. Release year. It must use format
      `YYYY` (assuming end of year) or `YYYY-MM-DD`. Historical
      information starts as of 2005.

  `resolution`

  :   Character string or number. Resolution of the geospatial data. One
      of:

      - `"10"`: 1:10 million.

      - `"6.5"`: 1:6.5 million.

      - `"3"`: 1:3 million.

  `region`

  :   Optional. A vector of region names, NUTS or ISO codes (see
      [`esp_dict_region_code()`](https://ropenspain.github.io/mapSpain/reference/esp_dict.html)).

  `munic`

  :   Character string. A name or
      [`regex`](https://rdrr.io/r/base/grep.html) expression with the
      names of the required municipalities. Use `NULL` to return all
      municipalities.

## Value

A [tibble](https://dplyr.tidyverse.org/reference/defunct.html) as
described in **Details**. Returns `NULL` if the request fails.

## Details

On a successful query, this function returns a
[tibble](https://dplyr.tidyverse.org/reference/defunct.html) with one
row including the following columns:

- `munic`: Municipality name used by the Spanish Cadastre.

- `catr_to`: Cadastral territorial office code.

- `catr_munic`: Municipality code as recorded by the Cadastre.

- `catrcode`: Full cadastral code for the municipality.

- `cpro`: Province code according to the INE.

- `cmun`: Municipality code according to the INE.

- `inecode`: Full INE code for the municipality.

- Remaining fields: See the API documentation.

## See also

- [`mapSpain::esp_get_munic_siane()`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic_siane.html)
  retrieves municipality geometries.

- [`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md)
  retrieves municipality codes.

- [`sf::st_centroid()`](https://r-spatial.github.io/sf/reference/geos_unary.html)
  computes geometry centroids.

Search for cadastral identifiers:
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md),
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)

## Examples

``` r
# \donttest{
# Use with coordinates
catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326)
#> # A tibble: 1 × 12
#>   munic  catr_to catr_munic catrcode cpro  cmun  inecode nm    cd    cmc   cp   
#>   <chr>  <chr>   <chr>      <chr>    <chr> <chr> <chr>   <chr> <chr> <chr> <chr>
#> 1 SANTA… 38      900        38900    38    038   38038   SANT… 38    900   38   
#> # ℹ 1 more variable: cm <chr>

# Use with an sf object
prov <- mapSpain::esp_get_prov("Caceres")
catr_get_code_from_coords(prov)
#> # A tibble: 1 × 12
#>   munic  catr_to catr_munic catrcode cpro  cmun  inecode nm    cd    cmc   cp   
#>   <chr>  <chr>   <chr>      <chr>    <chr> <chr> <chr>   <chr> <chr> <chr> <chr>
#> 1 MONROY 10      128        10128    10    125   10125   MONR… 10    128   10   
#> # ℹ 1 more variable: cm <chr>
# }
```
