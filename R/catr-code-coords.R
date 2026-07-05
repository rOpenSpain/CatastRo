#' Get the cadastral municipality code from coordinates
#'
#' @description
#' Retrieve the municipality code associated with an [`sf`][sf::st_sf] object
#' or a coordinate pair.
#'
#' @param x Coordinate input. It can be:
#' - A pair of coordinates `c(x, y)`. In this case the `srs` of the
#'   coordinates must be provided.
#' - A [`sf`][sf::st_sf] object. If the object has several geometries, only
#'   the first geometry is used. This function extracts coordinates using
#'   `sf::st_centroid(x, of_largest_polygon = TRUE)`.
#'
#' @inheritParams catr_ovc_get_cod_munic
#' @inheritParams catr_ovc_get_cpmrc
#' @inheritParams catr_set_cache_dir
#' @inheritDotParams mapSpain::esp_get_munic_siane year resolution region munic
#' @inherit catr_ovc_get_cod_munic return details
#' @inherit catr_ovc_get_cpmrc seealso
#'
#' @seealso
#' - [mapSpain::esp_get_munic_siane()] retrieves municipality geometries.
#' - [catr_ovc_get_cod_munic()] retrieves municipality codes.
#' - [sf::st_centroid()] computes geometry centroids.
#'
#' @family search
#' @encoding UTF-8
#' @export
#' @examplesIf run_example()
#' \donttest{
#' # Use with coordinates
#' catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326)
#'
#' # Use with an sf object
#' prov <- mapSpain::esp_get_prov("Caceres")
#' catr_get_code_from_coords(prov)
#' }
catr_get_code_from_coords <- function(
  x,
  srs = NULL,
  verbose = FALSE,
  cache_dir = NULL,
  ...
) {
  x <- validate_non_empty_arg(x)

  if (!(inherits(x, "sf") || inherits(x, "sfc"))) {
    validate_vector_with_srs(x, srs, 2L)

    x <- sf::st_point(x)
    x <- sf::st_sfc(x)

    # Set CRS.
    sf::st_crs(x) <- sf::st_crs(srs)
  }

  x <- sf::st_geometry(x)

  if (length(x) > 1) {
    cli::cli_alert_info(
      "Using the first geometry, {.val {length(x)}} geometries were provided."
    )
  }

  x <- sf::st_transform(x[1], 3857)
  x <- sf::st_centroid(x, of_largest_polygon = TRUE)

  # Get municipality.
  cache_dir <- create_cache_dir(cache_dir)

  mun <- mapSpain::esp_get_munic_siane(
    cache_dir = cache_dir,
    verbose = verbose,
    moveCAN = FALSE,
    rawcols = FALSE,
    ...
  )
  if (is.null(mun)) {
    return(NULL)
  }
  mun <- sf::st_transform(mun, sf::st_crs(x))

  aa <- sf::st_intersects(mun, x, sparse = FALSE)

  if (!any(as.vector(aa))) {
    cli::cli_alert_warning("No municipality found for these coordinates.")
    return(NULL)
  }

  getcode <- mun[as.vector(aa), ]

  catr_ovc_get_cod_munic(getcode$cpro, cmun_ine = getcode$cmun)
}
