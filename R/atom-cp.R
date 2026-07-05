#' ATOM INSPIRE: download all cadastral parcels of a municipality
#'
#' @description
#' Retrieve spatial data for all cadastral parcels in a municipality using the
#' ATOM INSPIRE service.
#'
#' @param what Information to load. Options are:
#' - `"parcel"` for cadastral parcels.
#' - `"zoning"` for cadastral zoning.
#'
#' @inheritParams catr_atom_get_address
#' @inherit catr_atom_get_address references return
#'
#' @family atom
#' @family parcels
#' @encoding UTF-8
#' @export
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
#'     title = "Cadastral parcels",
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
  warn_deprecated_cache(cache, "CatastRo::catr_atom_get_parcels(cache)")

  # Validate arguments.
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

  tb <- catr_atom_select_munic(
    all = all,
    munic = munic,
    to = to,
    db_all_call = "catr_atom_get_parcels_db_all",
    verbose = verbose
  )

  if (is.null(tb)) {
    return(NULL)
  }

  municurls <- catr_atom_get_parcels_db_to(
    as.character(tb$territorial_office),
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  api_entry <- catr_atom_get_munic_url(municurls, tb$munic)

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
