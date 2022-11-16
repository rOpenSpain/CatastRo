catr_hlp_dwnload <- function(api_entry, filename, cache_dir,
                             verbose, update_cache, cache) {
  # Use secure http
  api_entry <- gsub("^http:", "https:", api_entry)

  # Encode
  api_entry <- utils::URLencode(api_entry)
  url <- api_entry

  cache_dir <- catr_hlp_cachedir(cache_dir)

  if (verbose) message("Cache dir is ", cache_dir)

  # Create filepath
  filepath <- file.path(cache_dir, filename)
  localfile <- file.exists(filepath)

  if (isFALSE(cache)) {
    dwnload <- FALSE
    filepath <- url
    if (verbose) {
      message("Try loading from ", filepath)
    }
    return(filepath)
  } else if (update_cache || isFALSE(localfile)) {
    dwnload <- TRUE
    if (verbose) {
      message(
        "Downloading file from ",
        url
      )
    }
    if (verbose && update_cache) {
      message("\nUpdating cache")
    }
  } else if (localfile) {
    dwnload <- FALSE
    if (verbose && isFALSE(update_cache)) {
      message("File already cached")
    }
  }

  # Downloading
  if (dwnload) {
    err_dwnload <- try(download.file(url, filepath,
      quiet = isFALSE(verbose),
      mode = "wb"
    ), silent = TRUE)

    # nocov start
    # On error retry
    if (inherits(err_dwnload, "try-error")) {
      if (verbose) message("Retrying query")
      err_dwnload <- try(download.file(url, filepath,
        quiet = isFALSE(verbose),
        mode = "wb"
      ), silent = TRUE)
    }
    # nocov end

    # If not then message
    if (inherits(err_dwnload, "try-error")) {
      # nocov start
      message(
        "Download failed",
        "\n\nurl \n ",
        url,
        " not reachable.\n\nPlease try with another options. ",
        "If you think this ",
        "is a bug please consider opening an issue"
      )
      stop("\nExecution halted")
      # nocov end
    } else if (verbose) {
      message("Download succesful")
    }
  }


  if (verbose && isTRUE(cache)) {
    message("Reading from local file ", filepath)
    size <- file.size(filepath)
    class(size) <- "object_size"
    message(format(size, units = "auto"))
  }

  return(filepath)
}
