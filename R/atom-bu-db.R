#' ATOM INSPIRE: List building download URLs
#'
#' @description
#' Create a table of URLs provided by the Spanish Cadastre ATOM INSPIRE service
#' for downloading buildings.
#'
#' `r atom_db_details("buildings")`
#'
#' @inheritParams catr_atom_get_address_db_all
#' @inherit catr_atom_get_address_db_all return
#' @source
#' <https://www.catastro.hacienda.gob.es/INSPIRE/buildings/ES.SDGC.BU.atom.xml>
#'
#' @family buildings
#' @family atom_services
#' @rdname catr_atom_get_buildings_db
#'
#' @export
#' @encoding UTF-8
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
  warn_deprecated_cache(cache, "CatastRo::catr_atom_get_buildings_db_to(cache)")

  catr_atom_read_db_to(
    to = to,
    all_fn = catr_atom_get_buildings_db_all,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
