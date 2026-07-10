test_that("Test cache", {
  skip_on_cran()
  # Get current cache dir
  expect_message(current <- catr_detect_cache_dir())

  # Set a temp cache dir
  expect_message(catr_set_cache_dir(verbose = TRUE))
  testdir <- expect_silent(catr_set_cache_dir(
    file.path(current, "testthat"),
    verbose = FALSE
  ))

  expect_identical(catr_detect_cache_dir(), testdir)

  # Clean
  expect_silent(catr_clear_cache(config = FALSE, verbose = FALSE))
  # Cache dir should be deleted now
  expect_false(dir.exists(testdir))

  # Reset just for testing all cases
  testdir <- file.path(tempdir(), "catastro", "testthat")
  expect_message(catr_set_cache_dir(testdir))

  expect_true(dir.exists(testdir))

  expect_message(catr_clear_cache(config = FALSE, verbose = TRUE))

  # Cache dir should be deleted now
  expect_false(dir.exists(testdir))

  # Restore cache
  expect_message(catr_set_cache_dir(current, verbose = TRUE))
  expect_silent(catr_set_cache_dir(current, verbose = FALSE))
  expect_equal(current, Sys.getenv("CATASTROESP_CACHE_DIR"))
  expect_true(dir.exists(current))
})

test_that("catr_set_cache_dir installs and overwrites mocked config", {
  skip_on_cran()

  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  config_dir <- file.path(tempdir(), "catr-config-missing")
  unlink(config_dir, recursive = TRUE, force = TRUE)
  withr::defer(unlink(config_dir, recursive = TRUE, force = TRUE))

  cache_dir <- withr::local_tempdir(pattern = "catr-cache")
  next_cache_dir <- withr::local_tempdir(pattern = "catr-cache-next")

  local_mocked_bindings(catr_r_user_dir = function(...) config_dir)

  cache_config <- file.path(config_dir, "CATASTROESP_CACHE_DIR")

  expect_silent(
    installed <- catr_set_cache_dir(
      cache_dir,
      install = TRUE,
      verbose = FALSE
    )
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

test_that("catr_clear_cache removes mocked config", {
  skip_on_cran()

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

test_that("detect_cache_dir_muted uses mocked config", {
  skip_on_cran()

  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  config_dir <- withr::local_tempdir(pattern = "catr-config")
  cache_dir <- withr::local_tempdir(pattern = "catr-cache")

  local_mocked_bindings(catr_r_user_dir = function(...) config_dir)

  writeLines(cache_dir, file.path(config_dir, "CATASTROESP_CACHE_DIR"))

  detected <- detect_cache_dir_muted()

  expect_identical(detected, cache_dir)
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), cache_dir)
})

test_that("detect_cache_dir_muted replaces invalid mocked config", {
  skip_on_cran()

  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  config_dir <- withr::local_tempdir(pattern = "catr-config")

  local_mocked_bindings(catr_r_user_dir = function(...) config_dir)

  writeLines("", file.path(config_dir, "CATASTROESP_CACHE_DIR"))

  detected <- detect_cache_dir_muted()

  expect_identical(detected, file.path(tempdir(), "CatastRo"))
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), detected)
})

test_that("detect_cache_dir_muted uses default cache with no mocked config", {
  skip_on_cran()

  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  config_dir <- withr::local_tempdir(pattern = "catr-config")

  local_mocked_bindings(catr_r_user_dir = function(...) config_dir)

  detected <- detect_cache_dir_muted()

  expect_identical(detected, file.path(tempdir(), "CatastRo"))
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), detected)
})

test_that("create_cache_dir detects missing cache_dir", {
  skip_on_cran()

  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  config_dir <- withr::local_tempdir(pattern = "catr-config")

  local_mocked_bindings(catr_r_user_dir = function(...) config_dir)

  created <- create_cache_dir()

  expect_identical(created, file.path(tempdir(), "CatastRo"))
  expect_true(dir.exists(created))
})

test_that("migrate_cache moves old mocked config", {
  skip_on_cran()

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

test_that("cache_dir = FALSE uses a nonpersistent temporary cache", {
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

test_that("catr_set_cache_dir validates arguments", {
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
