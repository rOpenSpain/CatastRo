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
#'
#' @export
#' @return A [`sf`][sf::st_sf] object.
#'
#' @inheritParams catr_atom_get_parcels
#' @examples
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
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
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
        message("Ignoring 'to' parameter. No results for ", to)
      }
    }
  }

  findmunic <- grep(munic, all$munic, ignore.case = TRUE)[1]

  if (is.na(findmunic)) {
    message(
      "No Municipality found for ",
      munic,
      " ",
      to,
      ". Check available municipalities with catr_atom_get_address_db_all()"
    )
    return(invisible(NA))
  }
  m <- all[findmunic, ]

  if (verbose) {
    message(
      "Selecting ",
      m$munic,
      ", ",
      m$territorial_office
    )
  }

  municurls <- catr_atom_get_address_db_to(
    as.character(m$territorial_office),
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  # Get munic code from reference
  ref <- unlist(strsplit(m$munic, "-"))[1]

  # Download from url
  api_entry <- municurls[
    grepl(ref, municurls$munic, ignore.case = TRUE),
  ]$url

  filename <- basename(api_entry)

  path <- catr_hlp_dwnload(
    api_entry,
    filename,
    cache_dir,
    verbose,
    update_cache,
    cache
  )

  # To a new directory
  # Get cached dir
  cache_dir <- catr_hlp_cachedir(cache_dir)
  exdir <- file.path(
    cache_dir,
    gsub(".zip$", "", filename)
  )

  if (!dir.exists(exdir)) {
    dir.create(exdir, recursive = TRUE)
  }
  unzip(path, exdir = exdir, junkpaths = TRUE, overwrite = TRUE)

  # Guess what to read
  files <- list.files(exdir, full.names = TRUE, pattern = ".gml$")[1]

  sfobj <- st_read_layers_encoding(files, verbose)

  # See if we can add street names
  whatlay <- sf::st_layers(files)
  if ("ThoroughfareName" %in% whatlay$name) {
    if (verbose) {
      message("Adding ThoroughfareName to Address")
    }

    str_names <- st_read_layers_encoding(
      files,
      verbose = FALSE,
      layer = "ThoroughfareName"
    )

    # Rename and prepare for left join
    names(str_names) <- paste0("tfname_", names(str_names))

    sfobj$gml_id

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
  }

  sfobj
}
