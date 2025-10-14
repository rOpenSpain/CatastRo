test_that("CP Check error on srs", {
  expect_error(catr_wfs_get_parcels_parcel(rc = "1234", srs = 20))
})

test_that("Check error on bad rc", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  expect_message(catr_wfs_get_parcels_parcel(rc = "1234"))
})

test_that("CP Check srs", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  obj <- catr_wfs_get_parcels_parcel(
    "3662303TF3136B",
    srs = 3857,
    verbose = TRUE
  )

  expect_true(sf::st_crs(obj) == sf::st_crs(3857))
})

test_that("CP Check verbose", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  expect_message(catr_wfs_get_parcels_neigh_parcel("3662303TF3136B",
    verbose = TRUE
  ))
})


test_that("CP Zone", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  obj <- catr_wfs_get_parcels_zoning("41624TF3146S")
  expect_s3_class(obj, "sf")
})


test_that("CP ZONE 2", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  obj <- catr_wfs_get_parcels_parcel_zoning("36620TF3136S")
  expect_s3_class(obj, "sf")
})

test_that("BBOX Check errors", {
  skip_on_cran()
  skip_if_offline()

  expect_error(catr_wfs_get_parcels_bbox(bbox = "1234", what = "xxx"))
  expect_error(catr_wfs_get_parcels_bbox(bbox = "1234"))
  expect_error(catr_wfs_get_parcels_bbox(bbox = c("1234", "a", "3", "4")))
  expect_error(catr_wfs_get_parcels_bbox(bbox = c(1, 2, 3)))
  expect_error(catr_wfs_get_parcels_bbox(bbox = c(1, 2, 3, 4)))
})


test_that("BBOX Check projections", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  # Check messages

  obj <- get_sf_from_bbox(c(760926, 4019259, 761155, 4019366),
    srs = 25829
  )
  obj <- sf::st_buffer(obj, 2000)
  res <- wfs_bbox(obj)

  expect_equal(res$incrs, 3857)

  expect_message(message_on_limit(res, 5))


  obj <- catr_wfs_get_parcels_bbox(c(760926, 4019259, 761155, 4019366),
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

  obj2 <- catr_wfs_get_parcels_bbox(bbox)
  expect_true(sf::st_crs(obj2) == sf::st_crs(25829))
})
