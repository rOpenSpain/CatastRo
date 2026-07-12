test_that("BU wrappers build WFS queries", {
  local_mocked_bindings(
    wfs_read_bbox_query = mock_wfs_bbox_query,
    wfs_read_stored_query = mock_wfs_stored_query
  )

  building <- catr_wfs_get_buildings_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829,
    verbose = TRUE
  )
  expect_equal(building$path, "INSPIRE/wfsBU.aspx")
  expect_equal(building$typenames, "BU.BUILDING")
  expect_equal(building$limit_km2, 4)
  expect_true(building$verbose)

  part <- catr_wfs_get_buildings_bbox(
    c(760926, 4019259, 761155, 4019366),
    what = "buildingpart"
  )
  expect_equal(part$typenames, "BU.BUILDINGPART")

  other <- catr_wfs_get_buildings_bbox(
    c(760926, 4019259, 761155, 4019366),
    what = "other"
  )
  expect_equal(other$typenames, "BU.OTHERCONSTRUCTION")

  rc <- catr_wfs_get_buildings_rc("3662303TF3136B", srs = 4326)
  expect_equal(rc$path, "INSPIRE/wfsBU.aspx")
  expect_equal(rc$srs, 4326)
  expect_equal(rc$query$StoredQuerie_id, "GetBuildingByParcel")
  expect_equal(rc$query$REFCAT, "3662303TF3136B")

  rc_part <- catr_wfs_get_buildings_rc("3662303TF3136B", what = "buildingpart")
  expect_equal(rc_part$query$StoredQuerie_id, "GetBuildingPartByParcel")

  rc_other <- catr_wfs_get_buildings_rc("3662303TF3136B", what = "other")
  expect_equal(rc_other$query$StoredQuerie_id, "GetOtherBuildingByParcel")
})

test_that("BBOX Check", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  expect_snapshot(
    fend <- catr_wfs_get_buildings_bbox(c(-20, -20, -19, -20), srs = 4326)
  )
  expect_null(fend)

  obj <- catr_wfs_get_buildings_bbox(
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

  obj2 <- catr_wfs_get_buildings_bbox(bbox)
  expect_equal(sf::st_crs(obj2), sf::st_crs(25829))

  # Another types
  parts <- catr_wfs_get_buildings_bbox(bbox, what = "buildingpart")

  expect_s3_class(parts, "sf")

  expect_gt(nrow(parts), nrow(obj2))

  # Another types
  ot <- parts <- catr_wfs_get_buildings_bbox(bbox, what = "other")

  expect_s3_class(ot, "sf")

  expect_gt(nrow(obj2), nrow(ot))
})

test_that("Check error on bad rc", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  expect_snapshot(f <- catr_wfs_get_buildings_rc(rc = "1234"))
  expect_null(f)
})

test_that("BU Check srs", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  obj <- catr_wfs_get_buildings_rc("3662303TF3136B", srs = 3857)
  expect_equal(sf::st_crs(obj), sf::st_crs(3857))
})


test_that("BU Part Check", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  obj <- catr_wfs_get_buildings_rc("9398516VK3799G", what = "buildingpart")
  expect_gt(nrow(obj), 1)
  expect_s3_class(obj, "sf")
})

test_that("BU Other Check", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  obj <- catr_wfs_get_buildings_rc("9398516VK3799G", what = "other")
  expect_s3_class(obj, "sf")
})
