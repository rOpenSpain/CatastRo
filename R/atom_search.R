#' ATOM INSPIRE: Search for municipality codes
#'
#' @description
#' Search for a municipality (as a string, part of string or code) and get
#' the corresponding coding as per the Cadastre.
#'
#'
#' @family ATOM
#' @family search
#' @family databases
#'
#' @inheritParams catr_atom_get_parcels
#'
#' @param munic Municipality to extract, It can be a part of a string or the
#'   cadastral code.
#'
#' @return A \CRANpkg{tibble}.
#'
#' @export
#'
#' @examples
#' \donttest{
#' catr_atom_search_munic("Mad")
#' }
catr_atom_search_munic <- function(munic,
                                   to = NULL,
                                   cache = TRUE,
                                   update_cache = FALSE,
                                   cache_dir = NULL,
                                   verbose = FALSE) {
  all <- catr_atom_get_address_db_all(
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  if (all(!is.null(to), !is.na(to))) {
    linesto <- grep(to, all$territorial_office, ignore.case = TRUE)

    # Ignore if no result
    if (length(linesto) > 1) {
      all <- all[linesto, ]
    } else {
      if (verbose) {
        message(
          "Ignoring 'to' parameter. No results for ",
          to
        )
      }
    }
  }

  findmunic <- grep(munic, all$munic, ignore.case = TRUE)

  if (length(findmunic) == 0) {
    message(
      "No Municipality found for ", munic, " ", to,
      "."
    )
    return(invisible(NA))
  }


  # Get lines and cols
  res <- all[findmunic, c("territorial_office", "munic")]

  # Split to get code
  catrcode <- vapply(res$munic, function(x) {
    unlist(strsplit(x, "-"))[1]
  }, FUN.VALUE = character(1))


  res$catrcode <- catrcode

  return(res)
}
