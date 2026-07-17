# Clear your [CatastRo](https://CRAN.R-project.org/package=CatastRo) cache directory

Use this function with caution. Depending on its arguments, this
function:

- Deletes the [CatastRo](https://CRAN.R-project.org/package=CatastRo)
  configuration directory when `config = TRUE`
  (`tools::R_user_dir("CatastRo", "config")`).

- Deletes the `cache_dir` directory and its contents when
  `cached_data = TRUE`.

- Always clears the `CATASTROESP_CACHE_DIR` environment variable.

## Usage

``` r
catr_clear_cache(config = FALSE, cached_data = TRUE, verbose = FALSE)
```

## Arguments

- config:

  If `TRUE`, deletes the configuration directory of
  [CatastRo](https://CRAN.R-project.org/package=CatastRo).

- cached_data:

  If `TRUE`, deletes your `cache_dir` and all its contents.

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

Invisibly returns `NULL`. This function is called for its side effects.

## Details

With `config = TRUE` and `cached_data = TRUE`, this function resets the
cache state as if you had never used
[CatastRo](https://CRAN.R-project.org/package=CatastRo).

## See also

[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) defines
platform-specific user directories.

Manage the local cache:
[`catr_set_cache_dir()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_set_cache_dir.md)

## Examples

``` r

# Don't run this! It modifies your current state
# \dontrun{
my_cache <- catr_detect_cache_dir()
#> ℹ /tmp/RtmpVPgBUj/CatastRo

# Set an example cache
ex <- file.path(tempdir(), "example", "cache")
catr_set_cache_dir(ex, verbose = FALSE)

# Restore initial cache
catr_clear_cache(verbose = TRUE)
#> ! CatastRo cached data deleted: /tmp/RtmpVPgBUj/example/cache (0 bytes).

catr_set_cache_dir(my_cache)
#> ℹ CatastRo cache directory is /tmp/RtmpVPgBUj/CatastRo.
#> ℹ To reuse this cache directory in future sessions, set `install` to `TRUE`.
identical(my_cache, catr_detect_cache_dir())
#> ℹ /tmp/RtmpVPgBUj/CatastRo
#> [1] TRUE
# }
```
