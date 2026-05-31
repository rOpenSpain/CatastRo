#' ATOM INSPIRE: reference database for ATOM buildings
#'
#' @description
#' Create a database containing the URLs provided in the ATOM INSPIRE
#' service of the Spanish Cadastre for extracting buildings.
#'
#' `catr_atom_get_buildings_db_all()` provides a top-level table with all
#' territorial offices, except the Basque Country and Navarre, and the
#' municipalities included in each office. `catr_atom_get_buildings_db_to()`
#' provides a table for one territorial office and its municipalities.
#'
#' @inheritParams catr_atom_get_address_db_all
#' @inherit catr_atom_get_address_db_all return
#' @source
#' <https://www.catastro.hacienda.gob.es/INSPIRE/buildings/ES.SDGC.BU.atom.xml>
#'
#' @family INSPIRE
#' @family ATOM
#' @family buildings
#' @family databases
#' @rdname catr_atom_get_buildings_db
#'
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' \donttest{
#' catr_atom_get_buildings_db_all()
#' }
catr_atom_get_buildings_db_all <- function(
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(
    cache,
    "CatastRo::catr_atom_get_buildings_db_all(cache)"
  )

  api_entry <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "buildings/ES.SDGC.BU.atom.xml"
  )

  catr_atom_read_db_all(
    api_entry = api_entry,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
#' @rdname catr_atom_get_buildings_db
#' @export
catr_atom_get_buildings_db_to <- function(
  to,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(
    cache,
    "CatastRo::catr_atom_get_buildings_db_to(cache)"
  )

  catr_atom_read_db_to(
    to = to,
    all_fn = catr_atom_get_buildings_db_all,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
