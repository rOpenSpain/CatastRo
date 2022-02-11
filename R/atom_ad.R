#' Download all the Addresses of a Municipality
#'
#'
#' Get the spatial data of all the addresses belonging to a single
#' municipality using the INSPIRE ATOM service.
#'
#' @source <https://www.catastro.minhap.es/INSPIRE/CadastralParcels/ES.SDGC.CP.atom.xml>
#'
#' @seealso [INSPIRE Services for Cadastral Cartography](https://www.catastro.minhap.es/webinspire/index.html)
#'
#' @family INSPIRE
#' @family ATOM
#' @family addresses
#' @family spatial
#'
#' @export
#' @return A `sf` object.
#'
#' @inheritParams catr_atom_cp
#' @param munic Municipality to extract, It can be a part of a string or the
#'   cadastral code. See [catr_atom_ad_db_all()] for getting the cadastral
#'   codes.
#' @examples
#' \dontrun{
#' s <- catr_atom_ad("Melque",
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
catr_atom_ad <- function(munic,
                         to = NULL,
                         cache = TRUE,
                         update_cache = FALSE,
                         cache_dir = NULL,
                         verbose = FALSE) {
  all <- catr_atom_ad_db_all(
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
      ". Check available municipalities with catr_atom_ad_db_all()"
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

  municurls <- catr_atom_ad_db_to(as.character(m$territorial_office),
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
  files <- list.files(exdir, full.names = TRUE, pattern = ".gml$")[1]

  # Layer management
  layers <- sf::st_layers(files)
  df_layers <- data.frame(
    layer = layers$name,
    geomtype = unlist(layers$geomtype)
  )
  df_layers <- df_layers[!is.na(df_layers$geomtype), ]

  if (nrow(df_layers) == 0) {
    message("No spatial layers found.")
    return(invisible(NULL))
  }

  sfobj <- sf::st_read(files, quiet = !verbose, layer = df_layers$layer[1])

  return(sfobj)
}