# catr_set_cache_dir() installs and overwrites configuration

    Code
      catr_set_cache_dir(next_cache_dir, install = TRUE, verbose = FALSE)
    Condition
      Error in `catr_set_cache_dir()`:
      ! A `cache_dir` value is already configured.
      i Set `overwrite` to `TRUE` to replace it.

# migrate_cache() moves legacy configuration

    Code
      migrate_cache(old = old, new = new)
    Message
      v CatastRo cache configuration migrated for version "1.0.0" or later. See the Note section (`?CatastRo::catr_set_cache_dir()`).
      i This one-time message will not be shown again.

# catr_set_cache_dir() rejects invalid arguments

    Code
      catr_set_cache_dir(cache_dir = 1, verbose = FALSE)
    Condition
      Error in `catr_set_cache_dir()`:
      ! `cache_dir` must be a single <character> value.

---

    Code
      catr_set_cache_dir(overwrite = NA, verbose = FALSE)
    Condition
      Error in `catr_set_cache_dir()`:
      ! `overwrite` must be `TRUE` or `FALSE`.

---

    Code
      catr_set_cache_dir(cache_dir = tempdir(), install = c(TRUE, FALSE), verbose = FALSE)
    Condition
      Error in `catr_set_cache_dir()`:
      ! `install` must be `TRUE` or `FALSE`.

