#' Client tool for WFS INSPIRE services
#'
#' @family INSPIRE
#' @family WFS
#'
#' @param scheme Identifies the protocol to be used to access the resource on
#'   the Internet.
#' @param hostname Identifies the host that holds the resource.
#' @param path Identifies the specific resource in the host that the web client
#'   wants to access.
#' @param query A named list with the name and value of the parameters to query.
#' @inheritParams catr_wfs_get_address_bbox
#'
#' @return
#' A character string with the path of the resulting file in the [tempfile()]
#' folder.
#'
#' @details
#' This function is used internally in all the WFS calls. We expose it to make
#' it available to another users and/or developers for accessing other
#' cadastral or INSPIRE resources. See **Examples**.
#'
#' @export
#' @rdname inspire_wfs_get
#' @examplesIf run_example()
#' # Accessing the Cadastre of Navarra
#' # Try also https://ropenspain.github.io/CatastRoNav/
#'
#' file_local <- inspire_wfs_get(
#'   hostname = "inspire.navarra.es",
#'   path = "services/BU/wfs",
#'   query = list(
#'     service = "WFS",
#'     request = "getfeature",
#'     typenames = "BU:Building",
#'     bbox = "609800,4740100,611000,4741300",
#'     SRSNAME = "EPSG:25830"
#'   )
#' )
#'
#' if (!is.null(file_local)) {
#'   pamp <- sf::read_sf(file_local)
#'
#'   library(ggplot2)
#'   ggplot(pamp) +
#'     geom_sf()
#' }
inspire_wfs_get <- function(
  scheme = "https",
  hostname = "ovc.catastro.meh.es",
  path = "INSPIRE/wfsCP.aspx",
  query = list(),
  verbose = FALSE
) {
  # Validate query
  if (!is.list(query)) {
    cli::cli_abort(
      "{.arg query} should be a list, not {.obj_type_friendly {query}}."
    )
  }

  l_init <- length(query)
  query <- lapply(query, ensure_null)
  query <- query[lengths(query) > 0]
  nm <- unlist(lapply(names(query), ensure_null))
  query <- query[nm]
  names(query) <- tolower(nm)
  l_end <- length(query)

  dif_nm <- l_init - l_end

  if (dif_nm > 0) {
    cli::cli_alert_warning(
      "Removing {dif_nm} empty and/or unnamed element{?/s} in {.arg query}."
    )
  }

  if (l_end == 0) {
    cli::cli_abort(
      "{.arg query} can't be {.obj_type_friendly {query}}."
    )
  }

  # SRS should be checked
  if ("srsname" %in% names(query)) {
    srs <- query$srsname
    query$srsname <- ifelse(grepl("^EPS", srs), srs, paste0("EPSG:", srs))
  }

  # We don't use httr2 since some needed values (::, ,) are masked
  q <- paste0(names(query), "=", query, collapse = "&")

  # Build url
  url <- paste0(trimws(hostname), "/", trimws(path), "?", q)

  # Clean double slashes and ?? just in case
  url <- gsub("//", "/", url, fixed = TRUE)
  url <- gsub("??", "?", url, fixed = TRUE)

  url <- paste0(trimws(scheme), "://", url)
  # Create id from md5sum
  tmpfile <- tempfile(fileext = "txt")
  writeLines(url, tmpfile)
  id <- unname(tools::md5sum(tmpfile))
  file_gml <- paste0(id, ".gml")
  unlink(tmpfile)

  file_local <- download_url(
    url,
    file_gml,
    cache_dir = tempdir(),
    subdir = "wfs_inspire_cache",
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  # Check results
  top20lines <- readLines(file_local, n = 20, warn = FALSE)

  if (!any(grepl("<Exception", top20lines))) {
    return(file_local)
  }

  # If not gml
  xml_file <- gsub("gml$", "xml", file_local)
  file.copy(file_local, xml_file)

  err <- xml2::read_xml(xml_file, encoding = "UTF-8")
  msg <- unlist(xml2::as_list(err)["ExceptionReport"], use.names = FALSE)

  cli::cli_alert_danger(
    c("The query {.url {url}} didn't provide results:\n", msg)
  )

  # Clean temp
  unlink(list.files(
    tempdir(),
    recursive = TRUE,
    pattern = id,
    full.names = TRUE
  ))
  NULL
}


#' Prepare the bbox of an object for WFS
#'
#' Results in 3857 since the Catastro API fails in some other projections.
#' Also warn if beyond the API limits.
#'
#' @param x sf or double vector of length 4.
#' @param srs SRS of the bbox, not needed if x is sf.
#' @param srs_dest Destination srs.
#' @param limit_km2 API limit
#'
#' @noRd
wfs_get_bbox <- function(x, srs = NULL, srs_dest = 3857, limit_km2 = Inf) {
  if (!(inherits(x, "sf") || inherits(x, "sfc"))) {
    if (length(x) != 4) {
      cli::cli_abort(
        "Length of {.arg x} should be {.val {4L}}, not {.val {length(x)}}."
      )
    }
    if (is.null(srs)) {
      cli::cli_abort(
        paste0(
          "You should provide also the {.arg srs} argument when x is ",
          "{.obj_type_friendly {x}}."
        )
      )
    }

    srs_db <- CatastRo::catr_srs_values
    valid <- srs_db[srs_db$wfs_service, ]$SRS
    srs <- as.numeric(match_arg_pretty(srs, as.character(valid)))

    sfobj <- x
    class(sfobj) <- "bbox"
    sfobj <- sf::st_as_sfc(sfobj)
    sfobj <- sf::st_set_crs(sfobj, srs)
  } else {
    sfobj <- sf::st_as_sfc(sf::st_bbox(x))
  }

  sfobj <- sf::st_transform(sfobj, srs_dest)

  # API limits (using 3857)
  obj_for_area <- sf::st_transform(sfobj, 3857)
  area <- sf::st_area(obj_for_area)
  # Dirty convert to km2
  area <- round(as.double(area) / 1000000, 1)

  if (area > limit_km2) {
    cli::cli_alert_warning(
      "API Endpoint Restriction: {limit_km2} km2. Your query is {area} km2."
    )
    cli::cli_alert_info(
      paste0(
        "Operation may fail, check the results or use a ",
        "smaller area on {.arg x}."
      )
    )
  }
  sf::st_bbox(sfobj)
}
