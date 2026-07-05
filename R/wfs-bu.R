#' WFS INSPIRE: download buildings
#'
#' @description
#' Retrieve spatial building data through two types of WFS queries:
#'
#' - By bounding box: `catr_wfs_get_buildings_bbox()` extracts objects included
#'   in the provided bounding box. See **Bounding box**.
#'
#' @inheritParams catr_wfs_get_address_bbox
#' @inheritParams catr_atom_get_buildings
#' @inherit catr_wfs_get_address_bbox return references
#' @inheritSection catr_wfs_get_address_bbox API limits
#' @inheritSection catr_wfs_get_address_bbox Bounding box
#' @family wfs
#' @family buildings
#' @rdname catr_wfs_get_buildings
#'
#' @encoding UTF-8
#' @export
#'
catr_wfs_get_buildings_bbox <- function(
  x,
  what = c("building", "buildingpart", "other"),
  srs = NULL,
  verbose = FALSE
) {
  # Validate arguments.
  x <- validate_non_empty_arg(x)
  srs <- ensure_null(srs)
  what <- match_arg_pretty(what)

  # Switch to stored queries.
  stored_query <- switch(what,
    "building" = "BU.BUILDING",
    "buildingpart" = "BU.BUILDINGPART",
    "other" = "BU.OTHERCONSTRUCTION"
  )

  wfs_read_bbox_query(
    x = x,
    srs = srs,
    path = "INSPIRE/wfsBU.aspx",
    typenames = stored_query,
    limit_km2 = 4,
    verbose = verbose
  )
}

#' @description
#' - By cadastral reference: `catr_wfs_get_buildings_rc()` extracts objects for
#'   specific cadastral references.
#'
#' @rdname catr_wfs_get_buildings
#'
#' @export
#' @examplesIf run_example()
#' \donttest{
#' # Using a bbox
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
#' # Using a cadastral reference
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
  # Validate arguments.
  rc <- validate_non_empty_arg(rc)
  srs <- ensure_null(srs)
  what <- match_arg_pretty(what)

  # Switch to stored queries.
  stored_query <- switch(what,
    "building" = "GetBuildingByParcel",
    "buildingpart" = "GetBuildingPartByParcel",
    "other" = "GetOtherBuildingByParcel"
  )

  q <- list(
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = stored_query,
    REFCAT = rc
  )

  wfs_read_stored_query(
    path = "INSPIRE/wfsBU.aspx",
    query = q,
    srs = srs,
    verbose = verbose
  )
}
