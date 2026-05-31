#' Internal function to download and cache a file from a URL
#'
#' @param url Character string. The URL to download.
#' @param name Character string. The name of the file to save.
#' @param cache_dir Character string. The base cache directory.
#' @param subdir Character string. Subdirectory inside the cache directory.
#' @param update_cache Logical. Whether to update the cached file.
#' @param verbose Logical. Whether to print messages.
#'
#' @return Character string. Path of the downloaded file.
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

  # Use HEAD to check whether the download size should be reported.
  get_header <- httr2::req_method(req, "HEAD")
  getsize <- httr2::req_perform(get_header)

  size_dwn <- as.numeric(httr2::resp_header(getsize, "content-length", 0))
  class(size_dwn) <- class(object.size("a"))
  thr <- 20 * (1024^2)
  if (size_dwn > thr) {
    sz_dwn <- paste0(format(size_dwn, units = "auto"), ".")
    make_msg("warning", TRUE, "Download size is", sz_dwn)
    req <- httr2::req_progress(req)
  }

  # Testing.
  test_offline <- is_404()
  if (test_offline) {
    # Redirect to a fake URL.
    req <- httr2::req_url(req, "http://ovc.catastro.meh.es/urlnoexist/fake")
    file_local <- tempfile(fileext = ".txt")
  }

  resp <- httr2::req_perform(req, path = file_local)

  if (httr2::resp_is_error(resp)) {
    unlink(file_local, force = TRUE)
    get_status_code <- httr2::resp_status(resp) # nolint
    get_status_desc <- httr2::resp_status_desc(resp) # nolint

    cli::cli_alert_danger(c(
      "{.strong HTTP error {get_status_code}} ({get_status_desc}):",
      " {.url {url}}."
    ))
    cli::cli_alert_warning(c(
      "If this looks like a package bug, please open an issue at ",
      "{.url https://github.com/ropenspain/CatastRo/issues}"
    ))
    cli::cli_alert("Returning {.val NULL} because the download failed.")
    return(NULL)
  }
  msg <- paste0("Downloaded file to {.file ", file_local, "}.")
  make_msg("success", verbose, msg)

  file_local
}

#' Internal function to get the response body from a URL
#'
#' @param url Character string. The URL to download.
#' @param verbose Logical. Whether to print messages.
#'
#' @return httr2 response object.
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

  # Testing.
  test_offline <- is_404()
  if (test_offline) {
    # Redirect to a fake URL.
    req <- httr2::req_url(req, "http://ovc.catastro.meh.es/urlnoexist/fake")
  }

  resp <- httr2::req_perform(req)

  if (httr2::resp_is_error(resp)) {
    get_status_code <- httr2::resp_status(resp) # nolint
    get_status_desc <- httr2::resp_status_desc(resp) # nolint

    cli::cli_alert_danger(c(
      "{.strong HTTP error {get_status_code}} ({get_status_desc}):",
      " {.url {url}}."
    ))
    cli::cli_alert_warning(c(
      "If this looks like a package bug, please open an issue at ",
      "{.url https://github.com/ropenspain/CatastRo/issues}"
    ))
    cli::cli_alert("Returning {.val NULL} because the request failed.")
    return(NULL)
  }

  make_msg("success", verbose, "Request succeeded.")
  resp
}

#' Wrapper is_online for testing
#' @noRd
is_online_fun <- function(...) {
  httr2::is_online()
}

#' Wrapper is_404 for testing
#' @noRd
is_404 <- function(...) {
  FALSE
}
