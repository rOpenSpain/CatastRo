test_that("AD wrappers build WFS queries", {
  local_mocked_bindings(
    wfs_read_bbox_query = mock_wfs_bbox_query,
    wfs_read_stored_query = mock_wfs_stored_query
  )

  bbox <- catr_wfs_get_address_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829,
    verbose = TRUE
  )
  expect_equal(bbox$path, "INSPIRE/wfsAD.aspx")
  expect_equal(bbox$typenames, "AD.ADDRESS")
  expect_equal(bbox$limit_km2, 4)
  expect_true(bbox$verbose)

  codvia <- catr_wfs_get_address_codvia("1", 11, 39, srs = 4326)
  expect_equal(codvia$path, "INSPIRE/wfsAD.aspx")
  expect_equal(codvia$srs, 4326)
  expect_equal(codvia$query$StoredQuerie_id, "getadbycodvia")
  expect_equal(codvia$query$codvia, "1")
  expect_equal(codvia$query$del, 11)
  expect_equal(codvia$query$mun, 39)

  rc <- catr_wfs_get_address_rc("3662303TF3136B")
  expect_equal(rc$query$StoredQuerie_id, "GetadByRefcat")
  expect_equal(rc$query$REFCAT, "3662303TF3136B")

  postal <- catr_wfs_get_address_postalcode("11009")
  expect_equal(postal$query$StoredQuerie_id, "getadbypostalcode")
  expect_equal(postal$query$postalcode, "11009")
})

test_that("BBOX Check", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  expect_snapshot(
    fend <- catr_wfs_get_address_bbox(c(-20, -20, -19, -20), srs = 4326)
  )
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

test_that("AD CODVIA", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  obj <- catr_wfs_get_address_codvia("1", 11, 39)
  expect_s3_class(obj, "sf")

  # Another SRS
  obj <- catr_wfs_get_address_codvia("1", 11, 39, srs = 4326)
  expect_s3_class(obj, "sf")
  expect_equal(sf::st_crs(obj)$epsg, 4326)

  expect_snapshot(obj <- catr_wfs_get_address_codvia("1", 110, 390))
  expect_null(obj)
  expect_snapshot(
    error = TRUE,
    obj <- catr_wfs_get_address_codvia("1", 110, 390, srs = 9999)
  )
})

test_that("AD RC", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  obj <- catr_wfs_get_address_rc("3662303TF3136B")
  expect_s3_class(obj, "sf")

  # Another SRS
  obj <- catr_wfs_get_address_rc("3662303TF3136B", srs = 4326)
  expect_s3_class(obj, "sf")
  expect_equal(sf::st_crs(obj)$epsg, 4326)

  expect_snapshot(obj <- catr_wfs_get_address_rc("3662303TF"))
  expect_null(obj)
  expect_snapshot(
    error = TRUE,
    obj <- catr_wfs_get_address_rc("3662303TF", srs = 9999)
  )
})

test_that("AD Postal Code", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  obj <- catr_wfs_get_address_postalcode("11009")
  expect_gt(nrow(obj), 1)
  expect_s3_class(obj, "sf")

  # Another SRS
  obj <- catr_wfs_get_address_postalcode("11009", srs = 4326)
  expect_s3_class(obj, "sf")
  expect_equal(sf::st_crs(obj)$epsg, 4326)

  expect_snapshot(obj <- catr_wfs_get_address_postalcode("XXXXX"))
  expect_null(obj)
  expect_snapshot(
    error = TRUE,
    obj <- catr_wfs_get_address_rc("XXXXX", srs = 9999)
  )
})
