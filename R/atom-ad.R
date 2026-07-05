#' ATOM INSPIRE: download all addresses of a municipality
#'
#' @description
#' Retrieve spatial data for all addresses in a municipality using the ATOM
#' INSPIRE service. The result also contains corresponding
#' street information in fields prefixed with `tfname_*`.
#'
#' @param munic Municipality name, partial name or cadastral code. Use
#'   [catr_atom_search_munic()] to find cadastral codes.
#' @param to Optional territorial office containing `munic`. Use this argument
#'   to narrow the search.
#'
#' @inheritParams catr_atom_get_address_db_all
#' @return An [`sf`][sf::st_sf] object. Returns `NULL` if the data cannot be
#'   retrieved.
#'
#' @references
#' ```{r, echo=FALSE, comment="", results="asis"}
#' paste0("[API documentation](https://www.catastro.hacienda.gob.es/",
#'        "webinspire/documentos/inspire-ATOM.pdf).") |>
#'   cat()
#'
#' cat("\n\n")
#' paste0("[INSPIRE services for cadastral cartography](https://www.catastro",
#'        ".hacienda.gob.es/webinspire/index.html).") |> cat()
#'
#' ```
#'
#' @family atom
#' @family addresses
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' \donttest{
#' s <- catr_atom_get_address("Melque", to = "Segovia")
#'
#' library(ggplot2)
#'
#' ggplot(s) +
#'   geom_sf(aes(color = specification)) +
#'   coord_sf(
#'     xlim = c(376200, 376850),
#'     ylim = c(4545000, 4546000)
#'   ) +
#'   labs(
#'     title = "Addresses",
#'     subtitle = "Melque de Cercos, Segovia"
#'   )
#' }
#'
catr_atom_get_address <- function(
  munic,
  to = NULL,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(cache, "CatastRo::catr_atom_get_address(cache)")

  munic <- validate_non_empty_arg(munic)
  to <- ensure_null(to)

  all <- catr_atom_get_address_db_all(
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  if (is.null(all)) {
    return(NULL)
  }

  tb <- catr_atom_select_munic(
    all = all,
    munic = munic,
    to = to,
    db_all_call = "catr_atom_get_address_db_all",
    verbose = verbose
  )

  if (is.null(tb)) {
    return(NULL)
  }

  municurls <- catr_atom_get_address_db_to(
    as.character(tb$territorial_office),
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  api_entry <- catr_atom_get_munic_url(municurls, tb$munic)

  file_local <- download_url(
    url = api_entry,
    cache_dir = cache_dir,
    subdir = "atom_ad",
    update_cache = update_cache,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  sfobj <- read_geo_file_sf(file_local, hint = "gml", layer_hint = "Address")
  str_names <- read_geo_file_sf(
    file_local,
    hint = "gml",
    layer_hint = "Thorough"
  )

  # Rename and prepare for left join.
  names(str_names) <- paste0("tfname_", names(str_names))

  sfobj$tfname_gml_id <- vapply(
    sfobj$gml_id,
    FUN = function(x) {
      ids <- paste0(
        unlist(strsplit(x, ".", fixed = TRUE))[seq(1, 6)],
        collapse = "."
      )
      ids <- gsub("AD", "TN", ids, fixed = TRUE)
      ids
    },
    FUN.VALUE = character(1),
    USE.NAMES = FALSE
  )

  sfobj <- dplyr::left_join(sfobj, str_names, by = "tfname_gml_id")

  sfobj
}
