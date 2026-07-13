# Set your [CatastRo](https://CRAN.R-project.org/package=CatastRo) cache directory

Configure the cache directory used by
[CatastRo](https://CRAN.R-project.org/package=CatastRo). Use
`Sys.getenv("CATASTROESP_CACHE_DIR")` or `catr_detect_cache_dir()` to
inspect the current path.

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

  Path to a cache directory. If `NULL` or `FALSE`, the function stores
  cached files in a temporary directory. See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html).

- overwrite:

  Logical. If `TRUE`, overwrites an existing `CATASTROESP_CACHE_DIR`
  value already present on your machine.

- install:

  Logical. If `TRUE`, stores the path locally for use in future
  sessions. Defaults to `FALSE`.

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

`catr_set_cache_dir()` invisibly returns a character string containing
the cache path. It is primarily called for its side effect.

`catr_detect_cache_dir()` returns the path to the `cache_dir` used in
this session.

## Details

By default, when no `cache_dir` is set,
[CatastRo](https://CRAN.R-project.org/package=CatastRo) uses a directory
inside [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html) (so
files are temporary and are removed when the R session ends). To persist
a cache across R sessions, use
`catr_set_cache_dir(cache_dir, install = TRUE)` which writes the chosen
path to a small configuration file under
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

Source files are cached after download.
[CatastRo](https://CRAN.R-project.org/package=CatastRo) implements the
following caching options:

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

Cached files can occasionally become corrupt. In that case, try
downloading the data by setting `update_cache = TRUE` in the
corresponding function.

If a download fails, try another download method and save the file in
`cache_dir`. Use `verbose = TRUE` to inspect the API query and
`catr_detect_cache_dir()` to identify your cache path.

## See also

[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) defines
platform-specific user directories.

Manage the local cache:
[`catr_clear_cache()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_clear_cache.md)

## Examples

``` r

# Caution! This modifies your current state
# \dontrun{
my_cache <- catr_detect_cache_dir()
#> ℹ /tmp/Rtmp73MbUn/CatastRo

# Set an example cache
ex <- file.path(tempdir(), "example", "cachenew")
catr_set_cache_dir(ex)
#> ℹ CatastRo cache directory is /tmp/Rtmp73MbUn/example/cachenew.
#> ℹ To reuse this cache directory in future sessions, set `install` to `TRUE`.

catr_detect_cache_dir()
#> ℹ /tmp/Rtmp73MbUn/example/cachenew
#> [1] "/tmp/Rtmp73MbUn/example/cachenew"

# Restore initial cache
catr_set_cache_dir(my_cache)
#> ℹ CatastRo cache directory is /tmp/Rtmp73MbUn/CatastRo.
#> ℹ To reuse this cache directory in future sessions, set `install` to `TRUE`.
identical(my_cache, catr_detect_cache_dir())
#> ℹ /tmp/Rtmp73MbUn/CatastRo
#> [1] TRUE
# }


catr_detect_cache_dir()
#> ℹ /tmp/Rtmp73MbUn/CatastRo
#> [1] "/tmp/Rtmp73MbUn/CatastRo"
```
