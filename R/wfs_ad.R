#' WFS INSPIRE: Download Addresses
#'
#' @description
#' Get the spatial data of addresses The WFS Service allows to perform
#' several types of queries:
#' - By bounding box: Implemented on `catr_wfs_ad_bbox()`. Extract objects
#'   included on the bounding box provided. See **Details**.
#'
#' @inheritParams catr_wfs_bu_bbox
#'
#' @seealso [sf::st_bbox()]
#' @family INSPIRE
#' @family WFS
#' @family addresses
#' @family spatial
#'
#' @return A `sf` object.
#'
#' @references
#' [API Documentation](https://www.catastro.minhap.es/webinspire/documentos/inspire-ad-WFS.pdf)
#'
#' [INSPIRE Services for Cadastral Cartography](https://www.catastro.minhap.es/webinspire/index.html)
#'
#' @details
#'
#' When `bbox` is a numeric vector, make sure that the `srs` matches the
#' coordinate values. Additionally, when the `srs` correspond to a geographic
#' reference system (4326, 4258), the function queries the bounding box on
#' [EPSG:3857](https://epsg.io/3857) - Web Mercator, to overcome
#' a potential bug on the API side. The result is provided always in the SRS
#' provided in `srs`.
#'
#' When `bbox` is a `sf` object, the value `srs` is ignored. The query is
#' performed using [EPSG:3857](https://epsg.io/3857) (Web Mercator) and the
#' spatial object is projected back to the SRS of the initial object.
#'
#' # API Limits
#' The API service is limited to a bounding box of 4km2 and a maximum of 5.000
#' elements.
#'
#' @rdname catr_wfs_ad
#' @export
catr_wfs_ad_bbox <- function(bbox, srs, verbose = FALSE) {
  bbox_res <- wfs_bbox(bbox, srs)

  res <- wfs_api_query(
    entry = "wfsAD.aspx?",
    verbose = verbose,
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    typenames = "AD.ADDRESS",
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
#' - By street code: Implemented on `catr_wfs_ad_codvia()`. Extract
#'   objects of specific addresses.
#'
#' @param codvia Cadastral street code.
#' @param del Cadastral office code.
#' @param mun Cadastral municipality code.
#'
#' @rdname catr_wfs_ad
#' @export
catr_wfs_ad_codvia <- function(codvia, del, mun, srs = NULL,
                               verbose = FALSE) {
  res <- wfs_api_query(
    entry = "wfsAD.aspx?",
    verbose = verbose,
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "getadbycodvia",
    # Stored query
    codvia = codvia,
    del = del,
    mun = mun,
    SRSNAME = srs
  )

  out <- wfs_results(res, verbose)

  return(out)
}

#' @description
#' - By cadastral reference: Implemented on `catr_wfs_ad_rc()`. Extract
#'   objects of specific cadastral references
#'
#' @inheritParams catr_wfs_bu_rc
#'
#' @rdname catr_wfs_ad
#' @export
catr_wfs_ad_rc <- function(rc, srs = NULL, verbose = FALSE) {
  res <- wfs_api_query(
    entry = "wfsAD.aspx?",
    verbose = verbose,
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetadByRefcat",
    # Stored query
    REFCAT = rc,
    SRSNAME = srs
  )

  out <- wfs_results(res, verbose)

  return(out)
}
#' @description
#' - By postal codes: Implemented on `catr_wfs_ad_postalcode()`. Extract
#'   objects of specific cadastral references
#'
#' Check the [API Docs](https://www.catastro.minhap.es/webinspire/documentos/inspire-ad-WFS.pdf).
#'
#' @param postalcode Postal code.
#'
#' @rdname catr_wfs_ad
#' @export
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
#' \donttest{
#' ad <- catr_wfs_ad_bbox(c(
#'   233673, 4015968, 233761, 4016008
#' ),
#' srs = 25830
#' )
#'
#' library(ggplot2)
#'
#' ggplot(ad) +
#'   geom_sf()
#' }
catr_wfs_ad_postalcode <- function(postalcode, srs = NULL, verbose = FALSE) {
  res <- wfs_api_query(
    entry = "wfsAD.aspx?",
    verbose = verbose,
    # WFS service
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "getadbypostalcode",
    # Stored query
    postalcode = postalcode,
    SRSNAME = srs
  )

  out <- wfs_results(res, verbose)

  return(out)
}
