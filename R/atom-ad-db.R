#' ATOM INSPIRE: Reference database for ATOM addresses
#'
#' @description
#'
#' Create a database containing the URLs provided in the INSPIRE ATOM service
#' of the Spanish Cadastre for extracting addresses.
#'
#' - `catr_atom_get_address_db_all()` provides a top-level table including
#'    information of all the territorial offices (except Basque Country and
#'    Navarre) listing the municipalities included on each office.
#' - `catr_atom_get_address_db_to()` provides a table for the specified
#'    territorial office including information for each of the municipalities
#'    of that office.
#'
#' @source
#' <https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/ES.SDGC.AD.atom.xml>
#'
#' @family INSPIRE
#' @family ATOM
#' @family addresses
#' @family databases
#'
#' @inheritParams catr_set_cache_dir
#'
#' @param cache logical. Whether to do caching. Default is `TRUE`. See
#'   **Caching strategies** section on [catr_set_cache_dir()].
#'
#' @param update_cache logical. Should the cached file be refreshed? Default is
#'   `FALSE`. When set to `TRUE` it would force a new download.
#'
#' @param to character. Territorial office. Internally uses [base::agrep()] for
#'   fuzzy matching.
#'
#' @rdname catr_atom_get_address_db
#' @export
#'
#' @return
#' A [tibble][tibble::tbl_df] with the information requested.
#'   * `catr_atom_get_address_db_all()` includes the following fields:
#'     * `territorial_office`: Territorial office, corresponding to each
#'          province of Spain except the Basque Country and Navarre.
#'     * `url`: ATOM URL for the corresponding territorial office.
#'     * `munic`: Name of the municipality.
#'     * `date`: Reference date of the data. Note that the information from
#'          this service is updated twice a year**.
#'   * `catr_atom_get_address_db_to()` includes the following fields:
#'     * `munic`: Name of the municipality.
#'     * `url`: URL for downloading information of the corresponding
#'          municipality.
#'     * `date`: Reference date of the data. Note that the information from
#'          this service is updated twice a year.
#'
#' @examples
#' \donttest{
#' catr_atom_get_address_db_all()
#' }
catr_atom_get_address_db_all <- function(
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  api_entry <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "Addresses/ES.SDGC.AD.atom.xml"
  )

  file_local <- download_url(
    url = api_entry,
    cache_dir = cache_dir,
    subdir = "databases",
    update_cache = update_cache,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  tbl <- catr_read_atom(file_local, top = TRUE)
  names(tbl) <- c("territorial_office", "url", "munic", "date")

  tbl
}
#' @rdname catr_atom_get_address_db
#' @export
catr_atom_get_address_db_to <- function(
  to,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  all <- catr_atom_get_address_db_all()
  alldist <- unique(all[, c("territorial_office", "url")])

  # Escape parenthesis
  to <- gsub("\\(|\\)", "", to)
  allto <- gsub("\\(|\\)", "", alldist$territorial_office)

  # Clean for fuzzy match
  clean_to <- trimws(gsub("territorial|office", "", allto, ignore.case = TRUE))

  to_loc <- ensure_null(agrep(to, clean_to, ignore.case = TRUE))
  if (is.null(to_loc)) {
    cli::cli_alert_warning(
      "No Territorial Office found with pattern {.str {to}}."
    )
    return(NULL)
  }

  tb <- allto[to_loc]

  if (length(tb) > 1) {
    cli::cli_alert_info(
      "Found {length(tb)} Territorial offices with pattern {.str {to}}."
    )

    cli::cli_alert_success("Selecting {.str {tb[1]}}.")
    cli::cli_alert_danger("Discarding {.str {tb[-1]}}.")
    tb <- tb[1]
  }

  make_msg(
    "info",
    verbose,
    paste0("Extracting information for {.str ", tb, "}.")
  )

  api_entry <- as.character(alldist[alldist$territorial_office == tb, "url"])

  file_local <- download_url(
    url = api_entry,
    cache_dir = cache_dir,
    subdir = "databases",
    update_cache = update_cache,
    verbose = verbose
  )

  # nocov start
  if (is.null(file_local)) {
    return(NULL)
  }
  # nocov end

  tbl <- catr_read_atom(file_local, top = FALSE)

  names(tbl) <- c("munic", "url", "date")

  tbl
}
