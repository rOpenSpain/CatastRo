#' Should the example run?
#'
#' Internal function to decide whether the example should run or not
#'
#' @return logical `TRUE` or `FALSE`
#'
#' @details
#' On CRAN or in mac results on `FALSE`
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

#' Internal function to check if we are on CRAN
#' @return logical
#' @noRd
on_cran <- function() {
  env <- Sys.getenv("NOT_CRAN")
  if (identical(env, "")) {
    !interactive() # nocov
  } else {
    !isTRUE(as.logical(env))
  }
}

#' Internal function to check if we are on macos
#' @return logical
#' @noRd
on_mac <- function() {
  tolower(Sys.info()[["sysname"]]) %in% c("mac", "darwin")
}
