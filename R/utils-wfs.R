#' Client tool for WFS INSPIRE services
#'
#' @description
#' Access WFS INSPIRE services. This function is used internally in WFS calls
#' and is exposed for users and developers accessing other cadastral or
#' INSPIRE resources.
#'
#' @details
#' This function is used internally in all the WFS calls. We expose it to make
#' it available to other users and/or developers for accessing other
#' cadastral or INSPIRE resources. See **Examples**.
#'
#' @param scheme Character string. Protocol to access the resource on the
#'   Internet.
#' @param hostname Character string. Host that holds the resource.
#' @param path Character string. Specific resource in the host to access.
#' @param query Named list. Names and values of arguments for the query.
#'
#' @inheritParams catr_set_cache_dir
#'
#' @return
#' Character string. Path of the resulting file in the [tempfile()] folder.
#'
#' @family INSPIRE
#' @family WFS
#' @rdname inspire_wfs_get
#'
#' @encoding UTF-8
#' @export
#' @examplesIf run_example()
#' # Access the Cadastre of Navarra
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
  # Validate query.
  if (!is.list(query)) {
    cli::cli_abort(
      "{.arg query} must be a list, not {.obj_type_friendly {query}}."
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
      "Removed {dif_nm} empty or unnamed element{?s} from {.arg query}."
    )
  }

  if (l_end == 0) {
    cli::cli_abort("{.arg query} must contain at least one named value.")
  }

  # Normalize SRS values.
  if ("srsname" %in% names(query)) {
    srs <- query$srsname
    query$srsname <- ifelse(grepl("^EPS", srs), srs, paste0("EPSG:", srs))
  }

  # Avoid httr2 because it masks some required values (`::`, `,`).
  q <- paste0(names(query), "=", query, collapse = "&")

  # Build URL.
  url <- paste0(trimws(hostname), "/", trimws(path), "?", q)

  # Clean double slashes and repeated question marks.
  url <- gsub("//", "/", url, fixed = TRUE)
  url <- gsub("??", "?", url, fixed = TRUE)

  url <- paste0(trimws(scheme), "://", url)
  # Create an ID from the MD5 checksum.
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

  # Check results.
  top20lines <- readLines(file_local, n = 20, warn = FALSE)

  if (!any(grepl("<Exception", top20lines))) {
    return(file_local)
  }

  # Handle non-GML responses.
  xml_file <- gsub("gml$", "xml", file_local)
  file.copy(file_local, xml_file)

  err <- xml2::read_xml(xml_file, encoding = "UTF-8")
  msg <- unlist(xml2::as_list(err)["ExceptionReport"], use.names = FALSE)

  cli::cli_alert_danger(c(
    "The WFS query returned an exception for {.url {url}}:\n",
    msg
  ))

  # Clean temporary files.
  unlink(list.files(
    tempdir(),
    recursive = TRUE,
    pattern = id,
    full.names = TRUE
  ))
  NULL
}

#' Validate an optional WFS SRS value
#'
#' @noRd
wfs_validate_srs <- function(srs) {
  if (!is.null(srs)) {
    wfs_get_bbox(c(1, 1, 1, 1), srs = srs)
  }

  invisible(srs)
}

#' Run a WFS stored query and read the resulting spatial file
#'
#' @noRd
wfs_read_stored_query <- function(path, query, srs = NULL, verbose = FALSE) {
  wfs_validate_srs(srs)
  query$SRSNAME <- srs

  file_local <- inspire_wfs_get(
    path = path,
    verbose = verbose,
    query = query
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  out <- read_geo_file_sf(file_local)
  unlink(file_local)
  out
}

#' Run a WFS bounding box query and transform results back to input SRS
#'
#' @noRd
wfs_read_bbox_query <- function(
  x,
  srs = NULL,
  path,
  typenames,
  limit_km2,
  verbose = FALSE
) {
  bbox_res <- wfs_get_bbox(
    x = x,
    srs = srs,
    srs_dest = 25830,
    limit_km2 = limit_km2
  )

  file_local <- inspire_wfs_get(
    path = path,
    verbose = verbose,
    query = list(
      service = "wfs",
      version = "2.0.0",
      request = "getfeature",
      typenames = typenames,
      bbox = paste0(bbox_res, collapse = ","),
      SRSNAME = 25830
    )
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  out <- read_geo_file_sf(file_local)
  unlink(file_local)

  if (is.null(srs)) {
    srs <- sf::st_crs(x)
  }
  sf::st_transform(out, srs)
}

#' Prepare the bbox of an object for WFS
#'
#' Results in 3857 since the WFS service fails in some other projections.
#' Also warn if beyond the WFS service limit.
#'
#' @param x `sf` object or double vector of length 4.
#' @param srs SRS of the bbox, not needed if `x` is an `sf` object.
#' @param srs_dest Destination SRS.
#' @param limit_km2 WFS service limit.
#'
#' @noRd
wfs_get_bbox <- function(x, srs = NULL, srs_dest = 3857, limit_km2 = Inf) {
  if (!(inherits(x, "sf") || inherits(x, "sfc"))) {
    validate_vector_with_srs(x, srs, 4L)

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

  # Check service limits using EPSG:3857.
  obj_for_area <- sf::st_transform(sfobj, 3857)
  area <- sf::st_area(obj_for_area)
  # Convert area to km2.
  area <- round(as.double(area) / 1000000, 1)

  if (area > limit_km2) {
    cli::cli_alert_warning(
      "WFS service limit is {limit_km2} km2, your query covers {area} km2."
    )
    cli::cli_alert_info(paste0(
      "The request may fail. Check the results or use a ",
      "smaller area in {.arg x}."
    ))
  }
  sf::st_bbox(sfobj)
}
