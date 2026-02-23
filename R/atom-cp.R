#' ATOM INSPIRE: Download all cadastral parcels of a municipality
#'
#' @description
#' Retrieve the spatial data of all cadastral parcels belonging to a single
#' municipality using the INSPIRE ATOM service.
#'
#' @encoding UTF-8
#' @family INSPIRE
#' @family ATOM
#' @family parcels
#' @family spatial
#' @inheritParams catr_atom_get_address
#' @export
#'
#' @inherit catr_atom_get_address references return
#' @param what Information to load. It can be:
#'   - `"parcel"` for cadastral parcels.
#'   - `"zoning"` for cadastral zoning.
#'
#' @examplesIf run_example()
#' \donttest{
#' s <- catr_atom_get_parcels("Melque", to = "Segovia", what = "parcel")
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

    # Filter by territorial office if matches found
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

  # Compute string distances for municipality matching
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
    cli::cli_alert_danger("Discarding:")
    bullets <- tb[-1, ]$munic
    bullets <- paste0("{.str ", bullets, "}")
    names(bullets) <- rep(" ", length(bullets))
    cli::cli_bullets(bullets)

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
  # Extract municipality code from reference string
  ref <- unlist(strsplit(tb$munic, "-"))[1]

  # Prepare download URL for municipality data
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
