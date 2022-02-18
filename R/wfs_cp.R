#' **WFS INSPIRE**: Download Cadastral Parcels
#'
#' @description
#' Get the spatial data of cadastral parcels and zones. The WFS Service allows
#' to perform several types of queries:
#' - By bounding box: Implemented on `catr_wfs_cp_bbox()`. Extract objects
#'   included on the bounding box provided. See **Details**.
#'
#' @inheritParams catr_atom_cp
#' @inheritParams catr_wfs_bu_bbox
#'
#' @seealso [sf::st_bbox()]
#' @family INSPIRE
#' @family WFS
#' @family parcels
#' @family spatial
#'
#' @return A `sf` object.
#'
#' @references
#' [API Documentation](https://www.catastro.minhap.es/webinspire/documentos/inspire-cp-WFS.pdf)
#'
#' [INSPIRE Services for Cadastral Cartography](https://www.catastro.minhap.es/webinspire/index.html)
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
#' When `x` is a `sf` object, the value `srs` is ignored. The query is
#' performed using [EPSG:3857](https://epsg.io/3857) (Web Mercator) and the
#' spatial object is projected back to the SRS of the initial object.
#'
#' # API Limits
#' The API service is limited to the following constrains:
#' - `"parcel`: Bounding box of 1km2 and a maximum of 500. elements.
#' - `"zoning"`: Bounding box of 25km2 and a maximum of 500 elements.
#'
#' @rdname catr_wfs_cp
#' @export
catr_wfs_cp_bbox <- function(x, what = "parcel", srs, verbose = FALSE) {
  # Sanity checks
  if (!(what %in% c("parcel", "zoning"))) {
    stop("'what' should be 'parcel' or 'zoning'")
  }


  # Switch to stored queries
  stored_query <- switch(what,
    "parcel" = "CP.CADASTRALPARCEL",
    "zoning" = "CP.CADASTRALZONING"
  )

  bbox_res <- wfs_bbox(x, srs)

  # Set limits
  lim <- switch(what,
    "parcel" = 1,
    "zoning" = 25
  )

  message_on_limit(bbox_res, 4)

  res <- wfs_api_query(
    entry = "wfsCP.aspx?",
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
#' - By zoning: Implemented on `catr_wfs_cp_zoning()`. Extract
#'   objects of a specific cadastral zone.
#'
#' @param cod_zona Cadastral zone code.
#'
#' @rdname catr_wfs_cp
#' @export
catr_wfs_cp_zoning <- function(cod_zona, srs = NULL, verbose = FALSE) {
  res <- wfs_api_query(
    entry = "wfsCP.aspx?",
    verbose = verbose,
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetZoning",
    # Stored query
    cod_zona = cod_zona,
    SRSNAME = srs
  )

  out <- wfs_results(res, verbose)

  return(out)
}
#' @description
#' - By cadastral parcel: Implemented on `catr_wfs_cp_parcel()`. Extract
#'   cadastral parcels of a specific cadastral reference.
#'
#' @rdname catr_wfs_cp
#' @export
catr_wfs_cp_parcel <- function(rc, srs = NULL, verbose = FALSE) {
  res <- wfs_api_query(
    entry = "wfsCP.aspx?",
    verbose = verbose,
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetParcel",
    # Stored query
    refcat = rc,
    SRSNAME = srs
  )

  out <- wfs_results(res, verbose)

  return(out)
}
#' @description
#' - Neighbor cadastral parcels: Implemented on `catr_wfs_cp_neigh_parcel()`.
#'   Extract neighbor cadastral parcels of a specific cadastral reference.
#'
#' @rdname catr_wfs_cp
#' @export
catr_wfs_cp_neigh_parcel <- function(rc, srs = NULL, verbose = FALSE) {
  res <- wfs_api_query(
    entry = "wfsCP.aspx?",
    verbose = verbose,
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetNeighbourParcel",
    # Stored query
    refcat = rc,
    SRSNAME = srs
  )

  out <- wfs_results(res, verbose)

  return(out)
}
#' @description
#' - Cadastral parcels by zoning: Implemented on `catr_wfs_cp_parcel_zoning()`.
#'   Extract cadastral parcels of a specific cadastral zone.
#'
#' Check the
#' [API Docs](https://www.catastro.minhap.es/webinspire/documentos/inspire-cp-WFS.pdf).
#'
#' @rdname catr_wfs_cp
#' @export
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
#' \donttest{
#' cp <- catr_wfs_cp_bbox(c(
#'   233673, 4015968, 233761, 4016008
#' ),
#' srs = 25830
#' )
#'
#' library(ggplot2)
#'
#' ggplot(cp) +
#'   geom_sf()
#' }
catr_wfs_cp_parcel_zoning <- function(cod_zona, srs = NULL, verbose = FALSE) {
  res <- wfs_api_query(
    entry = "wfsCP.aspx?",
    verbose = verbose,
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetParcelsByZoning",
    # Stored query
    cod_zona = cod_zona,
    SRSNAME = srs
  )
  out <- wfs_results(res, verbose)

  return(out)
}
