test_that("catr_ssl_verify() and catr_timeout() use configured options", {
  skip_if_not_installed("withr")

  expect_equal(getOption("catastro_ssl_verify", 1L), 0)
  expect_equal(getOption("catastro_timeout", 300), 600)
  expect_equal(catr_ssl_verify(), 0)
  expect_equal(catr_timeout(), 600)

  withr::local_options(list(catastro_ssl_verify = 1L))
  expect_equal(getOption("catastro_ssl_verify", 1L), 1L)
  expect_equal(catr_ssl_verify(), 1L)
})

test_that("catr_http_config() reads environment variables", {
  withr::local_options(list(
    catastro_ssl_verify = NULL,
    catastro_timeout = NULL
  ))
  withr::local_envvar(c(CATASTRO_SSL_VERIFY = "0", CATASTRO_TIMEOUT = "600"))

  expect_equal(catr_ssl_verify(), 0)
  expect_equal(catr_timeout(), 600)

  withr::local_envvar(c(CATASTRO_SSL_VERIFY = NA, CATASTRO_TIMEOUT = NA))
  expect_equal(catr_ssl_verify(), 1L)
  expect_equal(catr_timeout(), 300)

  withr::local_envvar(c(
    CATASTRO_SSL_VERIFY = "invalid",
    CATASTRO_TIMEOUT = "invalid"
  ))
  expect_equal(catr_ssl_verify(), 1L)
  expect_equal(catr_timeout(), 300)
})

test_that("catr_http_config() gives options precedence over envvars", {
  withr::local_options(list(catastro_ssl_verify = 1L, catastro_timeout = 30))
  withr::local_envvar(c(CATASTRO_SSL_VERIFY = "0", CATASTRO_TIMEOUT = "600"))

  expect_equal(catr_ssl_verify(), 1L)
  expect_equal(catr_timeout(), 30)
})

test_that("download_url() applies HTTP environment settings to requests", {
  withr::local_options(list(
    catastro_ssl_verify = NULL,
    catastro_timeout = NULL
  ))
  withr::local_envvar(c(CATASTRO_SSL_VERIFY = "0", CATASTRO_TIMEOUT = "600"))

  seen <- list()
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    catr_req_perform = function(req, path = NULL, ...) {
      seen[[length(seen) + 1]] <<- req$options
      if (is.null(path)) {
        return(httr2::response(
          status_code = 200,
          headers = list("content-length" = "2")
        ))
      }

      writeLines("ok", path)
      httr2::response(status_code = 200)
    }
  )

  cdir <- withr::local_tempdir(pattern = "testthat_envvar")
  out <- download_url(
    "https://example.com/envvar.txt",
    cache_dir = cdir,
    verbose = FALSE
  )

  expect_type(out, "character")
  expect_equal(seen[[1]]$ssl_verifypeer, 0)
  expect_equal(seen[[1]]$timeout_ms, 600000)
})

test_that("download_url() returns NULL when offline", {
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
})

test_that("download_url() handles simulated HTTP 404 and successful retries", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex")

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
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

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })

  local_mocked_bindings(catr_req_perform = function(req, path = NULL, ...) {
    if (is.null(path)) {
      return(httr2::response(
        status_code = 200,
        headers = list("content-length" = "2")
      ))
    }
    writeLines("ok", path)
    httr2::response(status_code = 200)
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
  expect_type(s, "character")
})

test_that("download_url() reuses and refreshes cached files", {
  url <- paste0("https://example.com/", "mocked-cache.txt")

  req_perform_calls <- 0
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    catr_req_perform = function(req, path = NULL, ...) {
      req_perform_calls <<- req_perform_calls + 1

      if (is.null(path)) {
        return(httr2::response(
          status_code = 200,
          headers = list("content-length" = "2")
        ))
      }

      writeLines(paste0("ok-", req_perform_calls), path)
      httr2::response(status_code = 200)
    }
  )

  cdir <- withr::local_tempdir(pattern = "testthat_ex4")
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
  expect_equal(req_perform_calls, 4)
})

test_that("download_url() reports cache retrieval errors and retries", {
  url <- "https://example.com/noexist-this-file.txt"
  cdir <- withr::local_tempdir(pattern = "testthat_ex5")
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
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

  local_mocked_bindings(is_404 = function(...) FALSE)

  req_perform_calls <- 0
  local_mocked_bindings(catr_req_perform = function(req, path = NULL, ...) {
    req_perform_calls <<- req_perform_calls + 1

    if (req_perform_calls == 1) {
      return(httr2::response(
        status_code = 200,
        headers = list("content-length" = as.character(21 * 1024^2))
      ))
    }

    writeLines("ok", path)
    httr2::response(status_code = 200)
  })
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
    "Download size is"
  )
  expect_equal(req_perform_calls, 2)
})

test_that("download_url() removes partial files after HTTP errors", {
  url <- "https://example.com/http-error.txt"
  cdir <- withr::local_tempdir(pattern = "testthat_http_error")
  req_perform_calls <- 0
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    catr_req_perform = function(req, path = NULL, ...) {
      req_perform_calls <<- req_perform_calls + 1

      if (is.null(path)) {
        return(httr2::response(
          status_code = 200,
          headers = list("content-length" = "2")
        ))
      }

      writeLines("not found", path)
      httr2::response(status_code = 404)
    }
  )

  expect_snapshot(fend <- download_url(url, cache_dir = cdir, verbose = FALSE))
  expect_null(fend)
  expect_equal(req_perform_calls, 2)
  expect_false(file.exists(file.path(cdir, "fixme", basename(url))))
})

test_that("catr_never_error() always returns FALSE", {
  expect_false(catr_never_error())
  expect_false(catr_never_error("anything"))
})

test_that("download_url() removes partial files after transport failures", {
  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/Buildings/46",
    "/46900-VALENCIA/A.ES.SDGC.BU.46900.zip"
  )
  cdir <- withr::local_tempdir(pattern = "testthat_transport")
  fail <- function() {
    cli::cli_abort(
      "Mock transport failure.",
      class = "httr2_failure",
      call = NULL
    )
  }

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    catr_req_perform = function(...) fail()
  )
  expect_snapshot(fend <- download_url(url, cache_dir = cdir, verbose = FALSE))
  expect_null(fend)

  local_mocked_bindings(catr_req_perform = function(req, path = NULL, ...) {
    if (is.null(path)) {
      return(httr2::response(status_code = 200))
    }
    writeLines("partial", path)
    fail()
  })
  expect_snapshot(fend <- download_url(url, cache_dir = cdir, verbose = FALSE))
  expect_null(fend)
  expect_false(file.exists(file.path(cdir, "fixme", basename(url))))
})

test_that("get_request_body() returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "buildings/ES.SDGC.BU.atom.xml"
  )

  expect_snapshot(fend <- get_request_body(url, verbose = FALSE))
  expect_null(fend)
})

test_that("get_request_body() returns NULL after a simulated HTTP 404", {
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
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

test_that("get_request_body() returns NULL after transport failures", {
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    catr_req_perform = function(...) {
      cli::cli_abort(
        "Mock transport failure.",
        class = "httr2_failure",
        call = NULL
      )
    }
  )
  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )

  expect_snapshot(fend <- get_request_body(url, verbose = FALSE))
  expect_null(fend)
})


test_that("get_request_body() returns responses and handles HTTP errors", {
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    catr_req_perform = function(...) httr2::response(status_code = 200)
  )

  url <- paste0("https://example.com/", "mocked-body.txt")

  expect_message(fend <- get_request_body(url, verbose = TRUE), "Requesting")

  expect_s3_class(fend, "httr2_response")

  local_mocked_bindings(catr_req_perform = function(...) {
    httr2::response(status_code = 404)
  })

  url <- "https://example.com/noexist-this-file.txt"

  expect_message(fend <- get_request_body(url, verbose = TRUE), "Requesting")

  expect_null(fend)
})

test_that("download_url() can perform a real HTTP request", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  url <- "https://ropenspain.github.io/CatastRo/index.html"
  cdir <- withr::local_tempdir(pattern = "testthat_download_smoke")

  file_local <- download_url(
    url,
    cache_dir = cdir,
    subdir = "smoke",
    verbose = FALSE
  )

  expect_type(file_local, "character")
  expect_true(file.exists(file_local))
})

test_that("get_request_body() can perform a real HTTP request", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  resp <- get_request_body(
    "https://ropenspain.github.io/CatastRo/index.html",
    verbose = FALSE
  )

  expect_s3_class(resp, "httr2_response")
})
