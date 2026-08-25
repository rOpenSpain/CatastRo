# ATOM INSPIRE: Search for municipality codes

Search for a municipality by name or code and return matching Spanish
Cadastre municipality codes.

## Usage

``` r
catr_atom_search_munic(
  munic,
  to = NULL,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Arguments

- munic:

  Municipality name, partial name or cadastral code. Use
  `catr_atom_search_munic()` to find cadastral codes.

- to:

  Optional territorial office containing `munic`. Use this argument to
  narrow the search.

- cache:

  **\[deprecated\]** This argument is no longer supported because
  results are always cached.

- update_cache:

  Logical. Whether to refresh the cached file. Defaults to `FALSE`.

- cache_dir:

  Path to a cache directory. If `NULL` or `FALSE`, the function stores
  cached files in a temporary directory. See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html).

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

A [tibble](https://dplyr.tidyverse.org/reference/defunct.html) with the
territorial office, municipality name and cadastral code. Returns `NULL`
if no match is found.

## Examples

``` r
# \donttest{
catr_atom_search_munic("Mad")
#> # A tibble: 40 × 3
#>    territorial_office                munic           catrcode
#>    <chr>                             <chr>           <chr>   
#>  1 Territorial office 09 Burgos      09178-HUMADA    09178   
#>  2 Territorial office 28 Madrid      28900-MADRID    28900   
#>  3 Territorial office 09 Burgos      09287-QUEMADA   09287   
#>  4 Territorial office 13 Ciudad Real 13011-ALMADEN   13011   
#>  5 Territorial office 27 Lugo        27021-XERMADE   27021   
#>  6 Territorial office 28 Madrid      28078-MADARCOS  28078   
#>  7 Territorial office 37 Salamanca   37177-MADROÑAL  37177   
#>  8 Territorial office 10 Cáceres     10116-MADROÑERA 10116   
#>  9 Territorial office 40 Segovia     40134-MADERUELO 40134   
#> 10 Territorial office 50 Zaragoza    50280-VALMADRID 50280   
#> # ℹ 30 more rows
# }
```
