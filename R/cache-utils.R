#' Set your \CRANpkg{CatastRo} cache directory
#'
#' @description
#' Configure the cache directory used by \CRANpkg{CatastRo}. Use
#' `Sys.getenv("CATASTROESP_CACHE_DIR")` or [catr_detect_cache_dir()] to inspect
#' the current path.
#' @details
#' By default, when no `cache_dir` is set, \CRANpkg{CatastRo} uses a directory
#' inside
#' [base::tempdir()] (so files are temporary and are removed when the \R
#' session ends). To persist a cache across \R sessions, use
#' `catr_set_cache_dir(cache_dir, install = TRUE)` which writes the chosen
#' path to a small configuration file under
#' `tools::R_user_dir("CatastRo", "config")`.
#'
#' @param cache_dir Path to a cache directory. If `NULL`, the function stores
#'   cached files in a temporary directory. See [base::tempdir()].
#' @param install Logical. If `TRUE`, stores the path locally for use in future
#'   sessions. Defaults to `FALSE`. If `cache_dir`
#'   is `FALSE`, this argument is set to `FALSE` automatically.
#' @param overwrite Logical. If `TRUE`, overwrites an existing
#'   `CATASTROESP_CACHE_DIR` value already present on your machine.
#' @param verbose Logical. If `TRUE`, displays informational messages.
#'
#' @return
#' `catr_set_cache_dir()` invisibly returns a character string containing the
#' cache path. It is primarily called for its side effect.
#'
#' @section Caching strategies:
#'
#' Some files can be read from their online source without caching by using the
#' argument `cache = FALSE`. Otherwise, the source file is downloaded to
#' your computer. \CRANpkg{CatastRo} implements the following caching options:
#'
#' - For occasional use, rely on the default [tempdir()]-based cache (no
#'   install).
#' - Modify the cache for a single session by setting
#'   `catr_set_cache_dir(cache_dir = "a/path/here")`.
#' - For reproducible workflows, install a persistent cache with
#'   `catr_set_cache_dir(cache_dir = "a/path/here", install = TRUE)`.
#'   This cache is kept across \R sessions.
#' - For caching specific files, use the `cache_dir` argument in the
#'   corresponding function.
#'
#' Cached files can occasionally become corrupt. In that case, try downloading
#' the data by setting `update_cache = TRUE` in the corresponding function.
#'
#' If a download fails, try another download method and save the file in
#' `cache_dir`. Use `verbose = TRUE` to inspect the API query
#' and [catr_detect_cache_dir()] to identify your cached path.
#'
#' @note
#'
#' In \CRANpkg{CatastRo} >= 1.0.0 the location of the configuration file has
#' moved from `rappdirs::user_config_dir("CatastRo", "R")` to
#' `tools::R_user_dir("CatastRo", "config")`. We have implemented a
#' function that migrates previous configuration files from one location to
#' another with a message. This message appears only once to inform you of the
#' migration.
#'
#' @seealso [tools::R_user_dir()] defines platform-specific user directories.
#'
#' @family cache_utilities
#' @rdname catr_set_cache_dir
#'
#' @encoding UTF-8
#' @export
#' @examples
#'
#' # Caution! This modifies your current state
#' \dontrun{
#' my_cache <- catr_detect_cache_dir()
#'
#' # Set an example cache
#' ex <- file.path(tempdir(), "example", "cachenew")
#' catr_set_cache_dir(ex)
#'
#' catr_detect_cache_dir()
#'
#' # Restore initial cache
#' catr_set_cache_dir(my_cache)
#' identical(my_cache, catr_detect_cache_dir())
#' }
#'
catr_set_cache_dir <- function(
  cache_dir = NULL,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
) {
  cache_dir <- ensure_null(cache_dir)

  # Use the default if not provided.
  if (is.null(cache_dir)) {
    make_msg(
      "info",
      verbose,
      "Using a temporary cache directory (see {.fn base::tempdir}). ",
      "Set {.arg cache_dir} to a value to store permanently."
    )

    # Create a folder in tempdir.
    cache_dir <- file.path(tempdir(), "CatastRo")
    is_temp <- TRUE
    install <- FALSE
  } else {
    is_temp <- FALSE
  }

  # Validate arguments.
  cli_abort_if_not(
    "{.arg cache_dir} must be a single {.cls character} value." = is.character(
      cache_dir
    ) &&
      length(cache_dir) == 1L &&
      !is.na(cache_dir),
    "{.arg overwrite} must be {.code TRUE} or {.code FALSE}." = is.logical(
      overwrite
    ) &&
      length(overwrite) == 1L &&
      !is.na(overwrite),
    "{.arg install} must be {.code TRUE} or {.code FALSE}." = is.logical(
      install
    ) &&
      length(install) == 1L &&
      !is.na(install)
  )

  # Create and expand the cache path.
  cache_dir <- create_cache_dir(cache_dir)
  msg <- paste0("{.pkg CatastRo} cache directory is {.path ", cache_dir, "}.")
  make_msg("info", verbose, msg)

  # Install the path in the environment variable.
  # nocov start

  if (install) {
    config_dir <- tools::R_user_dir("CatastRo", "config")
    # Create the cache directory if it is not present.
    if (!dir.exists(config_dir)) {
      dir.create(config_dir, recursive = TRUE)
    }

    catastroesp_file <- file.path(config_dir, "CATASTROESP_CACHE_DIR")

    if (!file.exists(catastroesp_file) || overwrite) {
      # Create the file if it does not exist.
      writeLines(cache_dir, con = catastroesp_file)
    } else {
      cli::cli_abort(c(
        "A {.arg cache_dir} value is already configured.",
        "Set {.arg overwrite = TRUE} to replace it."
      ))
    }
    # nocov end
  } else {
    make_msg(
      "info",
      verbose && !is_temp,
      "To reuse this {.arg cache_dir} in future sessions,",
      "run this function with {.arg install = TRUE}."
    )
  }

  Sys.setenv(CATASTROESP_CACHE_DIR = cache_dir)
  invisible(cache_dir)
}

#' @return
#' `catr_detect_cache_dir()` returns the path to the `cache_dir` used in this
#' session.
#'
#' @rdname catr_set_cache_dir
#' @export
#' @examples
#'
#' catr_detect_cache_dir()
#'
catr_detect_cache_dir <- function() {
  cd <- detect_cache_dir_muted()
  cli::cli_alert_info("{.path {cd}}")
  cd
}

#' Clear your \CRANpkg{CatastRo} cache directory
#'
#' @description
#' Use this function with caution. This function clears your cached data
#' and configuration, specifically:
#'
#' - Deletes the \CRANpkg{CatastRo} config directory
#'   (`tools::R_user_dir("CatastRo", "config")`).
#' - Deletes the `cache_dir` directory.
#' - Deletes the values stored on `Sys.getenv("CATASTROESP_CACHE_DIR")`.
#'
#' @details
#' This function resets the cache state as if you had never used
#' \CRANpkg{CatastRo}.
#'
#' @param config If `TRUE`, deletes the configuration folder of
#'   \CRANpkg{CatastRo}.
#' @param cached_data If `TRUE`, deletes your `cache_dir` and all its contents.
#' @inheritParams catr_set_cache_dir
#'
#' @return Invisibly returns `NULL`. This function is called for its side
#'   effects.
#'
#' @seealso [tools::R_user_dir()] defines platform-specific user directories.
#'
#' @family cache_utilities
#' @rdname catr_clear_cache
#' @encoding UTF-8
#' @export
#' @examples
#'
#' # Don't run this! It modifies your current state
#' \dontrun{
#' my_cache <- catr_detect_cache_dir()
#'
#' # Set an example cache
#' ex <- file.path(tempdir(), "example", "cache")
#' catr_set_cache_dir(ex, verbose = FALSE)
#'
#' # Restore initial cache
#' catr_clear_cache(verbose = TRUE)
#'
#' catr_set_cache_dir(my_cache)
#' identical(my_cache, catr_detect_cache_dir())
#' }
catr_clear_cache <- function(
  config = FALSE,
  cached_data = TRUE,
  verbose = FALSE
) {
  migrate_cache()

  config_dir <- tools::R_user_dir("CatastRo", "config")
  data_dir <- detect_cache_dir_muted()

  # nocov start
  if (config && dir.exists(config_dir)) {
    unlink(config_dir, recursive = TRUE, force = TRUE)

    if (verbose) {
      cli::cli_alert_warning("{.pkg CatastRo} cache configuration deleted.")
    }
  }
  # nocov end
  if (cached_data && dir.exists(data_dir)) {
    siz <- file.size(list.files(data_dir, recursive = TRUE, full.names = TRUE))
    siz <- sum(siz, na.rm = TRUE)
    class(siz) <- class(object.size("a"))

    siz <- format(siz, unit = "auto")

    unlink(data_dir, recursive = TRUE, force = TRUE)
    if (verbose) {
      cli::cli_alert_warning(
        "{.pkg CatastRo} cached data deleted: {.file {data_dir}} ({siz})."
      )
    }
  }

  Sys.setenv(CATASTROESP_CACHE_DIR = "")

  # Reset cache directory.
  invisible()
}

# Internal funs ----

#' Detect the cache directory silently
#'
#' @return Path to the cache directory.
#' @noRd
detect_cache_dir_muted <- function() {
  migrate_cache()

  # Try to read from the environment variable.
  getvar <- Sys.getenv("CATASTROESP_CACHE_DIR")

  if (is.null(getvar) || is.na(getvar) || !nzchar(getvar)) {
    # Retrieve the cache path from the configuration file.
    cache_config <- file.path(
      tools::R_user_dir("CatastRo", "config"),
      "CATASTROESP_CACHE_DIR"
    )

    # nocov start
    if (file.exists(cache_config)) {
      cached_path <- readLines(cache_config)

      # Use the default cache path for empty cached paths.
      if (any(is.null(cached_path), is.na(cached_path), !nzchar(cached_path))) {
        cache_dir <- catr_set_cache_dir(overwrite = TRUE, verbose = FALSE)
        return(cache_dir)
      }

      # Return the cached path.
      Sys.setenv(CATASTROESP_CACHE_DIR = cached_path)
      cached_path
      # nocov end
    } else {
      # Use the default cache location.

      cache_dir <- catr_set_cache_dir(overwrite = TRUE, verbose = FALSE)
      cache_dir
    }
  } else {
    getvar
  }
}

#' Create `cache_dir` if it does not exist
#'
#' @param cache_dir Path to the cache directory.
#' @return Path to the cache directory.
#'
#' @noRd
create_cache_dir <- function(cache_dir = NULL) {
  # Read the configured cache directory when no path is provided.
  if (is.null(cache_dir)) {
    cache_dir <- detect_cache_dir_muted()
  }

  cache_dir <- path.expand(cache_dir)

  # Create the cache directory if needed.
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir, recursive = TRUE)
  }
  cache_dir
}

#' Migrate the cache configuration
#'
#' Performs the one-time cache migration required by \CRANpkg{CatastRo} 1.0.0.
#'
#' @param old Path to the old cache configuration directory.
#' @param new Path to the new cache configuration directory.
#'
#' @noRd
migrate_cache <- function(
  old = rappdirs::user_config_dir("CatastRo", "R"),
  new = tools::R_user_dir("CatastRo", "config")
) {
  fname <- "CATASTROESP_CACHE_DIR"

  old_fname <- file.path(old, fname)
  new_fname <- file.path(new, fname)

  if (file.exists(new_fname)) {
    unlink(old, force = TRUE, recursive = TRUE)
    return(invisible())
  }

  if (file.exists(old_fname)) {
    cache_dir <- readLines(old_fname)
    catr_set_cache_dir(cache_dir, install = TRUE, verbose = FALSE)
    cli::cli_alert_success(c(
      "{.pkg CatastRo} cache configuration migrated for version 1.0.0 or ",
      "later. See {.strong Note} in {.fn CatastRo::catr_set_cache_dir}."
    ))
    cli::cli_alert_info("This one-time message will not be shown again.")
  }
  unlink(old, force = TRUE, recursive = TRUE)

  invisible()
}
