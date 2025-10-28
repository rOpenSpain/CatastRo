test_that("BU Check error on srs", {
  expect_error(catr_wfs_get_buildings_rc(rc = "1234", srs = 20))
  expect_error(catr_wfs_get_buildings_rc(rc = 1234, what = "xxx"))
})

test_that("Check error on bad rc", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  expect_message(catr_wfs_get_buildings_rc(rc = "1234"))

  expect_message(catr_wfs_get_buildings_rc(rc = "3662303TFxxxxx"))
})

test_that("BU Check srs", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  obj <- catr_wfs_get_buildings_rc(
    "3662303TF3136B",
    srs = 3857,
    verbose = TRUE
  )

  expect_true(sf::st_crs(obj) == sf::st_crs(3857))
})

test_that("BU Check verbose", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  expect_message(catr_wfs_get_buildings_rc("3662303TF3136B", verbose = TRUE))
})


test_that("BU Part Check", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  obj <- catr_wfs_get_buildings_rc("9398516VK3799G", what = "buildingpart")
  expect_true(nrow(obj) > 1)
  expect_s3_class(obj, "sf")
})


test_that("BU Other Check", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  obj <- catr_wfs_get_buildings_rc("9398516VK3799G", what = "other")
  expect_s3_class(obj, "sf")
})

test_that("BBOX Check errors", {
  skip_on_cran()
  skip_if_offline()

  expect_error(catr_wfs_get_buildings_bbox(bbox = "1234"))
  expect_error(catr_wfs_get_buildings_bbox(bbox = c("1234", "a", "3", "4")))
  expect_error(catr_wfs_get_buildings_bbox(bbox = c(1, 2, 3)))
  expect_error(catr_wfs_get_buildings_bbox(bbox = c(1, 2, 3, 4)))
})


test_that("BBOX Check projections", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  expect_error(catr_wfs_get_buildings_bbox(
    c(760926, 4019259, 761155, 4019366),
    what = 25829
  ))

  obj <- catr_wfs_get_buildings_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829
  )

  expect_true(sf::st_crs(obj) == sf::st_crs(25829))

  # test conversion
  testconv <- get_sf_from_bbox(obj[1, ])
  expect_identical(obj[1, ], testconv)

  # Convert to spatial object

  bbox <- get_sf_from_bbox(
    c(760926, 4019259, 761155, 4019366),
    25829
  )
  expect_s3_class(bbox, "sfc")

  obj2 <- catr_wfs_get_buildings_bbox(bbox)
  expect_true(sf::st_crs(obj2) == sf::st_crs(25829))

  # Transform object to geographic coords
  bbox2 <- sf::st_transform(obj2[1, ], 4326)
  expect_true(sf::st_is_longlat(bbox2))
  expect_s3_class(bbox2, "sf")

  obj3 <- catr_wfs_get_buildings_bbox(bbox2)

  expect_true(sf::st_is_longlat(obj3))
  expect_true(sf::st_crs(obj3) == sf::st_crs(4326))

  # BBox with coordinates

  vec <- as.double(sf::st_bbox(obj3[1, ]))

  obj4 <- catr_wfs_get_buildings_bbox(vec, srs = 4326)

  expect_true(sf::st_is_longlat(obj4))
  expect_true(sf::st_crs(obj4) == sf::st_crs(4326))
})
