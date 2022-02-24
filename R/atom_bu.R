#' ATOM INSPIRE: Download all the Buildings of a Municipality
#'
#'
#' Get the spatial data of all the buildings belonging to a single municipality
#' using the INSPIRE ATOM service.
#'
#' @references
#' [API Documentation](https://www.catastro.minhap.es/webinspire/documentos/inspire-ATOM.pdf)
#'
#' [INSPIRE Services for Cadastral Cartography](https://www.catastro.minhap.es/webinspire/index.html)
#'
#' @family INSPIRE
#' @family ATOM
#' @family buildings
#' @family spatial
#'
#' @export
#' @return A `sf` object.
#'
#' @inheritParams catr_atom_get_parcels
#' @param what Information to load. It could be `"building"` for buildings,
#'   `"buildingpart"` for parts of a building or `"other"` for others (
#'   swimming pools, etc.).
#' @examples
#' \donttest{
#' s <- catr_atom_get_buildings("Nava de la Asuncion",
#'   to = "Segovia",
#'   what = "building"
#' )
#'
#' library(ggplot2)
#' ggplot(s) +
#'   geom_sf() +
#'   coord_sf(
#'     xlim = c(374500, 375500),
#'     ylim = c(4556500, 4557500)
#'   ) +
#'   labs(
#'     title = "Buildings",
#'     subtitle = "Nava de la Asuncion, Segovia"
#'   )
#' }
#'
catr_atom_get_buildings <- function(munic,
                                    to = NULL,
                                    what = "building",
                                    cache = TRUE,
                                    update_cache = FALSE,
                                    cache_dir = NULL,
                                    verbose = FALSE) {

  # Sanity checks
  if (!(what %in% c("building", "buildingpart", "other"))) {
    stop("'what' should be 'building', 'buildingpart', 'other'")
  }

  # Transform
  what <- switch(what,
    "building" = "building.gml",
    "buildingpart" = "buildingpart.gml",
    "other" = "other"
  )

  all <- catr_atom_get_buildings_db_all(
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

  findmunic <- grep(munic, all$munic, ignore.case = TRUE)[1]

  if (is.na(findmunic)) {
    message(
      "No Municipality found for ", munic, " ", to,
      ". Check available municipalities with catr_atom_get_buildings_db_all()"
    )
    return(invisible(NA))
  }
  m <- all[findmunic, ]

  if (verbose) {
    message(
      "Selecting ",
      m$munic, ", ", m$territorial_office
    )
  }

  municurls <- catr_atom_get_buildings_db_to(as.character(m$territorial_office),
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  # Get munic code from reference
  ref <- unlist(strsplit(m$munic, "-"))[1]

  # Download from url
  api_entry <- municurls[grepl(ref, municurls$munic,
    ignore.case = TRUE
  ), ]$url

  filename <- basename(api_entry)


  path <- catr_hlp_dwnload(
    api_entry, filename, cache_dir,
    verbose, update_cache, cache
  )

  # To a new directory
  # Get cached dir
  cache_dir <- catr_hlp_cachedir(cache_dir)
  exdir <- file.path(
    cache_dir,
    gsub(".zip$", "", filename)
  )

  if (!dir.exists(exdir)) dir.create(exdir, recursive = TRUE)
  unzip(path, exdir = exdir, junkpaths = TRUE, overwrite = TRUE)


  # Guess what to read
  files <- list.files(exdir, full.names = TRUE, pattern = ".gml$")
  files <- files[grepl(what, files, ignore.case = TRUE)]
  sfobj <- st_read_layers_encoding(files, verbose)

  return(sfobj)
}
