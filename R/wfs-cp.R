#' WFS INSPIRE: download cadastral parcels
#'
#' @description
#' Retrieve spatial cadastral parcel and zoning data through several types of
#' WFS queries:
#'
#' - By bounding box: `catr_wfs_get_parcels_bbox()` extracts objects included
#'   in the provided bounding box. See **Bounding box**.
#'
#' @inheritParams catr_wfs_get_address_bbox
#' @inheritParams catr_atom_get_parcels
#' @inherit catr_wfs_get_address_bbox return references
#' @inheritSection catr_wfs_get_address_bbox Bounding box
#'
#' @section API limits:
#' The API service is limited to the following constraints:
#'
#' - `"parcel"`: Bounding box of 1 km2 and a maximum of 5,000 elements.
#' - `"zoning"`: Bounding box of 25 km2 and a maximum of 5,000 elements.
#'
#' @family wfs
#' @family parcels
#' @rdname catr_wfs_get_parcels
#'
#' @encoding UTF-8
#' @export
#'
catr_wfs_get_parcels_bbox <- function(
  x,
  what = c("parcel", "zoning"),
  srs = NULL,
  verbose = FALSE
) {
  # Validate arguments.
  x <- validate_non_empty_arg(x)
  srs <- ensure_null(srs)
  what <- match_arg_pretty(what)

  # Switch to stored queries.
  stored_query <- switch(what,
    "parcel" = "CP.CADASTRALPARCEL",
    "zoning" = "CP.CADASTRALZONING"
  )

  limit <- switch(what,
    "parcel" = 1,
    "zoning" = 25
  )

  wfs_read_bbox_query(
    x = x,
    srs = srs,
    path = "INSPIRE/wfsCP.aspx",
    typenames = stored_query,
    limit_km2 = limit,
    verbose = verbose
  )
}
#' @description
#' - By zoning: `catr_wfs_get_parcels_zoning()` extracts objects for a specific
#'   cadastral zone.
#'
#' @param cod_zona Cadastral zone code.
#'
#' @rdname catr_wfs_get_parcels
#' @export
catr_wfs_get_parcels_zoning <- function(cod_zona, srs = NULL, verbose = FALSE) {
  # Validate arguments.
  cod_zona <- validate_non_empty_arg(cod_zona)
  srs <- ensure_null(srs)

  q <- list(
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetZoning",
    cod_zona = cod_zona
  )

  wfs_read_stored_query(
    path = "INSPIRE/wfsCP.aspx",
    query = q,
    srs = srs,
    verbose = verbose
  )
}
#' @description
#' - By cadastral parcel: `catr_wfs_get_parcels_parcel()` extracts cadastral
#'   parcels for a specific cadastral reference.
#'
#' @rdname catr_wfs_get_parcels
#' @export
catr_wfs_get_parcels_parcel <- function(rc, srs = NULL, verbose = FALSE) {
  # Validate arguments.
  rc <- validate_non_empty_arg(rc)
  srs <- ensure_null(srs)

  q <- list(
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetParcel",
    refcat = rc
  )

  wfs_read_stored_query(
    path = "INSPIRE/wfsCP.aspx",
    query = q,
    srs = srs,
    verbose = verbose
  )
}
#' @description
#' - Neighbor cadastral parcels: `catr_wfs_get_parcels_neigh_parcel()`
#'   extracts neighbor cadastral parcels for a specific cadastral reference.
#'
#' @rdname catr_wfs_get_parcels
#' @export
catr_wfs_get_parcels_neigh_parcel <- function(rc, srs = NULL, verbose = FALSE) {
  # Validate arguments.
  rc <- validate_non_empty_arg(rc)
  srs <- ensure_null(srs)

  q <- list(
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetNeighbourParcel",
    refcat = rc
  )

  wfs_read_stored_query(
    path = "INSPIRE/wfsCP.aspx",
    query = q,
    srs = srs,
    verbose = verbose
  )
}
#' @description
#' - Cadastral parcels by zoning: `catr_wfs_get_parcels_parcel_zoning()`
#'   extracts cadastral parcels for a specific cadastral zone.
#'
#' @rdname catr_wfs_get_parcels
#' @export
#' @examplesIf run_example()
#' \donttest{
#' cp <- catr_wfs_get_parcels_bbox(
#'   c(
#'     233673, 4015968, 233761, 4016008
#'   ),
#'   srs = 25830
#' )
#'
#' library(ggplot2)
#'
#' ggplot(cp) +
#'   geom_sf()
#' }
catr_wfs_get_parcels_parcel_zoning <- function(
  cod_zona,
  srs = NULL,
  verbose = FALSE
) {
  # Validate arguments.
  cod_zona <- validate_non_empty_arg(cod_zona)
  srs <- ensure_null(srs)

  q <- list(
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetParcelsByZoning",
    cod_zona = cod_zona
  )

  wfs_read_stored_query(
    path = "INSPIRE/wfsCP.aspx",
    query = q,
    srs = srs,
    verbose = verbose
  )
}
