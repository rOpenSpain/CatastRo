catr_wfs_get_buildingsild_url <- function(
host = "http://ovc.catastro.meh.es/INSPIRE/",
                                          entry,
                                          params) {
  # Clean empty params
  params <- params[lengths(params) != 0]

  # Adjust params
  q <- paste0(names(params), "=", params, collapse = "&")


  # Full url
  full_url <- paste0(host, entry, q)

  return(full_url)
}

catr_wfs_check <- function(path) {
  # Check if it is valid
  lines <- readLines(path, n = 20)

  if (any(grepl("<gml", lines))) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

#' Handle WFS queries
#'
#' Prepare a WFS query and returns a list with information of the result
#'
#' @param entry Entry point of the API
#' @param ... Query parameters
#' @param ... Wheter to display additional info on call
#'
#' @returns A list indicating the path to the tempfile, if it is a sf
#' object and in case of error a message to display
#'
#' @noRd
wfs_api_query <- function(entry, ..., 
verbose = TRUE) {
  arguments <- list(...)

  # Handle SRS. Is optional but if provided check
  srs <- arguments$SRSNAME

  if (!is.null(srs)) {
    # Sanity checks
    wfs_validate_srs(srs)
    arguments$SRSNAME <- paste0("EPSG::", srs)
  }

  # Prepare URL
  # Get URl
  api_entry <- catr_wfs_get_buildingsild_url(
    entry = entry,
    params = arguments
  )


  # Filename
  filename <- paste0(basename(tempfile()), ".gml")

  path <- catr_hlp_dwnload(
    api_entry, filename,
    cache_dir = tempdir(),
    verbose = verbose, update_cache = FALSE,
    cache = TRUE
  )

  # Check
  is_sf <- catr_wfs_check(path)

  # Prepare outlist

  outlist <- list(
    is_sf = is_sf,
    path = path
  )

  if (!is_sf) {
    m <- unlist(xml2::as_list(xml2::read_xml(path)))

    outlist$m <- m
  }
  return(outlist)
}
wfs_results <- function(res, verbose) {
  # Check result
  if (res$is_sf) {
    out <- st_read_layers_encoding(res$path, verbose)

    unlink(res$path, force = TRUE)
    return(out)
  } else {
    message("Malformed query: ", res$m)
    unlink(res$path, force = TRUE)
    return(invisible(NULL))
  }
}

wfs_validate_srs <- function(srs) {
  # Sanity checks
  valid_srs <- CatastRo::catr_srs_values
  valid_srs <- tibble::as_tibble(valid_srs)
  valid_srs <- valid_srs[valid_srs$wfs_service == TRUE, "SRS"]
  valid <- tibble::deframe(valid_srs)
  valid <- as.character(valid)

  if (!as.character(srs) %in% valid) {
    stop(
      "'srs' for WFS should be one of ",
      paste0("'", valid, "'", collapse = ", "),
      ".\n\nSee CatastRo::catr_srs_values",
      call. = FALSE
    )
  }
}

wfs_bbox <- function(bbox, srs) {
  result <- list()

  # Use bbox of a spatial object. The API fails on geografic coord ¿?
  if (inherits(bbox, "sf") || inherits(bbox, "sfc")) {
    # Convert to Mercator (opinionated)
    bbox_new <- sf::st_transform(bbox, 3857)

    # Get bbox values
    values <- as.double(sf::st_bbox(bbox_new))

    result$bbox <- paste0(values, collapse = ",")
    result$outcrs <- sf::st_crs(bbox)
    result$incrs <- 3857
  } else {
    # Convert to sf
    # Validate srs
    wfs_validate_srs(srs)

    result$incrs <- srs
    bbox_new <- get_sf_from_bbox(bbox, srs)
    result$outcrs <- sf::st_crs(bbox_new)

    # On lonlat, project. The API does not work ?¿
    # Mercator (opinionated)
    if (sf::st_is_longlat(bbox_new)) {
      bbox_new <- sf::st_transform(bbox_new, 3857)
      result$incrs <- 3857
    }

    # Get bbox values
    values <- as.double(sf::st_bbox(bbox_new))

    result$bbox <- paste0(values, collapse = ",")
  }

  return(result)
}

get_sf_from_bbox <- function(bbox, srs) {
  if (inherits(bbox, "sf") || inherits(bbox, "sfc")) {
    return(bbox)
  }

  # Sanity check
  if (!(is.numeric(bbox) && length(bbox) == 4)) {
    stop("bbox should be a vector of 4 numbers.", call. = FALSE)
  }

  if (missing(srs)) stop("Please provide a srs value", call. = FALSE)

  # Create template for a spatial bbox
  template_sf <- sf::st_sfc(sf::st_point(c(0, 0)))
  template_bbox <- sf::st_bbox(template_sf)

  # Create the spatial object
  bbox_new <- bbox
  class(bbox_new) <- class(template_bbox)

  bbox_new <- sf::st_as_sfc(bbox_new)
  bbox_new <- sf::st_set_crs(bbox_new, srs)

  return(bbox_new)
}


message_on_limit <- function(bbox_res, limit_km2) {
  bbox_num <- as.double(unlist(strsplit(bbox_res$bbox, ",")))

  spat <- get_sf_from_bbox(bbox_num,
    srs = bbox_res$incrs
  )

  # To EPSG:3857 for meters
  spat <- sf::st_transform(spat, 3857)

  area <- sf::st_area(spat)

  # Dirty convert to km2
  area <- as.double(area) / 1000000

  if (area > limit_km2) {
    message(
      "Bbox area is aprox ", round(area, 1),
      "km2. Limit of this service is ",
      limit_km2,
      "km2. The query may fail."
    )
  }

  return(invisible(NULL))
}
