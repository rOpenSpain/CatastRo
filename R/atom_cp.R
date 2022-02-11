#' Download all the Cadastral Parcels of a Municipality
#'
#'
#' Get the spatial data of all the cadastral parcels belonging to a single
#' municipality using the INSPIRE ATOM service.
#'
#' @source <https://www.catastro.minhap.es/INSPIRE/CadastralParcels/ES.SDGC.CP.atom.xml>
#'
#' @seealso [INSPIRE Services for Cadastral Cartography](https://www.catastro.minhap.es/webinspire/index.html)
#' @family INSPIRE
#' @family ATOM
#' @family parcels
#' @family spatial
#'
#' @export
#' @return A `sf` object.
#'
#' @inheritParams catr_atom_cp_db_all
#' @param munic Municipality to extract, It can be a part of a string or the
#'   cadastral code. See [catr_atom_cp_db_all()] for getting the cadastral
#'   codes.
#' @param to Optional parameter for defining the Territorial Office to which
#'   `munic` belongs. This parameter is a helper for narrowing the search.
#' @param what Information to load. It could be `"parcel"` for cadastral parcels
#'   or `"zoning"` for cadastral zoning.
#' @examples
#' \dontrun{
#' s <- catr_atom_cp("Melque",
#'   to = "Segovia",
#'   what = "parcel"
#' )
#'
#' library(ggplot2)
#'
#' ggplot(s) +
#'   geom_sf() +
#'   labs(
#'     title = "Cadastral Zoning",
#'     subtitle = "Melque de Cercos, Segovia"
#'   )
#' }
#'
catr_atom_cp <- function(munic,
                         to = NULL,
                         what = "parcel",
                         cache = TRUE,
                         update_cache = FALSE,
                         cache_dir = NULL,
                         verbose = FALSE) {

  # Sanity checks
  if (!(what %in% c("parcel", "zoning"))) {
    stop("'what' should be 'parcel' or 'zoning'")
  }

  all <- catr_atom_cp_db_all(
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
      ". Check available municipalities with catr_atom_cp_db_all()"
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

  municurls <- catr_atom_cp_db_to(as.character(m$territorial_office),
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
  sfobj <- sf::st_read(files[1], quiet = !verbose)

  return(sfobj)
}
