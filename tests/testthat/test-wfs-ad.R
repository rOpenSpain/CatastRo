test_that("catr_wfs_get_address_bbox() validates bounding-box coordinates", {
  local_mocked_bindings(wfs_read_bbox_query = function(x, srs, ...) {
    if (is.numeric(x) && x[[1]] < 0) {
      return(NULL)
    }

    crs <- srs
    if (is.null(crs)) {
      crs <- sf::st_crs(x)$epsg
    }
    geometry <- sf::st_sfc(
      lapply(seq_len(2), function(i) sf::st_point(c(i, i))),
      crs = crs
    )
    sf::st_sf(id = seq_len(2), geometry = geometry)
  })

  fend <- catr_wfs_get_address_bbox(c(-20, -20, -19, -20), srs = 4326)
  expect_null(fend)

  obj <- catr_wfs_get_address_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829
  )

  expect_equal(sf::st_crs(obj)$epsg, 25829)

  # Convert to spatial object
  bbox <- c(760926, 4019259, 761155, 4019366)
  class(bbox) <- "bbox"
  bbox <- bbox |>
    sf::st_as_sfc() |>
    sf::st_set_crs(25829)
  expect_s3_class(bbox, "sfc")

  obj2 <- catr_wfs_get_address_bbox(bbox)
  expect_equal(sf::st_crs(obj2), sf::st_crs(25829))
})

test_that("catr_wfs_get_address_codvia() retrieves addresses by street code", {
  local_mocked_bindings(wfs_read_stored_query = function(
    query,
    srs = NULL,
    ...
  ) {
    wfs_validate_srs(srs)

    if (query$del == 110 || query$mun == 390) {
      return(NULL)
    }

    geometry <- sf::st_sfc(
      sf::st_point(c(1, 1)),
      crs = if (is.null(srs)) 3857 else srs
    )
    sf::st_sf(id = 1, geometry = geometry)
  })

  obj <- catr_wfs_get_address_codvia("1", 11, 39)
  expect_s3_class(obj, "sf")

  # Another SRS
  obj <- catr_wfs_get_address_codvia("1", 11, 39, srs = 4326)
  expect_s3_class(obj, "sf")
  expect_equal(sf::st_crs(obj)$epsg, 4326)

  obj <- catr_wfs_get_address_codvia("1", 110, 390)
  expect_null(obj)
  expect_snapshot(
    error = TRUE,
    obj <- catr_wfs_get_address_codvia("1", 110, 390, srs = 9999)
  )
})

test_that("catr_wfs_get_address_rc() retrieves by cadastral reference", {
  local_mocked_bindings(wfs_read_stored_query = function(
    query,
    srs = NULL,
    ...
  ) {
    wfs_validate_srs(srs)

    if (nchar(query$REFCAT) < 14) {
      return(NULL)
    }

    geometry <- sf::st_sfc(
      sf::st_point(c(1, 1)),
      crs = if (is.null(srs)) 3857 else srs
    )
    sf::st_sf(id = 1, geometry = geometry)
  })

  obj <- catr_wfs_get_address_rc("3662303TF3136B")
  expect_s3_class(obj, "sf")

  # Another SRS
  obj <- catr_wfs_get_address_rc("3662303TF3136B", srs = 4326)
  expect_s3_class(obj, "sf")
  expect_equal(sf::st_crs(obj)$epsg, 4326)

  obj <- catr_wfs_get_address_rc("3662303TF")
  expect_null(obj)
  expect_snapshot(
    error = TRUE,
    obj <- catr_wfs_get_address_rc("3662303TF", srs = 9999)
  )
})

test_that("catr_wfs_get_address_postalcode() retrieves by postal code", {
  local_mocked_bindings(wfs_read_stored_query = function(
    query,
    srs = NULL,
    ...
  ) {
    wfs_validate_srs(srs)

    if (
      identical(query$postalcode, "XXXXX") || identical(query$REFCAT, "XXXXX")
    ) {
      return(NULL)
    }

    geometry <- sf::st_sfc(
      lapply(seq_len(2), function(i) sf::st_point(c(i, i))),
      crs = if (is.null(srs)) 3857 else srs
    )
    sf::st_sf(id = seq_len(2), geometry = geometry)
  })

  obj <- catr_wfs_get_address_postalcode("11009")
  expect_gt(nrow(obj), 1)
  expect_s3_class(obj, "sf")

  # Another SRS
  obj <- catr_wfs_get_address_postalcode("11009", srs = 4326)
  expect_s3_class(obj, "sf")
  expect_equal(sf::st_crs(obj)$epsg, 4326)

  obj <- catr_wfs_get_address_postalcode("XXXXX")
  expect_null(obj)
  expect_snapshot(
    error = TRUE,
    obj <- catr_wfs_get_address_postalcode("XXXXX", srs = 9999)
  )
})

test_that("address WFS functions can call the real API", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  bbox <- catr_wfs_get_address_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829
  )
  expect_s3_class(bbox, "sf")

  codvia <- catr_wfs_get_address_codvia("1", 11, 39)
  expect_s3_class(codvia, "sf")

  rc <- catr_wfs_get_address_rc("3662303TF3136B")
  expect_s3_class(rc, "sf")

  postal <- catr_wfs_get_address_postalcode("11009")
  expect_s3_class(postal, "sf")
})
