#' ATOM INSPIRE: Download all buildings of a municipality
#'
#' Retrieve the spatial data of all buildings belonging to a single municipality
#' using the INSPIRE ATOM service.
#'
#' @references
#'
#' ```{r child = "man/chunks/atompdf.Rmd"}
#' ```

#' @family INSPIRE
#' @family ATOM
#' @family buildings
#' @family spatial
#'
#' @export
#' @return A [`sf`][sf::st_sf] object.
#'
#' @inheritParams catr_atom_get_parcels
#' @param what Information to load. It could be:
#'   - `"building"` for buildings.
#'   - `"buildingpart"` for parts of a building.
#'   - `"other"` for other elements, such as swimming pools, etc.
#'
#' @examplesIf run_example()
#' \donttest{
#' s <- catr_atom_get_buildings("Nava de la Asuncion",
#'   to = "Segovia",
#'   what = "building"
#' )
#'
#' library(ggplot2)
#' ggplot(s) +
#'   geom_sf() +
#'   coord_sf(
#'     xlim = c(374500, 375500),
#'     ylim = c(4556500, 4557500)
#'   ) +
#'   labs(
#'     title = "Buildings",
#'     subtitle = "Nava de la Asuncion, Segovia"
#'   )
#' }
#'
catr_atom_get_buildings <- function(
  munic,
  to = NULL,
  what = c(
    "building",
    "buildingpart",
    "other"
  ),
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  if (lifecycle::is_present(cache)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "CatastRo::catr_atom_get_buildings(cache)",
      details = "Results are always cached."
    )
  }

  # Sanity checks
  what <- match_arg_pretty(what)

  # Transform
  what <- switch(
    what,
    "building" = "building.gml",
    "buildingpart" = "buildingpart.gml",
    "other" = "other"
  )

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

  tb <- all[to_loc, ]

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

  municurls <- catr_atom_get_buildings_db_to(
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
    subdir = "atom_bu",
    update_cache = update_cache,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  sfobj <- read_geo_file_sf(file_local, hint = what)

  sfobj
}
