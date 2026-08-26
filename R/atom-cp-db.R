#' ATOM INSPIRE: List cadastral parcel download URLs
#'
#' @description
#' Create a table of URLs provided by the Spanish Cadastre ATOM INSPIRE service
#' for downloading cadastral parcels.
#'
#' `r atom_db_details("parcels")`
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
#' @family parcels
#' @family atom_services
#' @rdname catr_atom_get_parcels_db
#'
#' @export
#' @encoding UTF-8
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
