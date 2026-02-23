# Clear your [CatastRo](https://CRAN.R-project.org/package=CatastRo) cache dir

**Use this function with caution**. This function will clear your cached
data and configuration, specifically:

- Deletes the [CatastRo](https://CRAN.R-project.org/package=CatastRo)
  config directory (`tools::R_user_dir("CatastRo", "config")`).

- Deletes the `cache_dir` directory.

- Deletes the values stored on `Sys.getenv("CATASTROESP_CACHE_DIR")`.

## Usage

``` r
catr_clear_cache(config = FALSE, cached_data = TRUE, verbose = FALSE)
```

## Arguments

- config:

  if `TRUE`, will delete the configuration folder of
  [CatastRo](https://CRAN.R-project.org/package=CatastRo).

- cached_data:

  If this is set to `TRUE`, it will delete your `cache_dir` and all its
  content.

- verbose:

  logical. If `TRUE` displays informational messages.

## Value

Invisible. This function is called for its side effects.

## Details

This is an overkill function that is intended to reset your status as if
you would never have installed and/or used
[CatastRo](https://CRAN.R-project.org/package=CatastRo).

## See also

[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html)

Other cache utilities:
[`catr_set_cache_dir()`](https://ropenspain.github.io/CatastRo/reference/catr_set_cache_dir.md)

## Examples

``` r
# Don't run this! It would modify your current state
# \dontrun{
my_cache <- catr_detect_cache_dir()
#> ℹ /tmp/Rtmp5S10OJ/CatastRo

# Set an example cache
ex <- file.path(tempdir(), "example", "cache")
catr_set_cache_dir(ex, verbose = FALSE)

# Restore initial cache
catr_clear_cache(verbose = TRUE)
#> ! CatastRo data deleted: /tmp/Rtmp5S10OJ/example/cache (0 bytes).

catr_set_cache_dir(my_cache)
#> ℹ CatastRo cache dir is /tmp/Rtmp5S10OJ/CatastRo.
#> ℹ To install your `cache_dir` path for use in future sessions run this function with `install = TRUE`.
identical(my_cache, catr_detect_cache_dir())
#> ℹ /tmp/Rtmp5S10OJ/CatastRo
#> [1] TRUE
# }
```
