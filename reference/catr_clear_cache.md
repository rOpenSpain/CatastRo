# Clear your [CatastRo](https://CRAN.R-project.org/package=CatastRo) cache dir

**Use this function with caution**. This function would clear your
cached data and configuration, specifically:

- Deletes the [CatastRo](https://CRAN.R-project.org/package=CatastRo)
  config directory (`rappdirs::user_config_dir("CatastRo", "R")`).

- Deletes the `cache_dir` directory.

- Deletes the values on stored on `Sys.getenv("CATASTROESP_CACHE_DIR")`.

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

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

## Value

Invisible. This function is called for its side effects.

## Details

This is an overkill function that is intended to reset your status as it
you would never have installed and/or used
[CatastRo](https://CRAN.R-project.org/package=CatastRo).

## See also

Other cache utilities:
[`catr_set_cache_dir()`](https://ropenspain.github.io/CatastRo/reference/catr_set_cache_dir.md)

## Examples

``` r
# Don't run this! It would modify your current state
# \dontrun{
catr_clear_cache(verbose = TRUE)
#> CatastRo cached data deleted: C:\Users\RUNNER~1\AppData\Local\Temp\RtmpgH9XNH/CatastRo
# }

Sys.getenv("CATASTROESP_CACHE_DIR")
#> [1] ""
```
