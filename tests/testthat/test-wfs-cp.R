test_that("BBOX Check errors", {
  skip_on_cran()
  skip_if_offline()

  expect_error(catr_wfs_get_parcels_bbox(x = "1234", what = "xxx"))
  expect_error(catr_wfs_get_parcels_bbox(x = "1234"))
  expect_error(catr_wfs_get_parcels_bbox(x = c("1234", "a", "3", "4")))
  expect_error(catr_wfs_get_parcels_bbox(x = c(1, 2, 3)))
  expect_error(catr_wfs_get_parcels_bbox(x = c(1, 2, 3, 4)))
  expect_message(s <- catr_wfs_get_parcels_bbox(x = c(1, 2, 3, 4), srs = 3857))
  expect_null(s)
})

test_that("BBOX Check projections", {
  skip_on_cran()
  skip_if_offline()

  # Check messages
  obj <- catr_wfs_get_parcels_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829
  )

  expect_true(sf::st_crs(obj)$epsg == 25829)

  # Convert to spatial object
  obj2 <- sf::st_transform(obj, 4326)
  obj2 <- catr_wfs_get_parcels_bbox(obj2)
  expect_true(sf::st_crs(obj2)$epsg == 4326)

  # Another type
  obj3 <- catr_wfs_get_parcels_bbox(obj2, what = "zoning")
  expect_gt(nrow(obj2), nrow(obj3))
})

test_that("CP Zone", {
  skip_on_cran()
  skip_if_offline()

  obj <- catr_wfs_get_parcels_zoning("41624TF3146S")
  expect_s3_class(obj, "sf")
  obj2 <- catr_wfs_get_parcels_parcel_zoning("41624TF3146S", srs = 3857)
  expect_s3_class(obj2, "sf")
  expect_gt(nrow(obj2), nrow(obj))

  expect_message(
    obj <- catr_wfs_get_parcels_zoning("41624TF3146SZZ", srs = 3857)
  )
  expect_null(obj)
  expect_message(
    obj <- catr_wfs_get_parcels_parcel_zoning("41624TF3146SZZ", srs = 3857)
  )
  expect_null(obj)
})

test_that("CP Parcels", {
  skip_on_cran()
  skip_if_offline()

  neigh <- catr_wfs_get_parcels_neigh_parcel("3662303TF3136B")
  sing <- catr_wfs_get_parcels_parcel("3662303TF3136B")

  expect_gt(nrow(neigh), nrow(sing))

  # NULL
  expect_null(catr_wfs_get_parcels_neigh_parcel("3662303TFXXXXX", srs = 3857))
  expect_null(catr_wfs_get_parcels_parcel("3662303TFXXXXX", srs = 3857))
})
