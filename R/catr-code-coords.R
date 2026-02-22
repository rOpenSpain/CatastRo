#' Get the cadastral municipality code from coordinates
#'
#' @description
#'
#' This function takes as input a pair of coordinates of a [`sf`][sf::st_sf]
#' object and returns the corresponding municipality code for those coordinates.
#'
#' See also [mapSpain::esp_get_munic_siane()] and [catr_ovc_get_cod_munic()].
#'
#' @return A [tibble][tibble::tbl_df] with the format described in
#' [catr_ovc_get_cod_munic()].
#'
#' @param x It could be:
#'   - A pair of coordinates c(x,y).
#'   - A [`sf`][sf::st_sf] object. See **Details**.
#'
#' @inheritParams catr_wfs_get_buildings_bbox
#' @inheritParams catr_atom_get_buildings
#' @inheritDotParams mapSpain::esp_get_munic_siane year
#'
#' @export
#'
#' @family search
#' @seealso [mapSpain::esp_get_munic_siane()], [sf::st_centroid()].
#' @details
#'
#' When `x` is a numeric vector, make sure that the `srs` matches the
#' coordinate values.
#'
#' When `x` is a [`sf`][sf::st_sf] object, only the first value would
#' be used. The function would extract the coordinates using
#' `sf::st_centroid(x, of_largest_polygon = TRUE)`.
#'
#' @examplesIf run_example()
#' \donttest{
#' # Use with coords
#' catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326)
#'
#' # Use with sf
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
    if (length(x) != 2) {
      cli::cli_abort(
        "Length of {.arg x} should be {.val {2L}}, not {.val {length(x)}}."
      )
    }
    if (is.null(srs)) {
      cli::cli_abort(
        paste0(
          "You should provide also the {.arg srs} argument when x is ",
          "{.obj_type_friendly {x}}."
        )
      )
    }

    x <- sf::st_point(x)
    x <- sf::st_sfc(x)

    # Set crs
    sf::st_crs(x) <- sf::st_crs(srs)
  }

  x <- sf::st_geometry(x)

  if (length(x) > 1) {
    cli::cli_alert_info(
      "Selecting the first geometry (you provided {.val {length(x)}})."
    )
  }

  x <- sf::st_transform(x[1], 3857)
  x <- sf::st_centroid(x, of_largest_polygon = TRUE)

  # Get munic
  cache_dir <- create_cache_dir(cache_dir)

  mun <- mapSpain::esp_get_munic_siane(
    cache_dir = cache_dir,
    verbose = verbose,
    moveCAN = FALSE,
    ...
  )
  if (is.null(mun)) {
    return(NULL)
  }
  mun <- sf::st_transform(mun, sf::st_crs(x))

  aa <- sf::st_intersects(mun, x, sparse = FALSE)

  if (!any(as.vector(aa))) {
    cli::cli_alert_warning("Coordinates not found")
    return(NULL)
  }

  getcode <- mun[as.vector(aa), ]

  catr_ovc_get_cod_munic(getcode$cpro, cmun_ine = getcode$cmun)
}
