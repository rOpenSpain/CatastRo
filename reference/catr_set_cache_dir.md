# Set your [CatastRo](https://CRAN.R-project.org/package=CatastRo) cache directory

Store your `cache_dir` path locally for future sessions. Type
`Sys.getenv("CATASTROESP_CACHE_DIR")` or use `catr_detect_cache_dir()`
to find your cached path.

## Usage

``` r
catr_set_cache_dir(
  cache_dir = NULL,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
)

catr_detect_cache_dir()
```

## Arguments

- cache_dir:

  Path to a cache directory. On `NULL`, the function stores cached files
  in a temporary directory (see
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

- overwrite:

  Logical. If `TRUE`, overwrites an existing `CATASTROESP_CACHE_DIR`
  value already present on your machine.

- install:

  Logical. If `TRUE`, installs the key on your local machine for use in
  future sessions. Defaults to `FALSE`. If `cache_dir` is `FALSE`, this
  argument is set to `FALSE` automatically.

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

`catr_set_cache_dir()` returns an (invisible) character with the path to
your `cache_dir`, but it is mainly called for its side effect.

`catr_detect_cache_dir()` returns the path to the `cache_dir` used in
this session.

## Details

By default, when no `cache_dir` is set, the package uses a folder inside
[`base::tempdir()`](https://rdrr.io/r/base/tempfile.html) (so files are
temporary and are removed when the R session ends). To persist a cache
across R sessions, use `catr_set_cache_dir(cache_dir, install = TRUE)`
which writes the chosen path to a small configuration file under
`tools::R_user_dir("CatastRo", "config")`.

## Note

In [CatastRo](https://CRAN.R-project.org/package=CatastRo) \>= 1.0.0 the
location of the configuration file has moved from
`rappdirs::user_config_dir("CatastRo", "R")` to
`tools::R_user_dir("CatastRo", "config")`. We have implemented a
function that migrates previous configuration files from one location to
another with a message. This message appears only once to inform you of
the migration.

## Caching strategies

Some files can be read from their online source without caching using
the option `cache = FALSE`. Otherwise the source file is downloaded to
your computer. [CatastRo](https://CRAN.R-project.org/package=CatastRo)
implements the following caching options:

- For occasional use, rely on the default
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html)-based cache (no
  install).

- Modify the cache for a single session by setting
  `catr_set_cache_dir(cache_dir = "a/path/here")`.

- For reproducible workflows, install a persistent cache with
  `catr_set_cache_dir(cache_dir = "a/path/here", install = TRUE)`. This
  cache is kept across R sessions.

- For caching specific files, use the `cache_dir` argument in the
  corresponding function.

Sometimes cached files may be corrupt. In that case, try re-downloading
the data by setting `update_cache = TRUE` in the corresponding function.

If you experience any problem downloading, try downloading the
corresponding file by another method and save it in your `cache_dir`.
Use the option `verbose = TRUE` to debug the API query and
`catr_detect_cache_dir()` to identify your cached path.

## See also

[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html)

Other cache utilities:
[`catr_clear_cache()`](https://ropenspain.github.io/CatastRo/reference/catr_clear_cache.md)

## Examples

``` r

# Caution! This modifies your current state
# \dontrun{
my_cache <- catr_detect_cache_dir()
#> ℹ /tmp/RtmpBhliXQ/CatastRo

# Set an example cache
ex <- file.path(tempdir(), "example", "cachenew")
catr_set_cache_dir(ex)
#> ℹ CatastRo cache directory is /tmp/RtmpBhliXQ/example/cachenew.
#> ℹ To reuse this `cache_dir` in future sessions, run this function with `install = TRUE`.

catr_detect_cache_dir()
#> ℹ /tmp/RtmpBhliXQ/example/cachenew
#> [1] "/tmp/RtmpBhliXQ/example/cachenew"

# Restore initial cache
catr_set_cache_dir(my_cache)
#> ℹ CatastRo cache directory is /tmp/RtmpBhliXQ/CatastRo.
#> ℹ To reuse this `cache_dir` in future sessions, run this function with `install = TRUE`.
identical(my_cache, catr_detect_cache_dir())
#> ℹ /tmp/RtmpBhliXQ/CatastRo
#> [1] TRUE
# }


catr_detect_cache_dir()
#> ℹ /tmp/RtmpBhliXQ/CatastRo
#> [1] "/tmp/RtmpBhliXQ/CatastRo"
```
