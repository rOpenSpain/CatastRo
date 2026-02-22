#' WFS INSPIRE: Download addresses
#'
#' @description
#' Get the spatial data of addresses. The WFS Service allows performing
#' several types of queries:
#' - By bounding box: Implemented on `catr_wfs_get_address_bbox()`.
#'   Extract objects included in the bounding box provided. See **Details**.
#'
#' @inheritParams catr_wfs_get_buildings_bbox
#'
#' @seealso [sf::st_bbox()]
#' @family INSPIRE
#' @family WFS
#' @family addresses
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
#' # Bounding box
#' When `x` is a numeric vector, make sure that the `srs` matches the
#' coordinate values. Additionally, the function queries the bounding box on
#' [EPSG:25830](https://epsg.io/25830) - ETRS89 / UTM zone 30N, to overcome
#' a potential bug on the API side.
#'
#' When `x` is a [`sf`][sf::st_sf] object, the value `srs` is ignored. In
#' this case, the bounding box of the [`sf`][sf::st_sf] object would be
#' used for the query (see [sf::st_bbox()]).
#'
#' The result is always provided in the SRS of the [`sf`][sf::st_sf] object
#' provided as input.
#'
#' # API Limits
#'
#' The API service is limited to a bounding box of 4km2 and a maximum of 5.000
#' elements.
#'
#' @rdname catr_wfs_get_address
#' @export
catr_wfs_get_address_bbox <- function(x, srs = NULL, verbose = FALSE) {
  # Sanity checks
  x <- validate_non_empty_arg(x)
  srs <- ensure_null(srs)

  bbox_res <- wfs_get_bbox(x = x, srs = srs, srs_dest = 25830, limit_km2 = 4)

  file_local <- inspire_wfs_get(
    path = "INSPIRE/wfsAD.aspx",
    verbose = verbose,
    query = list(
      # WFS service
      service = "wfs",
      version = "2.0.0",
      request = "getfeature",
      typenames = "AD.ADDRESS",
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

  out
}
#' @description
#' - By street code: Implemented on `catr_wfs_get_address_codvia()`. Extract
#'   objects of specific addresses.
#'
#' @param codvia Cadastral street code.
#' @param del Cadastral office code.
#' @param mun Cadastral municipality code.
#'
#' @rdname catr_wfs_get_address
#' @export
catr_wfs_get_address_codvia <- function(
  codvia,
  del,
  mun,
  srs = NULL,
  verbose = FALSE
) {
  codvia <- validate_non_empty_arg(codvia)
  del <- validate_non_empty_arg(del)
  mun <- validate_non_empty_arg(mun)
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
    StoredQuerie_id = "getadbycodvia",
    # Stored query
    codvia = codvia,
    del = del,
    mun = mun
  )

  q$SRSNAME <- srs

  file_local <- inspire_wfs_get(
    path = "INSPIRE/wfsAD.aspx",
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
#' - By cadastral reference: Implemented on `catr_wfs_get_address_rc()`. Extract
#'   objects of specific cadastral references.
#'
#' @inheritParams catr_wfs_get_buildings_rc
#'
#' @rdname catr_wfs_get_address
#' @export
catr_wfs_get_address_rc <- function(rc, srs = NULL, verbose = FALSE) {
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
    StoredQuerie_id = "GetadByRefcat",
    # Stored query
    REFCAT = rc
  )

  q$SRSNAME <- srs

  file_local <- inspire_wfs_get(
    path = "INSPIRE/wfsAD.aspx",
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
#' - By postal codes: Implemented on `catr_wfs_get_address_postalcode()`.
#'   Extract objects of specific postal codes
#'
#' @param postalcode Postal code.
#'
#' @rdname catr_wfs_get_address
#' @export
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
#' \donttest{
#' ad <- catr_wfs_get_address_bbox(
#'   c(
#'     233673, 4015968, 233761, 4016008
#'   ),
#'   srs = 25830
#' )
#'
#' library(ggplot2)
#'
#' ggplot(ad) +
#'   geom_sf()
#' }
catr_wfs_get_address_postalcode <- function(
  postalcode,
  srs = NULL,
  verbose = FALSE
) {
  postalcode <- validate_non_empty_arg(postalcode)
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
    StoredQuerie_id = "getadbypostalcode",
    # Stored query
    postalcode = postalcode
  )

  q$SRSNAME <- srs

  file_local <- inspire_wfs_get(
    path = "INSPIRE/wfsAD.aspx",
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
