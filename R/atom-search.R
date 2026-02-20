#' ATOM INSPIRE: Search for municipality codes
#'
#' @description
#' Search for a municipality (as a string, part of a string, or code) and get
#' the corresponding code as per the Cadastre.
#'
#' @family ATOM
#' @family search
#' @family databases
#'
#' @inheritParams catr_atom_get_parcels
#'
#' @return A [tibble][tibble::tbl_df].
#'
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
  if (lifecycle::is_present(cache)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "CatastRo::catr_atom_search_munic(cache)",
      details = "Results are always cached."
    )
  }

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

    # Ignore if no result
    if (length(linesto) > 1) {
      all <- all[linesto, ]
    } else {
      if (verbose) {
        cli::cli_alert_warning(
          paste0(
            "Ignoring {.arg to} argument. No results ",
            "found with pattern {.str {munic}} in {.str {to}}."
          )
        )
      }
    }
  }

  to_loc <- ensure_null(grep(munic, all$munic, ignore.case = TRUE))

  if (is.null(to_loc)) {
    cli::cli_alert_warning(
      "No municipality found with pattern {.str {munic}} in {.str {to}}."
    )
    return(NULL)
  }

  # Check with distances
  with_d <- data.frame(
    munic = all$munic,
    territorial_office = all$territorial_office,
    dist = as.vector(adist(munic, all$munic))
  )
  with_d <- with_d[to_loc, ]
  with_d <- with_d[order(with_d$dist), ]

  # Get lines and cols
  res <- with_d[, c("territorial_office", "munic")]

  # Split to get code

  res$catrcode <- vapply(
    res$munic,
    function(x) {
      unlist(strsplit(x, "-"))[1]
    },
    FUN.VALUE = character(1)
  )

  res
}
