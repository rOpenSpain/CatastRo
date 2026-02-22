#' WFS INSPIRE: Download buildings
#'
#' @description
#' Get the spatial data of buildings. The WFS Service allows performing
#' two types of queries:
#' - By bounding box: Implemented on `catr_wfs_get_buildings_bbox()`.
#'   Extract objects included in the bounding box provided. See **Details**.
#'
#' @inheritParams catr_atom_get_buildings
#' @param x See **Details**. It could be:
#'   - A numeric vector of length 4 with the coordinates that defines
#'     the bounding box: `c(xmin, ymin, xmax, ymax)`
#'   - A `sf/sfc` object, as provided by the \CRANpkg{sf} package.
#' @param srs SRS/CRS to use on the query. To check the admitted values check
#'   [catr_srs_values], specifically the `wfs_service` column. See **Details**.
#'
#' @seealso [sf::st_bbox()]
#' @family INSPIRE
#' @family WFS
#' @family buildings
#' @family spatial
#'
#' @return A [`sf`][sf::st_sf] object.
#'
#' @references
#'
#' ```{r child = "man/chunks/wfspdf.Rmd"}
#' ```
#'
#' @details
#'
#' When `x` is a numeric vector, make sure that the `srs` matches the
#' coordinate values. Additionally, when the `srs` corresponds to a geographic
#' reference system (4326, 4258), the function queries the bounding box on
#' [EPSG:3857](https://epsg.io/3857) - Web Mercator, to overcome
#' a potential bug on the API side. The result is always provided in the SRS
#' provided in `srs`.
#'
#' When `x` is a \CRANpkg{sf} object, the value `srs` is ignored. The query is
#' performed using [EPSG:3857](https://epsg.io/3857) (Web Mercator) and the
#' spatial object is projected back to the SRS of the initial object.
#'
#' # API Limits
#' The API service is limited to a bounding box of 4km2 and a maximum of 5.000
#' elements.
#'
#' @rdname catr_wfs_get_buildings
#' @export
catr_wfs_get_buildings_bbox <- function(
  x,
  what = c("building", "buildingpart", "other"),
  srs = NULL,
  verbose = FALSE
) {
  # Sanity checks
  x <- validate_non_empty_arg(x)
  srs <- ensure_null(srs)
  what <- match_arg_pretty(what)

  # Switch to stored queries
  stored_query <- switch(what,
    "building" = "BU.BUILDING",
    "buildingpart" = "BU.BUILDINGPART",
    "other" = "BU.OTHERCONSTRUCTION"
  )

  bbox_res <- wfs_get_bbox(x = x, srs = srs, srs_dest = 25830, limit_km2 = 4)

  file_local <- inspire_wfs_get(
    path = "INSPIRE/wfsBU.aspx",
    verbose = verbose,
    query = list(
      # WFS service
      service = "wfs",
      version = "2.0.0",
      request = "getfeature",
      typenames = stored_query,
      # Stored query
      bbox = paste0(bbox_res, collapse = ","),
      SRSNAME = 25830
    )
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  # Transform back to the desired srs
  out <- read_geo_file_sf(file_local)
  unlink(file_local)
  if (is.null(srs)) {
    srs <- sf::st_crs(x)
  }
  out <- sf::st_transform(out, srs)
}

#' @description
#' - By cadastral reference: Implemented on `catr_wfs_get_buildings_rc()`.
#'   Extract objects of specific cadastral references.
#'
#' @param rc The cadastral reference to be extracted.
#'
#' @rdname catr_wfs_get_buildings
#' @export
#' @examplesIf run_example()
#' \donttest{
#' # Using bbox
#' building <- catr_wfs_get_buildings_bbox(
#'   c(
#'     376550,
#'     4545424,
#'     376600,
#'     4545474
#'   ),
#'   srs = 25830
#' )
#' library(ggplot2)
#' ggplot(building) +
#'   geom_sf() +
#'   labs(title = "Search using bbox")
#'
#' # Using rc
#' rc <- catr_wfs_get_buildings_rc("6656601UL7465N")
#' library(ggplot2)
#' ggplot(rc) +
#'   geom_sf() +
#'   labs(title = "Search using rc")
#' }
catr_wfs_get_buildings_rc <- function(
  rc,
  what = c("building", "buildingpart", "other"),
  srs = NULL,
  verbose = FALSE
) {
  # Sanity checks
  rc <- validate_non_empty_arg(rc)
  srs <- ensure_null(srs)
  what <- match_arg_pretty(what)
  # Fake call to validate srs
  if (!is.null(srs)) {
    wfs_get_bbox(c(1, 1, 1, 1), srs = srs)
  }

  # Switch to stored queries
  stored_query <- switch(what,
    "building" = "GetBuildingByParcel",
    "buildingpart" = "GetBuildingPartByParcel",
    "other" = "GetOtherBuildingByParcel"
  )

  q <- list(
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = stored_query,
    # Stored query
    REFCAT = rc
  )
  q$SRSNAME <- srs

  file_local <- inspire_wfs_get(
    path = "INSPIRE/wfsBU.aspx",
    verbose = verbose,
    query = q
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  out <- read_geo_file_sf(file_local)
  unlink(file_local)
  out
}
