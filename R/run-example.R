#' Decide whether an example should run
#'
#' @description
#' Determine whether an example should run based on the current platform and
#' network availability.
#'
#' @return Logical. `TRUE` if examples should run, `FALSE` otherwise.
#' @encoding UTF-8
#'
#' @details
#' Returns `FALSE` on CRAN, macOS, or when offline.
#'
#' @keywords internal
#' @export
#' @examples
#' run_example()
#'
run_example <- function() {
  if (on_mac()) {
    return(FALSE)
  }
  if (!httr2::is_online()) {
    return(FALSE) # nocov
  }
  if (on_cran()) {
    return(FALSE)
  }

  TRUE
}

#' Check if running on CRAN
#'
#' @return Logical. `TRUE` if running on CRAN, `FALSE` otherwise.
#'
#' @noRd
on_cran <- function() {
  env <- Sys.getenv("NOT_CRAN")
  if (identical(env, "")) {
    !interactive() # nocov
  } else {
    !isTRUE(as.logical(env))
  }
}

#' Check if running on macOS
#'
#' @return Logical. `TRUE` if running on macOS, `FALSE` otherwise.
#'
#' @noRd
on_mac <- function() {
  tolower(Sys.info()[["sysname"]]) %in% c("mac", "darwin")
}
