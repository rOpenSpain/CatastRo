#' ATOM INSPIRE: download all buildings for a municipality
#'
#' @description
#' Retrieve spatial data for all buildings in a municipality using the ATOM
#' INSPIRE service.
#'
#' @param what Information to load. Options are:
#' - `"building"` for buildings.
#' - `"buildingpart"` for parts of a building.
#' - `"other"` for other elements such as swimming pools.
#'
#' @inheritParams catr_atom_get_address
#' @inherit catr_atom_get_address references return
#'
#' @family atom
#' @family buildings
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' \donttest{
#' s <- catr_atom_get_buildings("Nava de la Asuncion", to = "Segovia")
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
  what = c("building", "buildingpart", "other"),
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(cache, "CatastRo::catr_atom_get_buildings(cache)")

  # Validate arguments.
  what <- match_arg_pretty(what)

  # Convert the selected layer to the source file name.
  what <- switch(what,
    "building" = "building.gml",
    "buildingpart" = "buildingpart.gml",
    "other" = "other"
  )

  munic <- validate_non_empty_arg(munic)
  to <- ensure_null(to)

  all <- catr_atom_get_buildings_db_all(
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  if (is.null(all)) {
    return(NULL)
  }

  tb <- catr_atom_select_munic(
    all = all,
    munic = munic,
    to = to,
    db_all_call = "catr_atom_get_buildings_db_all",
    verbose = verbose
  )

  if (is.null(tb)) {
    return(NULL)
  }

  municurls <- catr_atom_get_buildings_db_to(
    as.character(tb$territorial_office),
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  api_entry <- catr_atom_get_munic_url(municurls, tb$munic)

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
