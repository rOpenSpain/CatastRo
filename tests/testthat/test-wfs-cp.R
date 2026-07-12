test_that("CP wrappers build WFS queries", {
  local_mocked_bindings(
    wfs_read_bbox_query = mock_wfs_bbox_query,
    wfs_read_stored_query = mock_wfs_stored_query
  )

  parcel <- catr_wfs_get_parcels_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829,
    verbose = TRUE
  )
  expect_equal(parcel$path, "INSPIRE/wfsCP.aspx")
  expect_equal(parcel$typenames, "CP.CADASTRALPARCEL")
  expect_equal(parcel$limit_km2, 1)
  expect_true(parcel$verbose)

  zoning_bbox <- catr_wfs_get_parcels_bbox(
    c(760926, 4019259, 761155, 4019366),
    what = "zoning"
  )
  expect_equal(zoning_bbox$typenames, "CP.CADASTRALZONING")
  expect_equal(zoning_bbox$limit_km2, 25)

  zoning <- catr_wfs_get_parcels_zoning("41624TF3146S")
  expect_equal(zoning$path, "INSPIRE/wfsCP.aspx")
  expect_equal(zoning$query$StoredQuerie_id, "GetZoning")
  expect_equal(zoning$query$cod_zona, "41624TF3146S")

  parcel_ref <- catr_wfs_get_parcels_parcel("3662303TF3136B", srs = 4326)
  expect_equal(parcel_ref$srs, 4326)
  expect_equal(parcel_ref$query$StoredQuerie_id, "GetParcel")
  expect_equal(parcel_ref$query$refcat, "3662303TF3136B")

  neighbor <- catr_wfs_get_parcels_neigh_parcel("3662303TF3136B")
  expect_equal(neighbor$query$StoredQuerie_id, "GetNeighbourParcel")
  expect_equal(neighbor$query$refcat, "3662303TF3136B")

  parcel_zoning <- catr_wfs_get_parcels_parcel_zoning("41624TF3146S")
  expect_equal(parcel_zoning$query$StoredQuerie_id, "GetParcelsByZoning")
  expect_equal(parcel_zoning$query$cod_zona, "41624TF3146S")
})

test_that("BBOX Check errors", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  expect_snapshot(
    error = TRUE,
    catr_wfs_get_parcels_bbox(x = "1234", what = "xxx")
  )
  expect_snapshot(error = TRUE, catr_wfs_get_parcels_bbox(x = "1234"))
  expect_snapshot(
    error = TRUE,
    catr_wfs_get_parcels_bbox(x = c("1234", "a", "3", "4"))
  )
  expect_snapshot(error = TRUE, catr_wfs_get_parcels_bbox(x = c(1, 2, 3)))
  expect_snapshot(error = TRUE, catr_wfs_get_parcels_bbox(x = c(1, 2, 3, 4)))
  expect_snapshot(s <- catr_wfs_get_parcels_bbox(x = c(1, 2, 3, 4), srs = 3857))
  expect_null(s)
})

test_that("BBOX Check projections", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  # Check messages
  obj <- catr_wfs_get_parcels_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829
  )

  expect_equal(sf::st_crs(obj)$epsg, 25829)

  # Convert to spatial object
  obj2 <- sf::st_transform(obj, 4326)
  obj2 <- catr_wfs_get_parcels_bbox(obj2)
  expect_equal(sf::st_crs(obj2)$epsg, 4326)

  # Another type
  obj3 <- catr_wfs_get_parcels_bbox(obj2, what = "zoning")
  expect_gt(nrow(obj2), nrow(obj3))
})

test_that("CP Zone", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  obj <- catr_wfs_get_parcels_zoning("41624TF3146S")
  expect_s3_class(obj, "sf")
  obj2 <- catr_wfs_get_parcels_parcel_zoning("41624TF3146S", srs = 3857)
  expect_s3_class(obj2, "sf")
  expect_gt(nrow(obj2), nrow(obj))

  expect_snapshot(
    obj <- catr_wfs_get_parcels_zoning("41624TF3146SZZ", srs = 3857)
  )
  expect_null(obj)
  expect_snapshot(
    obj <- catr_wfs_get_parcels_parcel_zoning("41624TF3146SZZ", srs = 3857)
  )
  expect_null(obj)
})

test_that("CP Parcels", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  neigh <- catr_wfs_get_parcels_neigh_parcel("3662303TF3136B")
  sing <- catr_wfs_get_parcels_parcel("3662303TF3136B")

  expect_gt(nrow(neigh), nrow(sing))

  # NULL
  expect_null(catr_wfs_get_parcels_neigh_parcel("3662303TFXXXXX", srs = 3857))
  expect_null(catr_wfs_get_parcels_parcel("3662303TFXXXXX", srs = 3857))
})
