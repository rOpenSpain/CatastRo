test_that("SSL verifier (#40)", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("withr")

  # This is a check to see if setup.R work. Expected to fail if not
  # called with test_local(), etc.
  expect_equal(getOption("catastro_ssl_verify", 1L), 0L)
})

test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )
  cdir <- file.path(tempdir(), "testthat_ex3")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  expect_snapshot(
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = FALSE
    )
  )
  expect_null(fend)
  expect_length(list.files(cdir, recursive = TRUE), 0)
  unlink(cdir, recursive = TRUE, force = TRUE)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Test 404", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "CadastralParcels/ES.SDGC.CP.atom.xml"
  )

  expect_message(
    s <- download_url(
      url,
      verbose = FALSE,
      cache_dir = cdir,
      update_cache = TRUE
    ),
    "Error "
  )
  expect_null(s)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })

  # Otherwise work
  expect_silent(
    s <- download_url(
      url,
      verbose = FALSE,
      cache_dir = cdir,
      update_cache = TRUE
    )
  )
  expect_length(s, 1)
  expect_true(is.character(s))
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
})

test_that("Caching tests", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )

  cdir <- file.path(tempdir(), "testthat_ex4")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  expect_message(
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = TRUE
    ),
    "Cache dir is"
  )

  expect_length(list.files(cdir, recursive = TRUE), 1)

  expect_message(
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = TRUE
    ),
    "File already"
  )

  expect_message(
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = TRUE,
      verbose = TRUE
    ),
    "Updating cached"
  )

  unlink(cdir, recursive = TRUE, force = TRUE)
})

test_that("Caching errors", {
  skip_on_cran()
  skip_if_offline()

  url <- "http://ropenspain.github.io/CatastRo/noexist-this-file.txt"
  cdir <- file.path(tempdir(), "testthat_ex5")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  expect_message(
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = TRUE
    ),
    "Error"
  )

  expect_null(fend)

  # Warn if size of download is huge

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/Buildings/46",
    "/46900-VALENCIA/A.ES.SDGC.BU.46900.zip"
  )

  expect_message(
    download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = FALSE
    ),
    "The file to be downloaded has size"
  )

  unlink(cdir, recursive = TRUE, force = TRUE)
})


test_that("No connection body", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "buildings/ES.SDGC.BU.atom.xml"
  )

  expect_snapshot(
    fend <- get_request_body(url, verbose = FALSE)
  )
  expect_null(fend)
  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Error body", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })
  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )

  expect_snapshot(
    fend <- get_request_body(url, verbose = FALSE)
  )
  expect_null(fend)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})


test_that("Tests body", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )

  expect_message(
    fend <- get_request_body(url, verbose = TRUE),
    "GET"
  )

  expect_s3_class(fend, "httr2_response")

  url <- "http://ropenspain.github.io/CatastRo/noexist-this-file.txt"

  expect_message(
    fend <- get_request_body(url, verbose = TRUE),
    "GET"
  )

  expect_null(fend)
})
