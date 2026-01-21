#' Creates `cache_dir` if not exists
#'
#' @param cache_dir path to cache dir
#' @returns path to cache dir
#'
#' @noRd
create_cache_dir <- function(cache_dir = NULL) {
  # Check cache dir from options if not set
  if (is.null(cache_dir)) {
    cache_dir <- catr_hlp_detect_cache_dir()
  }

  cache_dir <- path.expand(cache_dir)

  # Create cache dir if needed
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir, recursive = TRUE)
  }
  cache_dir
}
