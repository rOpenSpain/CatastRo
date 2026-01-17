# Set your [CatastRo](https://CRAN.R-project.org/package=CatastRo) cache dir

`catr_set_cache_dir()` will store your `cache_dir` path on your local
machine and would load it for future sessions.

Alternatively, you can store the `cache_dir` manually with the following
options:

- Run `Sys.setenv(CATASTROESP_CACHE_DIR = "cache_dir")`. You would need
  to run this command on each session (Similar to `install = FALSE`).

- Write this line on your .Renviron file:
  `CATASTROESP_CACHE_DIR = "value_for_cache_dir"` (same behavior than
  `install = TRUE`). This would store your `cache_dir` permanently.

`catr_detect_cache_dir()` detects and returns the path to your current
`cache_dir`.

## Usage

``` r
catr_set_cache_dir(
  cache_dir = NULL,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
)

catr_detect_cache_dir(...)
```

## Arguments

- cache_dir:

  A path to a cache directory. On `NULL` value (the default) the
  function would store the cached files on the
  [`tempdir`](https://rdrr.io/r/base/tempfile.html).

- overwrite:

  If this is set to `TRUE`, it will overwrite an existing
  `CATASTROESP_CACHE_DIR` that you already have in local machine.

- install:

  if `TRUE`, will install the key in your local machine for use in
  future sessions. Defaults to `FALSE.` If `cache_dir` is `FALSE` this
  parameter is set to `FALSE` automatically.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

- ...:

  Ignored

## Value

`catr_set_cache_dir()` is called for its side effects, and returns an
(invisible) character with the path to your `cache_dir`.

`catr_detect_cache_dir()` returns the path to the `cache_dir` used in
this session

## About caching

Sometimes cached files may be corrupt. On that case, try re-downloading
the data setting `update_cache = TRUE`.

If you experience any problem on download, try to download the
corresponding file by any other method and save it on your `cache_dir`.
Use the option `verbose = TRUE` for debugging the API query.

## See also

[`rappdirs::user_config_dir()`](https://rappdirs.r-lib.org/reference/user_data_dir.html)

Other cache utilities:
[`catr_clear_cache()`](https://ropenspain.github.io/CatastRo/reference/catr_clear_cache.md)

## Examples

``` r
# Don't run this! It would modify your current state
# \dontrun{
catr_set_cache_dir(verbose = TRUE)
#> Using a temporary cache dir. Set 'cache_dir' to a value for store permanently
#> CatastRo cache dir is: C:\Users\RUNNER~1\AppData\Local\Temp\RtmpOIlmO2/CatastRo
# }


catr_detect_cache_dir()
#> [1] "C:\\Users\\RUNNER~1\\AppData\\Local\\Temp\\RtmpOIlmO2/CatastRo"
```
