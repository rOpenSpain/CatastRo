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

test_that("Mock restart", {
  skip_on_cran()

  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  cache_config <- file.path(
    tools::R_user_dir("CatastRo", "config"),
    "CATASTROESP_CACHE_DIR"
  )

  config_existed <- file.exists(cache_config)
  config_value <- if (config_existed) {
    readLines(cache_config, warn = FALSE)
  } else {
    NULL
  }

  withr::defer({
    unlink(cache_config)

    if (config_existed) {
      dir.create(dirname(cache_config), recursive = TRUE, showWarnings = FALSE)
      writeLines(config_value, cache_config)
    }
  })

  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), "")

  if (config_existed) {
    catr_clear_cache(cached_data = FALSE, config = TRUE)

    expect_false(file.exists(cache_config))
    expect_false(nzchar(Sys.getenv("CATASTROESP_CACHE_DIR")))

    default_loc <- detect_cache_dir_muted()

    expect_identical(file.path(tempdir(), "CatastRo"), default_loc)

    expect_message(
      catr_set_cache_dir(config_value, overwrite = TRUE, install = TRUE),
      "cache directory is"
    )
  }

  muted <- detect_cache_dir_muted()
  created <- create_cache_dir()
  muted2 <- detect_cache_dir_muted()

  expect_identical(muted, created)
  expect_identical(muted, muted2)
  expect_true(nzchar(Sys.getenv("CATASTROESP_CACHE_DIR")))
})

test_that("Mock migration", {
  skip_on_cran()

  withr::local_envvar(c(CATASTROESP_CACHE_DIR = NA))

  old <- rappdirs::user_config_dir("CatastRo", "R")
  new <- tools::R_user_dir("CatastRo", "config")
  fname <- "CATASTROESP_CACHE_DIR"

  old_fname <- file.path(old, fname)
  new_fname <- file.path(new, fname)

  old_existed <- file.exists(old_fname)
  new_existed <- file.exists(new_fname)

  old_value <- if (old_existed) {
    readLines(old_fname, warn = FALSE)
  } else {
    NULL
  }

  new_value <- if (new_existed) {
    readLines(new_fname, warn = FALSE)
  } else {
    NULL
  }

  withr::defer({
    unlink(old_fname)
    unlink(new_fname)

    if (old_existed) {
      dir.create(dirname(old_fname), recursive = TRUE, showWarnings = FALSE)
      writeLines(old_value, old_fname)
    }

    if (new_existed) {
      dir.create(dirname(new_fname), recursive = TRUE, showWarnings = FALSE)
      writeLines(new_value, new_fname)
    }
  })

  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), "")

  unlink(old_fname)
  unlink(new_fname)

  expect_false(file.exists(old_fname))
  expect_false(file.exists(new_fname))

  create_cache_dir(old)
  writeLines(tempdir(), old_fname)
  expect_true(file.exists(old_fname))

  expect_snapshot(detected <- detect_cache_dir_muted())

  expect_silent(detected2 <- detect_cache_dir_muted())

  expect_identical(detected, detected2)
  expect_identical(detected, tempdir())
  expect_identical(Sys.getenv("CATASTROESP_CACHE_DIR"), detected)

  expect_false(file.exists(old_fname))
  expect_true(file.exists(new_fname))
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
