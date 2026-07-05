#' Read a geospatial file into an `sf` object
#'
#' @param file_local Character string containing a local file path or URL.
#' @param hint Character string used to identify files in ZIP archives.
#' @param layer_hint Optional character string used to identify layer names.
#' @param ... Additional arguments passed to `sf::read_sf()`.
#'
#' @return An `sf` object containing the geospatial data.
#' @encoding UTF-8
#'
#' @noRd
read_geo_file_sf <- function(
  file_local,
  hint = basename(file_local),
  layer_hint = NULL,
  ...
) {
  # Warn if the file is large and no query is available.

  if (all(!grepl("^http", file_local), file.exists(file_local))) {
    fsize <- file.size(file_local)
    fsize_unit <- fsize
    class(fsize_unit) <- class(object.size("a"))
    thr <- 20 * (1024^2)
    if (fsize > thr) {
      fsize_unit <- paste0("(", format(fsize_unit, units = "auto"), ").")
      make_msg("warning", TRUE, "Reading a large file", fsize_unit)
      make_msg("generic", TRUE, "This may take a while.")
    }
  }

  # Create and read the 'vsizip' construct for shp.zip.
  if (grepl(".zip$", file_local, ignore.case = TRUE)) {
    shp_zip <- unzip(file_local, list = TRUE)
    shp_zip <- shp_zip$Name
    shp_zip <- shp_zip[grepl(hint, shp_zip)]
    shp_end <- shp_zip[1]

    # Read with vsizip.
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

#' Convert an `sf` object to UTF-8
#'
#' @param data_sf An `sf` object to encode as UTF-8.
#'
#' @return An `sf` object encoded as UTF-8.
#'
#' @source Adapted from \CRANpkg{sf}.
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
  # End code adapted from sf.

  # Convert to UTF-8.
  names <- names(data_sf)

  if (inherits(data_sf, "sf")) {
    g <- sf::st_geometry(data_sf)

    nm <- "geometry"
    data_utf8 <- as.data.frame(
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

  # Regenerate with the correct encoding.
  data_sf <- sf::st_as_sf(data_utf8, g)

  # Restore the geometry column name.
  newnames <- names(data_sf)
  newnames[newnames == "g"] <- nm
  colnames(data_sf) <- newnames
  data_sf <- sf::st_set_geometry(data_sf, nm)

  # Normalize CRS definitions with the EPSG number.

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

  # Validate arguments.
  if (!(is.numeric(bbox) && length(bbox) == 4)) {
    cli::cli_abort(
      "{.arg bbox} must have length {.val {4L}}, not {.val {length(bbox)}}."
    )
  }

  srs <- ensure_null(srs)
  if (is.null(srs)) {
    cli::cli_abort("Provide a valid non-empty value for {.arg srs}.")
  }

  # Create a template for a spatial bounding box.
  template_sf <- sf::st_sfc(sf::st_point(c(0, 0)))
  template_bbox <- sf::st_bbox(template_sf)

  # Create the spatial object.
  bbox_new <- bbox
  class(bbox_new) <- class(template_bbox)

  bbox_new <- sf::st_as_sfc(bbox_new)
  bbox_new <- sf::st_set_crs(bbox_new, srs)

  bbox_new
}
