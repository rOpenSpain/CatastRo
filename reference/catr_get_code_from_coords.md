# Get the cadastral municipality code from coordinates

Get the municipality code for coordinates using a
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object or a
pair of coordinates via
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md).

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

  Can be one of:

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

  Path to a cache directory. On `NULL`, the function stores cached files
  in a temporary directory (see
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

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

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).
See **Details**.

## Details

On a successful query, this function returns a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) with
one row including the following columns:

- `munic`: Name of the municipality according to the Cadastre.

- `catr_to`: Cadastral territorial office code.

- `catr_munic`: Municipality code as recorded on the Cadastre.

- `catrcode`: Full Cadastral code for the municipality.

- `cpro`: Province code according to the INE.

- `cmun`: Municipality code according to the INE.

- `inecode`: Full INE code for the municipality.

- Remaining fields: Check the API documentation.

## See also

[`mapSpain::esp_get_munic_siane()`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic_siane.html),
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md),
[`sf::st_centroid()`](https://r-spatial.github.io/sf/reference/geos_unary.html).

Other search:
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md),
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)

## Examples

``` r
# \donttest{
# Use with coordinates
catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326)
#> ✖ OVC service error 0: problemas tecnicos. Tiempo estimado desde las 15.15H hasta las 19.H.
#> 
#> Disculpe las molestias.
#> # A tibble: 1 × 1
#>   name 
#>   <lgl>
#> 1 NA   

# Use with sf
prov <- mapSpain::esp_get_prov("Caceres")
catr_get_code_from_coords(prov)
#> ✖ OVC service error 0: problemas tecnicos. Tiempo estimado desde las 15.15H hasta las 19.H.
#> 
#> Disculpe las molestias.
#> # A tibble: 1 × 1
#>   name 
#>   <lgl>
#> 1 NA   
# }
```
