#' Read geospatial file into sf object with optional query
#'
#' @param file_local Local file path or URL to the geospatial file.
#' @param hint Hint for zipped files
#' @param ... Additional arguments passed to `sf::read_sf()`.
#'
#' @return An `sf` object containing the geospatial data.
#'
#' @noRd
read_geo_file_sf <- function(
  file_local,
  hint = basename(file_local),
  layer_hint = NULL,
  ...
) {
  # Warn if file size is huge and no query

  if (all(!grepl("^http", file_local), file.exists(file_local))) {
    fsize <- file.size(file_local)
    fsize_unit <- fsize
    class(fsize_unit) <- class(object.size("a"))
    thr <- 20 * (1024^2)
    if (fsize > thr) {
      fsize_unit <- paste0("(", format(fsize_unit, units = "auto"), ").")
      make_msg("warning", TRUE, "Reading large file", fsize_unit)
      make_msg("generic", TRUE, "It can take a while. Hold on!")
    }
  }

  # Create and read 'vsizip' construct for shp.zip
  if (grepl(".zip$", file_local, ignore.case = TRUE)) {
    shp_zip <- unzip(file_local, list = TRUE)
    shp_zip <- shp_zip$Name
    shp_zip <- shp_zip[grepl(hint, shp_zip)]
    shp_end <- shp_zip[1]

    # Read with vszip
    file_local <- file.path("/vsizip/", file_local, shp_end)
    file_local <- gsub("//", "/", file_local, fixed = TRUE)
  }

  layers <- sf::st_layers(file_local)
  if (!is.null(layer_hint)) {
    layers <- layers[grepl(layer_hint, layers$name, ignore.case = TRUE), ]
  }

  data_sf <- sf::read_sf(file_local, layer = layers$name[1], quiet = TRUE)

  data_sf <- sanitize_sf(data_sf)

  data_sf
}

#' Convert sf object to UTF-8
#'
#' Convert to UTF-8
#'
#' @param data_sf data_sf
#'
#' @return data_sf with UTF-8 encoding.
#'
#' @source Extracted from [`sf`][sf::st_sf] package.
#'
#' @noRd
sanitize_sf <- function(data_sf) {
  # From sf/read.R - https://github.com/r-spatial/sf/blob/master/R/read.R
  set_utf8 <- function(x) {
    n <- names(x)
    Encoding(n) <- "UTF-8"
    to_utf8 <- function(x) {
      if (is.character(x)) {
        Encoding(x) <- "UTF-8"
      }
      x
    }
    structure(lapply(x, to_utf8), names = n)
  }
  # end

  # To UTF-8
  names <- names(data_sf)

  if (inherits(data_sf, "sf")) {
    g <- sf::st_geometry(data_sf)

    nm <- "geometry"
    data_utf8 <-
      as.data.frame(
        set_utf8(sf::st_drop_geometry(data_sf)),
        stringsAsFactors = FALSE
      )
  } else {
    data_utf8 <- set_utf8(data_sf)
  }

  data_utf8 <- tibble::as_tibble(data_utf8)

  if (!inherits(data_sf, "sf")) {
    return(data_utf8)
  }

  # Regenerate with right encoding
  data_sf <- sf::st_as_sf(data_utf8, g)

  # Rename geometry to geometry
  newnames <- names(data_sf)
  newnames[newnames == "g"] <- nm
  colnames(data_sf) <- newnames
  data_sf <- sf::st_set_geometry(data_sf, nm)

  # Some CRS are not properly defined (i.e may have additionalm properties)
  # Normalize with the EPSG number

  epsg_num <- sf::st_crs(data_sf)$epsg
  if (!identical(sf::st_crs(data_sf), sf::st_crs(epsg_num))) {
    sf::st_crs(data_sf) <- sf::st_crs(epsg_num)
  }

  data_sf <- sf::st_make_valid(data_sf)

  data_sf
}


get_sf_from_bbox <- function(bbox, srs = NULL) {
  if (inherits(bbox, "sf") || inherits(bbox, "sfc")) {
    return(bbox)
  }

  # Sanity check
  if (!(is.numeric(bbox) && length(bbox) == 4)) {
    cli::cli_abort(
      "{.arg bbox} has length {.val {4L}}, not {.val {length(bbox)}}."
    )
  }

  srs <- ensure_null(srs)
  if (is.null(srs)) {
    cli::cli_abort(
      "Please provide a valid non-empty value for {.arg srs}."
    )
  }

  # Create template for a spatial bbox
  template_sf <- sf::st_sfc(sf::st_point(c(0, 0)))
  template_bbox <- sf::st_bbox(template_sf)

  # Create the spatial object
  bbox_new <- bbox
  class(bbox_new) <- class(template_bbox)

  bbox_new <- sf::st_as_sfc(bbox_new)
  bbox_new <- sf::st_set_crs(bbox_new, srs)

  bbox_new
}
