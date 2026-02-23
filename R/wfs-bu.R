#' WFS INSPIRE: Download buildings
#'
#' @description
#' Get the spatial data of buildings. The WFS Service allows performing
#' two types of queries:
#' - By bounding box: Implemented on `catr_wfs_get_buildings_bbox()`.
#'   Extract objects included in the bounding box provided. See
#'   **Bounding box**.
#'
#' @encoding UTF-8
#' @family INSPIRE
#' @family WFS
#' @family buildings
#' @family spatial
#' @export
#'
#' @rdname catr_wfs_get_buildings
#'
#' @inheritParams catr_wfs_get_address_bbox
#' @inheritParams catr_atom_get_buildings
#' @inherit catr_wfs_get_address_bbox return references
#' @inheritSection catr_wfs_get_address_bbox API Limits
#' @inheritSection catr_wfs_get_address_bbox Bounding box
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
#' @rdname catr_wfs_get_buildings
#'
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
