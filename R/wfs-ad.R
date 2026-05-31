#' WFS INSPIRE: download addresses
#'
#' @description
#' Get the spatial data of addresses. The WFS service allows performing
#' several types of queries:
#'
#' - By bounding box: `catr_wfs_get_address_bbox()` extracts objects included
#'   in the provided bounding box. See **Bounding box**.
#'
#' @param x See **Bounding box**. Can be one of:
#' - A numeric vector of length 4 with the coordinates that define
#'   the bounding box: `c(xmin, ymin, xmax, ymax)`.
#' - A `sf/sfc` object, as provided by the \CRANpkg{sf} package.
#' @param srs SRS/CRS to use in the query. To see allowed values, use
#'   [catr_srs_values], specifically the `wfs_service` column. See
#'   **Bounding box**.
#' @param rc The cadastral reference to be extracted.
#'
#' @inheritParams catr_set_cache_dir
#'
#' @return A [`sf`][sf::st_sf] object.
#'
#' @section API Limits:
#' The API service is limited to a bounding box of 4 km2 and a maximum of 5,000
#' elements.
#'
#' @section Bounding box:
#' When `x` is a numeric vector, make sure that the `srs` matches the
#' coordinate values. Additionally, the function queries the bounding box on
#' [EPSG:25830](https://epsg.io/25830) - ETRS89 / UTM zone 30N, to overcome
#' a potential bug on the API side.
#'
#' When `x` is a [`sf`][sf::st_sf] object, the value `srs` is ignored. In
#' this case, the bounding box of the [`sf`][sf::st_sf] object is
#' used for the query (see [sf::st_bbox()]).
#'
#' The result is always provided in the SRS of the [`sf`][sf::st_sf] object
#' provided as input.
#' @references
#' ```{r, echo=FALSE, comment="", results="asis"}
#' paste0("[API documentation](https://www.catastro.hacienda.gob.es/",
#'        "webinspire/documentos/inspire-ad-WFS.pdf).") |>
#'   cat()
#' cat("\n\n")
#' paste0("[INSPIRE services for cadastral cartography](https://www.",
#'        "catastro.hacienda.gob.es/webinspire/index.html).") |>
#'   cat()
#'
#' ```
#'
#' @family INSPIRE
#' @family WFS
#' @family addresses
#' @family spatial
#' @rdname catr_wfs_get_address
#' @encoding UTF-8
#' @export
#'
catr_wfs_get_address_bbox <- function(x, srs = NULL, verbose = FALSE) {
  # Validate arguments.
  x <- validate_non_empty_arg(x)
  srs <- ensure_null(srs)

  wfs_read_bbox_query(
    x = x,
    srs = srs,
    path = "INSPIRE/wfsAD.aspx",
    typenames = "AD.ADDRESS",
    limit_km2 = 4,
    verbose = verbose
  )
}
#' @description
#' - By street code: `catr_wfs_get_address_codvia()` extracts objects for
#'   specific addresses.
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

  q <- list(
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "getadbycodvia",
    codvia = codvia,
    del = del,
    mun = mun
  )

  wfs_read_stored_query(
    path = "INSPIRE/wfsAD.aspx",
    query = q,
    srs = srs,
    verbose = verbose
  )
}

#' @description
#' - By cadastral reference: `catr_wfs_get_address_rc()` extracts objects for
#'   specific cadastral references.
#'
#' @rdname catr_wfs_get_address
#' @export
catr_wfs_get_address_rc <- function(rc, srs = NULL, verbose = FALSE) {
  rc <- validate_non_empty_arg(rc)
  srs <- ensure_null(srs)

  q <- list(
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "GetadByRefcat",
    REFCAT = rc
  )

  wfs_read_stored_query(
    path = "INSPIRE/wfsAD.aspx",
    query = q,
    srs = srs,
    verbose = verbose
  )
}
#' @description
#' - By postal codes: `catr_wfs_get_address_postalcode()` extracts objects for
#'   specific postal codes.
#'
#' @param postalcode Postal code.
#'
#' @rdname catr_wfs_get_address
#' @export
#' @examplesIf run_example()
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

  q <- list(
    service = "wfs",
    version = "2.0.0",
    request = "getfeature",
    StoredQuerie_id = "getadbypostalcode",
    postalcode = postalcode
  )

  wfs_read_stored_query(
    path = "INSPIRE/wfsAD.aspx",
    query = q,
    srs = srs,
    verbose = verbose
  )
}
