#' ATOM INSPIRE: Download all addresses of a municipality
#'
#' Retrieve the spatial data of all addresses belonging to a single municipality
#' using the INSPIRE ATOM service. The function also returns corresponding
#' street information in fields prefixed with `tfname_*`.
#'
#' @references
#'
#' ```{r child = "man/chunks/atompdf.Rmd"}
#' ```
#'
#' @family INSPIRE
#' @family ATOM
#' @family addresses
#' @family spatial
#' @param cache `r lifecycle::badge("deprecated")` `cache` is no longer
#'   supported; this function will always cache results.
#'
#' @export
#' @return A [`sf`][sf::st_sf] object.
#'
#' @inheritParams catr_atom_get_parcels
#' @examplesIf run_example()
#' \donttest{
#' s <- catr_atom_get_address("Melque",
#'   to = "Segovia"
#' )
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
  if (lifecycle::is_present(cache)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = "CatastRo::catr_atom_get_address(cache)",
      details = "Results are always cached."
    )
  }

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

  if (!is.null(to)) {
    linesto <- grep(to, all$territorial_office, ignore.case = TRUE)

    # Filter by territorial office if matches found
    if (length(linesto) > 1) {
      all <- all[linesto, ]
    } else {
      if (verbose) {
        cli::cli_alert_warning(
          paste0(
            "Ignoring {.arg to} argument. No results ",
            "found with pattern {.str {munic}} in {.str {to}}."
          )
        )
      }
    }
  }

  to_loc <- ensure_null(grep(munic, all$munic, ignore.case = TRUE))

  if (is.null(to_loc)) {
    cli::cli_alert_warning(
      "No municipality found with pattern {.str {munic}}."
    )
    cli::cli_alert_info(
      paste0(
        "Check available municipalities with ",
        "{.fn CatastRo::catr_atom_get_address_db_all}."
      )
    )
    return(NULL)
  }

  # Compute string distances for municipality matching
  with_d <- data.frame(
    munic = all$munic,
    territorial_office = all$territorial_office,
    dist = as.vector(adist(munic, all$munic))
  )
  with_d <- with_d[to_loc, ]
  tb <- with_d[order(with_d$dist), ]

  if (nrow(tb) > 1) {
    cli::cli_alert_info(
      "Found {nrow(tb)} municipalities with pattern {.str {munic}}."
    )

    cli::cli_alert_success("Selecting {.str {tb[1,]$munic}}.")
    cli::cli_alert_danger("Discarding:")
    bullets <- tb[-1, ]$munic
    bullets <- paste0("{.str ", bullets, "}")
    names(bullets) <- rep(" ", length(bullets))
    cli::cli_bullets(bullets)

    tb <- tb[1, ]
  }

  make_msg(
    "info",
    verbose,
    paste0("Extracting information for {.str ", tb$munic, "}.")
  )

  municurls <- catr_atom_get_address_db_to(
    as.character(tb$territorial_office),
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  # Extract municipality code from reference string
  ref <- unlist(strsplit(tb$munic, "-"))[1]

  # Prepare download URL for municipality data
  api_entry <- municurls[
    grepl(ref, municurls$munic, ignore.case = TRUE),
  ]$url

  api_entry <- URLencode(api_entry)

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

  # Rename and prepare for left join
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
