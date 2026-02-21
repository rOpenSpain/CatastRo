#' Prepare the bbox of an object for WFS
#'
#' Results in 3857 since the Catastro API fails in some other projections.
#' Also warn if beyond the API limits.
#'
#' @param x sf or double vector of length 4.
#' @param srs SRS of the bbox, not needed if x is sf
#' @param limit_km2 API limit
#'
#' @noRd
wfs_get_bbox <- function(x, srs = NULL, limit_km2 = 4) {
  if (!(inherits(x, "sf") || inherits(x, "sfc"))) {
    if (length(x) != 4) {
      cli::cli_abort(
        "Length of {.arg x} should be {.val {4L}}, not {.val {length(x)}}."
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

    sfobj <- x
    class(sfobj) <- "bbox"
    sfobj <- sf::st_as_sfc(sfobj)
    sfobj <- sf::st_set_crs(sfobj, srs)
  } else {
    sfobj <- x
  }

  # Issue with API: Does not work with all the CRS. For safety we use 3857
  sfobj <- sf::st_transform(sfobj, 3857)

  # API limits
  area <- sf::st_area(sfobj)
  # Dirty convert to km2
  area <- round(as.double(area) / 1000000, 1)

  if (area > limit_km2) {
    cli::cli_alert_warning(
      "API Endpoint Restriction: {limit_km2} km2. Your query is {area} km2."
    )
    cli::cli_alert_info(
      "Operation may fail, check the results or reduce the area of {.arg x}."
    )
  }
  sf::st_bbox(sfobj)
}
