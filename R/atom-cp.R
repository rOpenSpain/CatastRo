#' ATOM INSPIRE: Download all cadastral parcels of a municipality
#'
#' Retrieve the spatial data of all cadastral parcels belonging to a single
#' municipality using the INSPIRE ATOM service.
#'
#' @references
#'
#' ```{r child = "man/chunks/atompdf.Rmd"}
#' ```
#'
#' @family INSPIRE
#' @family ATOM
#' @family parcels
#' @family spatial
#'
#' @export
#' @return A [`sf`][sf::st_sf] object.
#'
#' @inheritParams catr_atom_get_parcels_db_all
#' @param munic Municipality to extract. It can be a part of a string or the
#'   cadastral code. See [catr_atom_search_munic()] for getting the cadastral
#'   codes.
#' @param to Optional parameter for defining the Territorial Office to which
#'   `munic` belongs. This parameter is a helper for narrowing the search.
#' @param what Information to load. It could be:
#'   -`"parcel"` for cadastral parcels.
#'   -`"zoning"` for cadastral zoning.
#' @examplesIf run_example()
#' \donttest{
#' s <- catr_atom_get_parcels("Melque",
#'   to = "Segovia",
#'   what = "parcel"
#' )
#'
#' library(ggplot2)
#'
#' ggplot(s) +
#'   geom_sf() +
#'   labs(
#'     title = "Cadastral Parcels",
#'     subtitle = "Melque de Cercos, Segovia"
#'   )
#' }
#'
catr_atom_get_parcels <- function(
  munic,
  to = NULL,
  what = c("parcel", "zoning"),
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  if (lifecycle::is_present(cache)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "CatastRo::catr_atom_get_parcels(cache)",
      details = "Results are always cached."
    )
  }

  # Sanity checks
  what <- match_arg_pretty(what)
  munic <- validate_non_empty_arg(munic)
  to <- ensure_null(to)

  all <- catr_atom_get_parcels_db_all(
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
      "No municipality found with pattern {.str {munic}}."
    )
    cli::cli_alert_info(
      paste0(
        "Check available municipalities with ",
        "{.fn CatastRo::catr_atom_get_address_db_all}."
      )
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
  tb <- with_d[order(with_d$dist), ]

  if (nrow(tb) > 1) {
    cli::cli_alert_info(
      "Found {nrow(tb)} municipalities with pattern {.str {munic}}."
    )

    cli::cli_alert_success("Selecting {.str {tb[1,]$munic}}.")
    cli::cli_alert_danger("Discarding {.str {tb[-1,]$munic}}.")
    tb <- tb[1, ]
  }

  make_msg(
    "info",
    verbose,
    paste0("Extracting information for {.str ", tb$munic, "}.")
  )

  municurls <- catr_atom_get_parcels_db_to(
    as.character(tb$territorial_office),
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  # Get munic code from reference
  ref <- unlist(strsplit(tb$munic, "-"))[1]

  # Download from url
  api_entry <- municurls[
    grepl(ref, municurls$munic, ignore.case = TRUE),
  ]$url

  api_entry <- URLencode(api_entry)

  file_local <- download_url(
    url = api_entry,
    cache_dir = cache_dir,
    subdir = "atom_cp",
    update_cache = update_cache,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  sfobj <- read_geo_file_sf(file_local, hint = what)

  sfobj
}
