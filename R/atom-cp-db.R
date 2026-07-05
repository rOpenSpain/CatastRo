#' ATOM INSPIRE: reference database for ATOM cadastral parcels
#'
#' @description
#' Create a table of URLs provided by the Spanish Cadastre ATOM INSPIRE service
#' for downloading cadastral parcels.
#'
#' `catr_atom_get_parcels_db_all()` provides a top-level table with all
#' territorial offices, except the Basque Country and Navarre and the
#' municipalities included in each office. `catr_atom_get_parcels_db_to()`
#' provides a table for one territorial office and its municipalities.
#'
#' @inheritParams catr_atom_get_address_db_all
#' @inherit catr_atom_get_address_db_all return
#' @source
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(
#'    "<https://www.catastro.hacienda.gob.es/INSPIRE/CadastralParcels/",
#'      "ES.SDGC.CP.atom.xml>")
#'      )
#' ```
#'
#' @family atom
#' @family parcels
#' @rdname catr_atom_get_parcels_db
#'
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' \donttest{
#' catr_atom_get_parcels_db_all()
#' }
catr_atom_get_parcels_db_all <- function(
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(cache, "CatastRo::catr_atom_get_parcels_db_all(cache)")

  api_entry <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "CadastralParcels/ES.SDGC.CP.atom.xml"
  )

  catr_atom_read_db_all(
    api_entry = api_entry,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
#' @rdname catr_atom_get_parcels_db
#' @export
catr_atom_get_parcels_db_to <- function(
  to,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(cache, "CatastRo::catr_atom_get_parcels_db_to(cache)")

  catr_atom_read_db_to(
    to = to,
    all_fn = catr_atom_get_parcels_db_all,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
