#' ATOM INSPIRE: reference database for ATOM addresses
#'
#' @description
#' Create a database containing the URLs provided in the ATOM INSPIRE
#' service of the Spanish Cadastre for extracting addresses.
#'
#' `catr_atom_get_address_db_all()` provides a top-level table with all
#' territorial offices, except the Basque Country and Navarre, and the
#' municipalities included in each office. `catr_atom_get_address_db_to()`
#' provides a table for one territorial office and its municipalities.
#'
#' @param cache `r lifecycle::badge("deprecated")` `cache` is no longer
#'   supported, this function always caches results.
#' @param update_cache Logical. Should the cached file be refreshed? Defaults to
#'   `FALSE`. When set to `TRUE`, it forces a new download.
#' @param to Character. Territorial office. Internally uses [base::grep()] for
#'   matching.
#'
#' @inheritParams catr_set_cache_dir
#' @return
#' A [tibble][tibble::tbl_df] with the information requested with the following
#' fields:
#' - `territorial_office`: Territorial office, corresponding to each province
#'   of Spain except the Basque Country and Navarre.
#' - `url`: ATOM URL for the corresponding territorial office.
#' - `munic`: Name of the municipality.
#' - `date`: Reference date of the data. The information from this service is
#'   updated twice a year.
#'
#' @source
#' <https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/ES.SDGC.AD.atom.xml>
#'
#' @family INSPIRE
#' @family ATOM
#' @family addresses
#' @family databases
#' @rdname catr_atom_get_address_db
#'
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' \donttest{
#' catr_atom_get_address_db_all()
#' }
catr_atom_get_address_db_all <- function(
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(cache, "CatastRo::catr_atom_get_address_db_all(cache)")

  api_entry <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )

  catr_atom_read_db_all(
    api_entry = api_entry,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
#' @rdname catr_atom_get_address_db
#' @export
catr_atom_get_address_db_to <- function(
  to,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(cache, "CatastRo::catr_atom_get_address_db_to(cache)")

  catr_atom_read_db_to(
    to = to,
    all_fn = catr_atom_get_address_db_all,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
