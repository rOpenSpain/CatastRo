#' WFS INSPIRE: Download buildings
#'
#' @description
#' Get the spatial data of buildings. The WFS Service allows to perform
#' two types of queries:
#' - By bounding box: Implemented on `catr_wfs_get_buildings_bbox()`.
#'   Extract objects included on the bounding box provided. See **Details**.
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
#' coordinate values. Additionally, when the `srs` correspond to a geographic
#' reference system (4326, 4258), the function queries the bounding box on
#' [EPSG:3857](https://epsg.io/3857) - Web Mercator, to overcome
#' a potential bug on the API side. The result is provided always in the SRS
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
catr_wfs_get_buildings_bbox <- function(x, what = "building", srs,
                                        verbose = FALSE) {
  # Sanity checks
  if (!(what %in% c("building", "buildingpart", "other"))) {
    stop("'what' should be 'building', 'buildingpart', 'other'")
  }

  # Switch to stored queries
  stored_query <- switch(what,
    "building" = "BU.BUILDING",
    "buildingpart" = "BU.BUILDINGPART",
    "other" = "BU.OTHERCONSTRUCTION"
  )


  bbox_res <- wfs_bbox(x, srs)

  message_on_limit(bbox_res, 4)


  res <- wfs_api_query(
    entry = "wfsBU.aspx?",
    verbose = verbose,
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    typenames = stored_query,
    # Stored query
    bbox = bbox_res$bbox,
    SRSNAME = bbox_res$incrs
  )

  out <- wfs_results(res, verbose)

  if (!is.null(out)) {
    # Transform back to the desired srs
    out <- sf::st_transform(out, bbox_res$outcrs)
  }
  return(out)
}

#' @description
#' - By cadastral reference: Implemented on `catr_wfs_get_buildings_rc()`.
#'   Extract objects of specific cadastral references.
#'
#'
#' @param rc The cadastral reference to be extracted.
#'
#' @rdname catr_wfs_get_buildings
#' @export
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
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
catr_wfs_get_buildings_rc <- function(rc, what = "building",
                                      srs = NULL, verbose = FALSE) {
  # Sanity checks
  if (!(what %in% c("building", "buildingpart", "other"))) {
    stop("'what' should be 'building', 'buildingpart', 'other'")
  }

  # Switch to stored queries
  stored_query <- switch(what,
    "building" = "GetBuildingByParcel",
    "buildingpart" = "GetBuildingPartByParcel",
    "other" = "GetOtherBuildingByParcel"
  )


  res <- wfs_api_query(
    entry = "wfsBU.aspx?",
    verbose = verbose,
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = stored_query,
    # Stored query
    REFCAT = rc,
    SRSNAME = srs
  )

  out <- wfs_results(res, verbose)
  return(out)
}
