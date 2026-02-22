test_that("BBOX Check", {
  skip_on_cran()
  skip_if_offline()

  expect_message(
    fend <- catr_wfs_get_buildings_bbox(
      c(-20, -20, -19, -20),
      srs = 4326
    ),
    "didn't provide results"
  )
  expect_null(fend)

  obj <- catr_wfs_get_buildings_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829
  )

  expect_true(sf::st_crs(obj)$epsg == 25829)

  # Convert to spatial object
  bbox <- c(760926, 4019259, 761155, 4019366)
  class(bbox) <- "bbox"
  bbox <- bbox |>
    sf::st_as_sfc() |>
    sf::st_set_crs(25829)
  expect_s3_class(bbox, "sfc")

  obj2 <- catr_wfs_get_buildings_bbox(bbox)
  expect_true(sf::st_crs(obj2) == sf::st_crs(25829))

  # Another types
  parts <- catr_wfs_get_buildings_bbox(
    bbox,
    what = "buildingpart"
  )

  expect_s3_class(parts, "sf")

  expect_gt(nrow(parts), nrow(obj2))

  ot <- # Another types
    parts <- catr_wfs_get_buildings_bbox(
      bbox,
      what = "other"
    )

  expect_s3_class(ot, "sf")

  expect_gt(nrow(obj2), nrow(ot))
})


test_that("Check error on bad rc", {
  skip_on_cran()
  skip_if_offline()

  expect_message(f <- catr_wfs_get_buildings_rc(rc = "1234"))
  expect_null(f)
})

test_that("BU Check srs", {
  skip_on_cran()
  skip_if_offline()

  obj <- catr_wfs_get_buildings_rc("3662303TF3136B", srs = 3857)
  expect_true(sf::st_crs(obj) == sf::st_crs(3857))
})


test_that("BU Part Check", {
  skip_on_cran()
  skip_if_offline()

  obj <- catr_wfs_get_buildings_rc("9398516VK3799G", what = "buildingpart")
  expect_true(nrow(obj) > 1)
  expect_s3_class(obj, "sf")
})

test_that("BU Other Check", {
  skip_on_cran()
  skip_if_offline()

  obj <- catr_wfs_get_buildings_rc("9398516VK3799G", what = "other")
  expect_s3_class(obj, "sf")
})
