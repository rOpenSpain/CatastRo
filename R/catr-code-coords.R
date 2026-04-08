#' Get the cadastral municipality code from coordinates
#'
#' @description
#' This function takes as input a pair of coordinates of a [`sf`][sf::st_sf]
#' object and returns the corresponding municipality code for those coordinates
#' using [catr_ovc_get_cod_munic()].
#'
#' @encoding UTF-8
#' @family search
#' @inheritParams catr_ovc_get_cod_munic
#' @inheritParams catr_ovc_get_cpmrc
#' @inheritParams catr_set_cache_dir
#' @inheritDotParams mapSpain::esp_get_munic_siane year resolution region munic
#' @export
#' @inherit catr_ovc_get_cod_munic return details
#' @inherit catr_ovc_get_cpmrc seealso
#'
#' @seealso
#' [mapSpain::esp_get_munic_siane()], [catr_ovc_get_cod_munic()],
#' [sf::st_centroid()].
#'
#' @param x It may be:
#'   - A pair of coordinates `c(x,y)`. In this case the `srs` of the coordinates
#'     must be provided.
#'   - A [`sf`][sf::st_sf] object. If the object has several geometries, only
#'     the first geometry is used. The function extracts coordinates using
#'     `sf::st_centroid(x, of_largest_polygon = TRUE)`.
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
          "You should also provide the {.arg srs} argument when x is ",
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
    rawcols = FALSE,
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
