#' ATOM INSPIRE: List address download URLs
#'
#' @description
#' Create a table of URLs provided by the Spanish Cadastre ATOM INSPIRE service
#' for downloading addresses.
#'
#' `r atom_db_details("address")`
#'
#' @param cache `r lifecycle::badge("deprecated")` This argument is no longer
#'   supported because results are always cached.
#' @param update_cache Logical. Whether to refresh the cached file. Defaults to
#'   `FALSE`.
#' @param to Character string. Territorial office to match using
#'   [base::grep()].
#'
#' @inheritParams catr_set_cache_dir
#' @return
#' A [tibble][dplyr::tbl_df] with the requested information in the following
#' columns:
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
#' @family addresses
#' @family atom_services
#' @rdname catr_atom_get_address_db
#'
#' @export
#' @encoding UTF-8
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
