#' Set your \CRANpkg{CatastRo} cache dir
#'
#' @family cache utilities
#' @seealso [tools::R_user_dir()]
#'
#' @rdname catr_set_cache_dir
#'
#' @description
#' Store your `cache_dir` path locally for future sessions.
#' Type `Sys.getenv("CATASTROESP_CACHE_DIR")` or use
#' [catr_detect_cache_dir()] to find your cached path.
#' @encoding UTF-8
#'
#' @param cache_dir Path to a cache directory. On `NULL`, the function
#'   stores cached files in a temporary directory (see [base::tempdir()]).
#' @param install Logical. If `TRUE`, installs the key on your local
#'   machine for use in future sessions. Defaults to `FALSE`. If `cache_dir`
#'   is `FALSE`, this argument is set to `FALSE` automatically.
#' @param overwrite Logical. If `TRUE`, overwrites an existing
#'   `CATASTROESP_CACHE_DIR` value already present on your machine.
#' @param verbose Logical. If `TRUE`, displays informational messages.
#'
#' @details
#' By default, when no `cache_dir` is set, the package uses a folder inside
#' [base::tempdir()] (so files are temporary and are removed when the **R**
#' session ends). To persist a cache across **R** sessions, use
#' `catr_set_cache_dir(cache_dir, install = TRUE)` which writes the chosen
#' path to a small configuration file under
#' `tools::R_user_dir("CatastRo", "config")`.
#'
#' @return
#' `catr_set_cache_dir()` returns an (invisible) character with the path to
#' your `cache_dir`, but it is mainly called for its side effect.
#'
#' @section Caching strategies:
#'
#' Some files can be read from their online source without caching using the
#' option `cache = FALSE`. Otherwise the source file is downloaded to
#' your computer. \CRANpkg{CatastRo} implements the following caching options:
#'
#' - For occasional use, rely on the default [tempdir()]-based cache (no
#'   install).
#' - Modify the cache for a single session by setting
#'   `catr_set_cache_dir(cache_dir = "a/path/here")`.
#' - For reproducible workflows, install a persistent cache with
#'   `catr_set_cache_dir(cache_dir = "a/path/here", install = TRUE)`.
#'   This cache is kept across **R** sessions.
#' - For caching specific files, use the `cache_dir` argument in the
#'   corresponding function.
#'
#' Sometimes cached files may be corrupt. In that case, try re-downloading
#' the data by setting `update_cache = TRUE` in the corresponding function.
#'
#' If you experience any problem downloading, try downloading the
#' corresponding file by another method and save it in your
#' `cache_dir`. Use the option `verbose = TRUE` to debug the API query
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
#' @export
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
      "Using a temporary cache dir (see {.fn base::tempdir}). ",
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
  stopifnot(is.character(cache_dir), is.logical(overwrite), is.logical(install))

  # Create and expand the cache path.
  cache_dir <- create_cache_dir(cache_dir)
  msg <- paste0("{.pkg CatastRo} cache dir is {.path ", cache_dir, "}.")
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
        "A {.arg cache_dir} path already exists.",
        "You can overwrite it with {.arg overwrite = TRUE}."
      ))
    }
    # nocov end
  } else {
    make_msg(
      "info",
      verbose && !is_temp,
      "To install your {.arg cache_dir} path for use in future sessions",
      "run this function with {.arg install = TRUE}."
    )
  }

  Sys.setenv(CATASTROESP_CACHE_DIR = cache_dir)
  invisible(cache_dir)
}

#' @export
#' @rdname catr_set_cache_dir
#' @return
#' `catr_detect_cache_dir()` returns the path to the `cache_dir` used in this
#' session.
#'
#' @examples
#'
#' catr_detect_cache_dir()
#'
catr_detect_cache_dir <- function() {
  cd <- detect_cache_dir_muted()
  cli::cli_alert_info("{.path {cd}}")
  cd
}

#' Clear your \CRANpkg{CatastRo} cache dir
#'
#' @rdname catr_clear_cache
#' @family cache utilities
#' @encoding UTF-8
#'
#' @return Invisible. This function is called for its side effects.
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
#' @param config If `TRUE`, deletes the configuration folder of
#'   \CRANpkg{CatastRo}.
#' @param cached_data If `TRUE`, deletes your `cache_dir` and all its contents.
#' @inheritParams catr_set_cache_dir
#'
#' @seealso [tools::R_user_dir()]
#'
#' @details
#' This is an overkill function that is intended to reset your status
#' as if you had never installed and/or used \CRANpkg{CatastRo}.
#'
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
#' @export
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
        "{.pkg CatastRo} data deleted: {.file {data_dir}} ({siz})."
      )
    }
  }

  Sys.setenv(CATASTROESP_CACHE_DIR = "")

  # Reset cache directory.
  invisible()
}

# Internal funs ----

#' Detect cache dir silently
#'
#' @return Path to cache dir.
#' @noRd
detect_cache_dir_muted <- function() {
  migrate_cache()

  # Try to read from the environment variable.
  getvar <- Sys.getenv("CATASTROESP_CACHE_DIR")

  if (is.null(getvar) || is.na(getvar) || getvar == "") {
    # Retrieve the cache path from the configuration file.
    cache_config <- file.path(
      tools::R_user_dir("CatastRo", "config"),
      "CATASTROESP_CACHE_DIR"
    )

    # nocov start
    if (file.exists(cache_config)) {
      cached_path <- readLines(cache_config)

      # Use the default cache path for empty cached paths.
      if (any(is.null(cached_path), is.na(cached_path), cached_path == "")) {
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
#' @param cache_dir Path to cache dir.
#' @return Path to cache dir.
#'
#' @noRd
create_cache_dir <- function(cache_dir = NULL) {
  # Check cache dir from options if it is not set.
  if (is.null(cache_dir)) {
    cache_dir <- detect_cache_dir_muted()
  }

  cache_dir <- path.expand(cache_dir)

  # Create cache dir if needed.
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir, recursive = TRUE)
  }
  cache_dir
}

#' Migrate cache config from rappdirs to tools
#'
#' One-time function for CatastRo >= 1.0.0.
#' @param old Path to old cache config folder.
#' @param new Path to new cache config folder.
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
      "{.pkg CatastRo} >= 1.0.0: Cache configuration migrated. ",
      "See {.strong Note} in {.fn CatastRo::catr_set_cache_dir} for details."
    ))
    cli::cli_alert_info(
      "This is a one-time message. It will not be displayed in the future."
    )
  }
  unlink(old, force = TRUE, recursive = TRUE)

  invisible()
}
