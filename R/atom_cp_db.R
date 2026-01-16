#' ATOM INSPIRE: Reference database for ATOM cadastral parcels
#'
#' @description
#'
#' Create a database containing the URLs provided in the INSPIRE ATOM service
#' of the Spanish Cadastre for extracting cadastral parcels.
#'
#' - `catr_atom_get_parcels_db_all()` provides a top-level table including
#'    information of all the territorial offices (except Basque Country and
#'    Navarre) listing the municipalities included on each office.
#' - `catr_atom_get_parcels_db_to()` provides a table for the specified
#'    territorial office including information for each of the municipalities
#'    of that office.
#'
#'
#' @source
#'
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(
#'    "<https://www.catastro.hacienda.gob.es/INSPIRE/CadastralParcels/",
#'      "ES.SDGC.CP.atom.xml>")
#'      )
#'
#' ```
#'
#' @family INSPIRE
#' @family ATOM
#' @family parcels
#' @family databases
#'
#' @inheritParams catr_atom_get_address_db_all
#' @inheritParams catr_set_cache_dir
#'
#' @param to Territorial office. It can be any type of string, the function
#'   would perform a search using [base::grep()].
#'
#' @rdname catr_atom_get_parcels_db
#' @export
#'
#' @return
#' A [tibble][tibble::tbl_df] with the information requested.
#' - `catr_atom_get_parcels_db_all()` includes the following fields:
#'   - `territorial_office`: Territorial office, corresponding to each province
#'      of Spain except the Basque Country and Navarre.
#'   - `url`: ATOM URL for the corresponding territorial office.
#'   - `munic`: Name of the municipality.
#'   - `date`: Reference date of the data. Note that **the information from
#'      this service is updated twice a year**.
#' - `catr_atom_get_parcels_db_to()` includes the following fields:
#'   - `munic`: Name of the municipality.
#'   - `url`: URL for downloading information of the corresponding municipality.
#'   - `date`: Reference date of the data. Note that **the information from
#'      this service is updated twice a year**.
#'
#' @examples
#' \donttest{
#' catr_atom_get_parcels_db_all()
#' }
catr_atom_get_parcels_db_all <- function(
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  api_entry <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "CadastralParcels/ES.SDGC.CP.atom.xml"
  )

  filename <- basename(api_entry)

  path <- catr_hlp_dwnload(
    api_entry,
    filename,
    cache_dir,
    verbose,
    update_cache,
    cache
  )

  tbl <- catr_read_atom(path, top = TRUE)
  names(tbl) <- c("territorial_office", "url", "munic", "date")

  tbl
}
#' @rdname catr_atom_get_parcels_db
#' @export
catr_atom_get_parcels_db_to <- function(
  to,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  all <- catr_atom_get_parcels_db_all()
  alldist <- unique(all[, c("territorial_office", "url")])

  # Escape parenthesis
  to <- gsub("\\(|\\)", "", to)
  allto <- gsub("\\(|\\)", "", alldist$territorial_office)

  findto <- grep(to, allto, ignore.case = TRUE)[1]

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
    api_entry,
    filename,
    cache_dir,
    verbose,
    update_cache,
    cache
  )

  tbl <- catr_read_atom(path, top = FALSE)

  names(tbl) <- c("munic", "url", "date")

  tbl
}
