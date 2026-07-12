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

  expect_false(catr_is_error(NULL))

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )
  cdir <- withr::local_tempdir(pattern = "testthat_ex3")
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

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Test 404", {
  skip_on_cran()

  cdir <- withr::local_tempdir(pattern = "testthat_ex")
  calls <- 0L

  local_mocked_bindings(
    is_404 = function(...) {
      TRUE
    },
    catr_req_perform = function(...) {
      calls <<- calls + 1L
      httr2::response(status_code = 404)
    }
  )

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
    "HTTP error"
  )
  expect_null(s)
  expect_identical(calls, 1L)

  local_mocked_bindings(
    is_404 = function(...) {
      FALSE
    },
    catr_req_perform = function(..., path = NULL) {
      if (!is.null(path)) {
        writeLines("ok", path)
      }
      httr2::response(
        status_code = 200,
        headers = list("content-length" = "0")
      )
    }
  )

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
  expect_type(s, "character")
})

test_that("download_url handles HEAD transport failures", {
  skip_on_cran()

  cdir <- withr::local_tempdir(pattern = "testthat_ex_head_failure")
  url <- "https://example.test/file.txt"

  local_mocked_bindings(
    catr_req_perform = function(...) {
      stop(structure(
        list(message = "Connection reset by peer", call = NULL),
        class = c("httr2_failure", "error", "condition")
      ))
    }
  )

  expect_snapshot(
    fend <- download_url(url, cache_dir = cdir, verbose = FALSE)
  )
  expect_null(fend)
  expect_length(list.files(cdir, recursive = TRUE), 0)
})

test_that("download_url handles download transport failures", {
  skip_on_cran()

  cdir <- withr::local_tempdir(pattern = "testthat_ex_get_failure")
  url <- "https://example.test/file.txt"
  calls <- 0L

  local_mocked_bindings(
    catr_req_perform = function(...) {
      calls <<- calls + 1L

      if (calls == 1L) {
        return(httr2::response(
          status_code = 200,
          headers = list("content-length" = "0")
        ))
      }

      stop(structure(
        list(message = "Connection reset by peer", call = NULL),
        class = c("httr2_failure", "error", "condition")
      ))
    }
  )

  expect_snapshot(
    fend <- download_url(url, cache_dir = cdir, verbose = FALSE)
  )
  expect_null(fend)
  expect_length(list.files(cdir, recursive = TRUE), 0)
})

test_that("Caching tests", {
  skip_on_cran()

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )

  cdir <- withr::local_tempdir(pattern = "testthat_ex4")

  local_mocked_bindings(
    catr_req_perform = function(..., path = NULL) {
      if (!is.null(path)) {
        writeLines("ok", path)
      }
      httr2::response(
        status_code = 200,
        headers = list("content-length" = "0")
      )
    }
  )

  expect_message(
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = TRUE
    ),
    "Using cache directory"
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
    "Using cached file"
  )

  expect_message(
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = TRUE,
      verbose = TRUE
    ),
    "Refreshing cached file"
  )
})

test_that("Caching errors", {
  skip_on_cran()

  url <- "http://ropenspain.github.io/CatastRo/noexist-this-file.txt"
  cdir <- withr::local_tempdir(pattern = "testthat_ex5")

  local_mocked_bindings(
    catr_req_perform = function(..., path = NULL) {
      httr2::response(
        status_code = 404,
        headers = list("content-length" = "0")
      )
    }
  )

  expect_message(
    fend <- download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = TRUE
    ),
    "HTTP error"
  )

  expect_null(fend)

  # Warn if size of download is huge

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/Buildings/46",
    "/46900-VALENCIA/A.ES.SDGC.BU.46900.zip"
  )

  local_mocked_bindings(
    catr_req_perform = function(..., path = NULL) {
      if (!is.null(path)) {
        writeLines("ok", path)
      }
      httr2::response(
        status_code = 200,
        headers = list("content-length" = as.character(21 * 1024^2))
      )
    }
  )

  expect_message(
    download_url(
      url,
      cache_dir = cdir,
      subdir = "fixme",
      update_cache = FALSE,
      verbose = FALSE
    ),
    "Download size is"
  )
})

test_that("No connection body", {
  skip_on_cran()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "buildings/ES.SDGC.BU.atom.xml"
  )

  expect_snapshot(fend <- get_request_body(url, verbose = FALSE))
  expect_null(fend)
  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Error body", {
  skip_on_cran()

  local_mocked_bindings(
    is_404 = function(...) {
      TRUE
    },
    catr_req_perform = function(...) {
      httr2::response(status_code = 404)
    }
  )
  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )

  expect_snapshot(fend <- get_request_body(url, verbose = FALSE))
  expect_null(fend)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("get_request_body handles transport failures", {
  skip_on_cran()

  local_mocked_bindings(
    catr_req_perform = function(...) {
      stop(structure(
        list(message = "Connection reset by peer", call = NULL),
        class = c("httr2_failure", "error", "condition")
      ))
    }
  )

  expect_snapshot(
    fend <- get_request_body("https://example.test/body.xml", verbose = FALSE)
  )
  expect_null(fend)
})


test_that("Tests body", {
  skip_on_cran()

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )

  local_mocked_bindings(catr_req_perform = function(...) {
    httr2::response(status_code = 200)
  })

  expect_message(fend <- get_request_body(url, verbose = TRUE), "Requesting")

  expect_s3_class(fend, "httr2_response")

  url <- "http://ropenspain.github.io/CatastRo/noexist-this-file.txt"

  local_mocked_bindings(catr_req_perform = function(...) {
    httr2::response(status_code = 404)
  })

  expect_message(fend <- get_request_body(url, verbose = TRUE), "Requesting")

  expect_null(fend)
})
