test_that("catr_set_cache_dir() and catr_clear_cache() isolate session state", {
  withr::local_envvar(CATASTROESP_CACHE_DIR = NA)

  root <- withr::local_tempdir(pattern = "catr-session")
  cache_dir <- file.path(root, "cache")
  config_dir <- file.path(root, "config")

  local_mocked_bindings(
    catr_r_user_dir = function(...) config_dir,
    migrate_cache = function(...) invisible()
  )

  expect_message(configured <- catr_set_cache_dir(cache_dir, verbose = TRUE))
  expect_identical(configured, cache_dir)
  expect_message(detected <- catr_detect_cache_dir())
  expect_identical(detected, cache_dir)
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), cache_dir)
  expect_true(dir.exists(cache_dir))

  expect_message(
    catr_clear_cache(config = FALSE, cached_data = TRUE, verbose = TRUE),
    "cached data deleted"
  )

  expect_false(dir.exists(cache_dir))
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), "")
})

test_that("catr_set_cache_dir() installs and overwrites configuration", {
  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  root <- withr::local_tempdir(pattern = "catr-config-root")
  config_dir <- file.path(root, "missing")

  cache_dir <- withr::local_tempdir(pattern = "catr-cache")
  next_cache_dir <- withr::local_tempdir(pattern = "catr-cache-next")

  local_mocked_bindings(catr_r_user_dir = function(...) config_dir)

  cache_config <- file.path(config_dir, "CATASTROESP_CACHE_DIR")

  expect_silent(
    installed <- catr_set_cache_dir(cache_dir, install = TRUE, verbose = FALSE)
  )

  expect_identical(installed, cache_dir)
  expect_identical(readLines(cache_config, warn = FALSE), cache_dir)
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), cache_dir)

  expect_snapshot(
    error = TRUE,
    catr_set_cache_dir(next_cache_dir, install = TRUE, verbose = FALSE)
  )

  expect_silent(
    overwritten <- catr_set_cache_dir(
      next_cache_dir,
      overwrite = TRUE,
      install = TRUE,
      verbose = FALSE
    )
  )

  expect_identical(overwritten, next_cache_dir)
  expect_identical(readLines(cache_config, warn = FALSE), next_cache_dir)
})

test_that("catr_clear_cache() preserves data when removing configuration", {
  config_dir <- withr::local_tempdir(pattern = "catr-config")
  data_dir <- withr::local_tempdir(pattern = "catr-cache")

  local_mocked_bindings(catr_r_user_dir = function(...) config_dir)
  withr::local_envvar(c(CATASTROESP_CACHE_DIR = data_dir))

  writeLines(data_dir, file.path(config_dir, "CATASTROESP_CACHE_DIR"))

  expect_message(
    catr_clear_cache(config = TRUE, cached_data = FALSE, verbose = TRUE),
    "cache configuration deleted"
  )

  expect_false(dir.exists(config_dir))
  expect_true(dir.exists(data_dir))
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), "")
})

test_that("detect_cache_dir_muted() reads configured cache paths", {
  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  config_dir <- withr::local_tempdir(pattern = "catr-config")
  cache_dir <- withr::local_tempdir(pattern = "catr-cache")

  local_mocked_bindings(catr_r_user_dir = function(...) config_dir)

  writeLines(cache_dir, file.path(config_dir, "CATASTROESP_CACHE_DIR"))

  detected <- detect_cache_dir_muted()

  expect_identical(detected, cache_dir)
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), cache_dir)
})

test_that("detect_cache_dir_muted() replaces invalid configured paths", {
  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  config_dir <- withr::local_tempdir(pattern = "catr-config")

  local_mocked_bindings(catr_r_user_dir = function(...) config_dir)

  writeLines("", file.path(config_dir, "CATASTROESP_CACHE_DIR"))

  detected <- detect_cache_dir_muted()

  expect_identical(detected, file.path(tempdir(), "CatastRo"))
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), detected)
})

test_that("detect_cache_dir_muted() defaults when configuration is absent", {
  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  config_dir <- withr::local_tempdir(pattern = "catr-config")

  local_mocked_bindings(catr_r_user_dir = function(...) config_dir)

  detected <- detect_cache_dir_muted()

  expect_identical(detected, file.path(tempdir(), "CatastRo"))
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), detected)
})

test_that("create_cache_dir() creates the cache when no path is supplied", {
  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  config_dir <- withr::local_tempdir(pattern = "catr-config")

  local_mocked_bindings(catr_r_user_dir = function(...) config_dir)

  created <- create_cache_dir()

  expect_identical(created, file.path(tempdir(), "CatastRo"))
  expect_true(dir.exists(created))
})

test_that("migrate_cache() moves legacy configuration", {
  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  old <- withr::local_tempdir(pattern = "catr-config-old")
  new <- withr::local_tempdir(pattern = "catr-config-new")
  cache_dir <- withr::local_tempdir(pattern = "catr-cache")

  local_mocked_bindings(catr_r_user_dir = function(...) new)

  writeLines(cache_dir, file.path(old, "CATASTROESP_CACHE_DIR"))

  expect_snapshot(migrate_cache(old = old, new = new))

  expect_false(dir.exists(old))
  expect_identical(
    readLines(file.path(new, "CATASTROESP_CACHE_DIR"), warn = FALSE),
    cache_dir
  )
})

test_that("catr_set_cache_dir() treats FALSE as a temporary cache request", {
  withr::local_envvar(CATASTROESP_CACHE_DIR = NA)

  expect_message(
    cache_dir <- catr_set_cache_dir(
      cache_dir = FALSE,
      install = TRUE,
      verbose = TRUE
    ),
    "temporary cache directory"
  )

  expect_identical(cache_dir, file.path(tempdir(), "CatastRo"))
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), cache_dir)
})

test_that("catr_set_cache_dir() rejects invalid arguments", {
  expect_snapshot(
    error = TRUE,
    catr_set_cache_dir(cache_dir = 1, verbose = FALSE)
  )
  expect_snapshot(
    error = TRUE,
    catr_set_cache_dir(overwrite = NA, verbose = FALSE)
  )
  expect_snapshot(
    error = TRUE,
    catr_set_cache_dir(
      cache_dir = tempdir(),
      install = c(TRUE, FALSE),
      verbose = FALSE
    )
  )
})
