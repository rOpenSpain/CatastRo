#' ATOM INSPIRE: search for municipality codes
#'
#' @description
#' Search for a municipality by name or code and return matching Spanish
#' Cadastre municipality codes.
#'
#' @inheritParams catr_atom_get_parcels
#'
#' @return A [tibble][tibble::tbl_df] with the territorial office,
#'   municipality name and cadastral code. Returns `NULL` if no match is found.
#'
#' @family atom
#' @family search
#'
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' \donttest{
#' catr_atom_search_munic("Mad")
#' }
catr_atom_search_munic <- function(
  munic,
  to = NULL,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(cache, "CatastRo::catr_atom_search_munic(cache)")

  munic <- validate_non_empty_arg(munic)
  to <- ensure_null(to)

  all <- catr_atom_get_address_db_all(
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  if (is.null(all)) {
    return(NULL)
  }

  if (!is.null(to)) {
    linesto <- grep(to, all$territorial_office, ignore.case = TRUE)

    # Filter by territorial office if matches are found.
    if (length(linesto) > 1) {
      all <- all[linesto, ]
    } else {
      if (verbose) {
        cli::cli_alert_warning(paste0(
          "Ignoring {.arg to}, no territorial office ",
          "matched {.str {to}}."
        ))
      }
    }
  }

  to_loc <- ensure_null(grep(munic, all$munic, ignore.case = TRUE))

  if (is.null(to_loc)) {
    if (is.null(to)) {
      cli::cli_alert_warning("No municipality matched pattern {.str {munic}}.")
    } else {
      cli::cli_alert_warning(
        "No municipality matched pattern {.str {munic}} in {.str {to}}."
      )
    }
    return(NULL)
  }

  # Compute string distances for municipality matching.
  with_d <- data.frame(
    munic = all$munic,
    territorial_office = all$territorial_office,
    dist = as.vector(adist(munic, all$munic))
  )
  with_d <- with_d[to_loc, ]
  with_d <- with_d[order(with_d$dist), ]

  # Keep the matching rows and columns.
  res <- with_d[, c("territorial_office", "munic")]

  # Split municipality labels to get the code.

  res$catrcode <- vapply(
    res$munic,
    function(x) {
      unlist(strsplit(x, "-"))[1]
    },
    FUN.VALUE = character(1)
  )

  res
}
