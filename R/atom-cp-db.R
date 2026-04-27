#' ATOM INSPIRE: Reference database for ATOM cadastral parcels
#'
#' @description
#' Create a database containing the URLs provided in the INSPIRE ATOM
#' service of the Spanish Cadastre for extracting cadastral parcels.
#'  - `catr_atom_get_parcels_db_all()` provides a top-level table
#'    including information on all the territorial offices (except the
#'    Basque Country and Navarre) listing the municipalities included in
#'    each office.
#'  - `catr_atom_get_parcels_db_to()` provides a table for the specified
#'    territorial office including information for each of the
#'    municipalities of that office.
#'
#' @encoding UTF-8
#' @family INSPIRE
#' @family ATOM
#' @family parcels
#' @family databases
#' @inheritParams catr_atom_get_address_db_all
#' @inherit catr_atom_get_address_db_all return
#' @export
#'
#' @rdname catr_atom_get_parcels_db
#'
#' @source
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(
#'    "<https://www.catastro.hacienda.gob.es/INSPIRE/CadastralParcels/",
#'      "ES.SDGC.CP.atom.xml>")
#'      )
#' ```
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
  if (lifecycle::is_present(cache)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "CatastRo::catr_atom_get_parcels_db_all(cache)",
      details = "Results are always cached."
    )
  }

  api_entry <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/",
    "CadastralParcels/ES.SDGC.CP.atom.xml"
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
#' @rdname catr_atom_get_parcels_db
#' @export
catr_atom_get_parcels_db_to <- function(
  to,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  if (lifecycle::is_present(cache)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "CatastRo::catr_atom_get_parcels_db_to(cache)",
      details = "Results are always cached."
    )
  }

  all <- catr_atom_get_parcels_db_all(cache_dir = cache_dir)

  if (is.null(all)) {
    return(NULL)
  }

  alldist <- unique(all[, c("territorial_office", "url")])

  # Escape parentheses in territorial office names for matching
  to <- gsub("\\(|\\)", "", to)
  allto <- gsub("\\(|\\)", "", alldist$territorial_office)

  to_loc <- ensure_null(grep(to, allto, ignore.case = TRUE))
  if (is.null(to_loc)) {
    cli::cli_alert_warning(
      "No territorial office found with pattern {.str {to}}."
    )
    return(NULL)
  }

  # Compute string distances for territorial office matching
  with_d <- data.frame(
    to = alldist$territorial_office,
    dist = as.vector(adist(to, alldist$territorial_office))
  )
  with_d <- with_d[to_loc, ]
  with_d <- with_d[order(with_d$dist), ]

  tb <- with_d$to

  if (length(tb) > 1) {
    cli::cli_alert_info(
      "Found {length(tb)} territorial offices with pattern {.str {to}}."
    )

    cli::cli_alert_success("Selecting {.str {tb[1]}}.")
    cli::cli_alert_danger("Discarding:")
    bullets <- tb[-1]
    bullets <- paste0("{.str ", bullets, "}")
    names(bullets) <- rep(" ", length(bullets))
    cli::cli_bullets(bullets)

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

  if (is.null(file_local)) {
    return(NULL)
  }

  tbl <- catr_read_atom(file_local, top = FALSE)

  names(tbl) <- c("munic", "url", "date")

  tbl
}
