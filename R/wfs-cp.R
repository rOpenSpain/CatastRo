#' WFS INSPIRE: Download cadastral parcels
#'
#' @description
#' Get the spatial data of cadastral parcels and zones. The WFS Service allows
#' to perform several types of queries:
#' - By bounding box: Implemented on `catr_wfs_get_parcels_bbox()`. Extract
#'   objects included in the bounding box provided. See **Details**.
#'
#' @inheritParams catr_atom_get_parcels
#' @inheritParams catr_wfs_get_buildings_bbox
#'
#' @seealso [sf::st_bbox()]
#' @family INSPIRE
#' @family WFS
#' @family parcels
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
#' When `x` is a [`sf`][sf::st_sf] object, the value `srs` is ignored. The
#' query is performed using [EPSG:3857](https://epsg.io/3857) (Web Mercator)
#' and the spatial object is projected back to the SRS of the initial object.
#'
#' # API Limits
#' The API service is limited to the following constraints:
#' - `"parcel`: Bounding box of 1km2 and a maximum of 500 elements.
#' - `"zoning"`: Bounding box of 25km2 and a maximum of 500 elements.
#'
#' @rdname catr_wfs_get_parcels
#' @export
catr_wfs_get_parcels_bbox <- function(
  x,
  what = c("parcel", "zoning"),
  srs = NULL,
  verbose = FALSE
) {
  # Sanity checks
  # Sanity checks
  x <- validate_non_empty_arg(x)
  srs <- ensure_null(srs)
  what <- match_arg_pretty(what)

  # Switch to stored queries
  stored_query <- switch(what,
    "parcel" = "CP.CADASTRALPARCEL",
    "zoning" = "CP.CADASTRALZONING"
  )

  limit <- switch(what,
    "parcel" = 1,
    "zoning" = 25
  )

  bbox_res <- wfs_get_bbox(
    x = x,
    srs = srs,
    srs_dest = 25830,
    limit_km2 = limit
  )

  file_local <- inspire_wfs_get(
    path = "INSPIRE/wfsCP.aspx",
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
#' - By zoning: Implemented on `catr_wfs_get_parcels_zoning()`. Extract
#'   objects of a specific cadastral zone.
#'
#' @param cod_zona Cadastral zone code.
#'
#' @rdname catr_wfs_get_parcels
#' @export
catr_wfs_get_parcels_zoning <- function(cod_zona, srs = NULL, verbose = FALSE) {
  # Sanity checks
  cod_zona <- validate_non_empty_arg(cod_zona)
  srs <- ensure_null(srs)
  # Fake call to validate srs
  if (!is.null(srs)) {
    wfs_get_bbox(c(1, 1, 1, 1), srs = srs)
  }

  q <- list(
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetZoning",
    # Stored query
    cod_zona = cod_zona
  )

  q$SRSNAME <- srs

  file_local <- inspire_wfs_get(
    path = "INSPIRE/wfsCP.aspx",
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
#' @description
#' - By cadastral parcel: Implemented on `catr_wfs_get_parcels_parcel()`.
#'   Extract cadastral parcels of a specific cadastral reference.
#'
#' @rdname catr_wfs_get_parcels
#' @export
catr_wfs_get_parcels_parcel <- function(rc, srs = NULL, verbose = FALSE) {
  # Sanity checks
  rc <- validate_non_empty_arg(rc)
  srs <- ensure_null(srs)
  # Fake call to validate srs
  if (!is.null(srs)) {
    wfs_get_bbox(c(1, 1, 1, 1), srs = srs)
  }

  q <- list(
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetParcel",
    # Stored query
    refcat = rc
  )

  q$SRSNAME <- srs

  file_local <- inspire_wfs_get(
    path = "INSPIRE/wfsCP.aspx",
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
#' @description
#' - Neighbor cadastral parcels: Implemented on
#'   `catr_wfs_get_parcels_neigh_parcel()`. Extract neighbor cadastral parcels
#'   of a specific cadastral reference.
#'
#' @rdname catr_wfs_get_parcels
#' @export
catr_wfs_get_parcels_neigh_parcel <- function(rc, srs = NULL, verbose = FALSE) {
  # Sanity checks
  rc <- validate_non_empty_arg(rc)
  srs <- ensure_null(srs)
  # Fake call to validate srs
  if (!is.null(srs)) {
    wfs_get_bbox(c(1, 1, 1, 1), srs = srs)
  }

  q <- list(
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetNeighbourParcel",
    # Stored query
    refcat = rc
  )

  q$SRSNAME <- srs

  file_local <- inspire_wfs_get(
    path = "INSPIRE/wfsCP.aspx",
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
#' @description
#' - Cadastral parcels by zoning: Implemented on
#'  `catr_wfs_get_parcels_parcel_zoning()`. Extract cadastral parcels of a
#'  specific cadastral zone.
#'
#' @rdname catr_wfs_get_parcels
#' @export
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
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
  # Sanity checks
  cod_zona <- validate_non_empty_arg(cod_zona)
  srs <- ensure_null(srs)
  # Fake call to validate srs
  if (!is.null(srs)) {
    wfs_get_bbox(c(1, 1, 1, 1), srs = srs)
  }

  q <- list(
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetParcelsByZoning",
    # Stored query
    cod_zona = cod_zona
  )

  q$SRSNAME <- srs

  file_local <- inspire_wfs_get(
    path = "INSPIRE/wfsCP.aspx",
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
