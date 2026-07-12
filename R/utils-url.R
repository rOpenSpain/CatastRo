#' Download and cache a file from a URL
#'
#' @param url Character string containing the URL to download.
#' @param name Character string specifying the destination file name.
#' @param cache_dir Character string specifying the base cache directory.
#' @param subdir Character string specifying a cache subdirectory.
#' @param update_cache Logical. Whether to refresh the cached file.
#' @param verbose Logical. Whether to display informational messages.
#'
#' @return A character string containing the downloaded file path. Returns
#'   `NULL` if the download fails.
#' @encoding UTF-8
#'
#' @noRd
download_url <- function(
  url = NULL,
  name = basename(url),
  cache_dir = NULL,
  subdir = "fixme",
  update_cache = FALSE,
  verbose = TRUE
) {
  cache_dir <- create_cache_dir(cache_dir)
  cache_dir <- create_cache_dir(file.path(cache_dir, subdir))

  # Create and clean destination file.
  file_local <- file.path(cache_dir, name)
  file_local <- gsub("//", "/", file_local, fixed = TRUE)

  msg <- paste0("Using cache directory {.path ", cache_dir, "}.")
  make_msg("info", verbose, msg)

  # Check whether the file already exists.
  fileoncache <- file.exists(file_local)

  # Return cached files unless a refresh is requested.
  if (isFALSE(update_cache) && fileoncache) {
    msg <- paste0("Using cached file {.file ", file_local, "}.")
    make_msg("success", verbose, msg)

    return(file_local)
  }

  if (fileoncache) {
    make_msg("warning", verbose, "Refreshing cached file.")
  }

  msg <- paste0("Downloading {.url ", url, "}.")
  make_msg("info", verbose, msg)

  req <- httr2::request(url)
  req <- httr2::req_error(req, is_error = function(x) {
    FALSE
  })

  req <- httr2::req_options(
    req,
    ssl_verifypeer = getOption("catastro_ssl_verify", 1L)
  )

  req <- httr2::req_timeout(req, getOption("catastro_timeout", 300))
  req <- httr2::req_retry(req, max_tries = 3)
  if (verbose) {
    req <- httr2::req_progress(req)
  }

  if (!is_online_fun()) {
    cli::cli_alert_danger("No internet connection detected.")
    cli::cli_alert("Returning {.val NULL} because the request cannot run.")
    return(NULL)
  }

  # Simulate an HTTP failure when requested by tests.
  test_offline <- is_404()
  if (test_offline) {
    report_http_error(url)
    cli::cli_alert("Returning {.val NULL} because the download failed.")
    return(NULL)
  }

  # Use HEAD to check whether the download size should be reported.
  get_header <- httr2::req_method(req, "HEAD")
  getsize <- tryCatch(
    catr_req_perform(get_header),
    httr2_failure = function(cnd) {
      report_request_failure(cnd, "download")
      NULL
    }
  )
  if (is.null(getsize)) {
    return(NULL)
  }

  size_dwn <- as.numeric(httr2::resp_header(getsize, "content-length", 0))
  class(size_dwn) <- class(object.size("a"))
  thr <- 20 * (1024^2)
  if (size_dwn > thr) {
    sz_dwn <- paste0(format(size_dwn, units = "auto"), ".")
    make_msg("warning", TRUE, "Download size is", sz_dwn)
    req <- httr2::req_progress(req)
  }

  resp <- tryCatch(
    catr_req_perform(req, path = file_local),
    httr2_failure = function(cnd) {
      unlink(file_local, force = TRUE)
      report_request_failure(cnd, "download")
      NULL
    }
  )
  if (is.null(resp)) {
    return(NULL)
  }

  if (httr2::resp_is_error(resp)) {
    unlink(file_local, force = TRUE)
    report_http_error(
      url,
      httr2::resp_status(resp),
      httr2::resp_status_desc(resp)
    )
    cli::cli_alert("Returning {.val NULL} because the download failed.")
    return(NULL)
  }
  msg <- paste0("Downloaded file to {.file ", file_local, "}.")
  make_msg("success", verbose, msg)

  file_local
}

#' Get a response body from a URL
#'
#' @param url Character string containing the URL to request.
#' @param verbose Logical. Whether to display informational messages.
#'
#' @return A response object from \CRANpkg{httr2}. Returns `NULL` if the request
#'   fails.
#'
#' @noRd
get_request_body <- function(url, verbose = TRUE) {
  msg <- paste0("Requesting {.url ", url, "}.")
  make_msg("info", verbose, msg)

  req <- httr2::request(url)
  req <- httr2::req_error(req, is_error = function(x) {
    FALSE
  })

  req <- httr2::req_options(
    req,
    ssl_verifypeer = getOption("catastro_ssl_verify", 1L)
  )

  req <- httr2::req_timeout(req, getOption("catastro_timeout", 300))
  req <- httr2::req_retry(req, max_tries = 3)
  if (verbose) {
    req <- httr2::req_progress(req)
  }

  if (!is_online_fun()) {
    cli::cli_alert_danger("No internet connection detected.")
    cli::cli_alert("Returning {.val NULL} because the request cannot run.")
    return(NULL)
  }

  # Simulate an HTTP failure when requested by tests.
  test_offline <- is_404()
  if (test_offline) {
    report_http_error(url)
    cli::cli_alert("Returning {.val NULL} because the request failed.")
    return(NULL)
  }

  resp <- tryCatch(
    catr_req_perform(req),
    httr2_failure = function(cnd) {
      report_request_failure(cnd, "request")
      NULL
    }
  )
  if (is.null(resp)) {
    return(NULL)
  }

  if (httr2::resp_is_error(resp)) {
    report_http_error(
      url,
      httr2::resp_status(resp),
      httr2::resp_status_desc(resp)
    )
    cli::cli_alert("Returning {.val NULL} because the request failed.")
    return(NULL)
  }

  make_msg("success", verbose, "Request succeeded.")
  resp
}

#' Wrap `httr2::is_online()` for testing
#' @noRd
is_online_fun <- function(...) {
  httr2::is_online()
}

#' Wrap `httr2::req_perform()` for testing
#' @noRd
catr_req_perform <- function(...) {
  httr2::req_perform(...)
}

#' Report a simulated HTTP 404 response for testing
#' @noRd
is_404 <- function(...) {
  FALSE
}

report_http_error <- function(
  url,
  status_code = 404,
  status_desc = "Not Found"
) {
  cli::cli_alert_danger(c(
    "HTTP error {.val {status_code}} ({status_desc}):",
    " {.url {url}}."
  ))
  cli::cli_alert_warning(paste0(
    "If this looks like a package bug, open an issue at ",
    "{.url https://github.com/ropenspain/CatastRo/issues}."
  ))
}

report_request_failure <- function(cnd, type) {
  cli::cli_alert_danger(
    "The {type} request could not be completed."
  )
  cli::cli_alert_warning(conditionMessage(cnd))
  cli::cli_alert(
    "Returning {.val NULL} because the {type} failed."
  )
}
