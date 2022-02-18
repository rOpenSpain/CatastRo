#' **ATOM INSPIRE**: Reference Database for ATOM Addresses
#'
#' @description
#'
#'
#' Create a database containing the urls provided in the INSPIRE ATOM service
#' of the Spanish Cadastre for extracting Addresses.
#'
#' - `catr_atom_ad_db_all()` provides a top-level table including information
#'    of all the territorial offices (except Basque Country and Navarre) listing
#'    the municipalities included on each office.
#' - `catr_atom_ad_db_to()` provides a table for the specified territorial
#'    office including information for each of the municipalities of that
#'    office.
#'
#'
#' @source
#' <https://www.catastro.minhap.es/INSPIRE/CadastralParcels/ES.SDGC.CP.atom.xml>
#'
#'
#' @family INSPIRE
#' @family ATOM
#' @family addresses
#' @family databases
#'
#' @inheritParams catr_set_cache_dir
#'
#' @param cache A logical whether to do caching. Default is `TRUE`. See
#'   **About caching** section on [catr_set_cache_dir()].
#'
#' @param update_cache A logical whether to update cache. Default is `FALSE`.
#'  When set to `TRUE` it would force a fresh download of the source file.
#'
#' @rdname catr_atom_ad_db
#' @export
#'
#' @return
#' A tibble with the information requested.
#' - `catr_atom_ad_db_all()` provides a tibble with the following fields:
#'   - `territorial_office`: Territorial office, corresponding to each province
#'      of Spain expect Basque Country and Navarre.
#'   - `url`: ATOM url for the corresponding territorial office.
#'   - `munic`: Name of the municipality.
#'   - `date`: Reference date of the data. Note that **the information of
#'      this service is updated twice a year**.
#' - `catr_atom_ad_db_to()` provides a tibble with the following fields:
#'   - `munic`: Name of the municipality.
#'   - `url`: url for downloading information of the corresponding municipality.
#'   - `date`: Reference date of the data. Note that **the information of
#'      this service is updated twice a year**.
#'
#' @examples
#' \donttest{
#' catr_atom_ad_db_all()
#' }
catr_atom_ad_db_all <- function(cache = TRUE,
                                update_cache = FALSE,
                                cache_dir = NULL,
                                verbose = FALSE) {
  api_entry <- paste0(
    "https://www.catastro.minhafp.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )


  filename <- basename(api_entry)

  path <- catr_hlp_dwnload(
    api_entry, filename, cache_dir,
    verbose, update_cache, cache
  )


  tbl <- catr_read_atom(path, top = TRUE)
  names(tbl) <- c("territorial_office", "url", "munic", "date")

  return(tbl)
}
#' @rdname catr_atom_ad_db
#' @name catr_atom_ad_to
#' @export
#' @param to Territorial office. It can be any type of string, the function
#'  would perform a search using [base::grep()].
catr_atom_ad_db_to <- function(to,
                               cache = TRUE,
                               update_cache = FALSE,
                               cache_dir = NULL,
                               verbose = FALSE) {
  all <- catr_atom_ad_db_all()
  alldist <- unique(all[, c("territorial_office", "url")])

  findto <- grep(to, alldist$territorial_office, ignore.case = TRUE)[1]

  if (is.na(findto)) {
    message("No Territorial office found for ", to)
    return(invisible(NA))
  }

  tb <- alldist[findto, ]

  if (verbose) {
    message(
      "Extracting information for ",
      tb$territorial_office
    )
  }

  api_entry <- as.character(tb$url)
  filename <- basename(api_entry)
  path <- catr_hlp_dwnload(
    api_entry, filename, cache_dir,
    verbose, update_cache, cache
  )


  tbl <- catr_read_atom(path, top = FALSE)

  names(tbl) <- c("munic", "url", "date")

  return(tbl)
}
