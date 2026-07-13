test_that("BBOX Check errors", {
  skip_on_cran()
  skip_if_offline()

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

  local_mocked_bindings(wfs_read_bbox_query = function(...) {
    cli::cli_alert_danger(c(
      "The WFS query returned an exception for a mocked response:\n",
      "No records founded for BBOX and SRS provided"
    ))
    NULL
  })
  expect_snapshot(s <- catr_wfs_get_parcels_bbox(x = c(1, 2, 3, 4), srs = 3857))
  expect_null(s)
})

test_that("BBOX Check projections", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(wfs_read_bbox_query = function(x, srs, typenames, ...) {
    crs <- srs
    if (is.null(crs)) {
      crs <- sf::st_crs(x)$epsg
    }
    n <- if (grepl("ZONING", typenames, fixed = TRUE)) 1 else 2
    geometry <- sf::st_sfc(
      lapply(seq_len(n), function(i) sf::st_point(c(i, i))),
      crs = crs
    )
    sf::st_sf(id = seq_len(n), geometry = geometry)
  })

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
  local_mocked_bindings(wfs_read_stored_query = function(
    query,
    srs = NULL,
    ...
  ) {
    if (grepl("ZZ", query$cod_zona, fixed = TRUE)) {
      cli::cli_alert_danger(c(
        "The WFS query returned an exception for a mocked response:\n",
        "Invalid length of COD_ZONA parameter"
      ))
      return(NULL)
    }

    n <- if (query$StoredQuerie_id == "GetParcelsByZoning") 2 else 1
    geometry <- sf::st_sfc(
      lapply(seq_len(n), function(i) sf::st_point(c(i, i))),
      crs = if (is.null(srs)) 3857 else srs
    )
    sf::st_sf(id = seq_len(n), geometry = geometry)
  })

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
  local_mocked_bindings(wfs_read_stored_query = function(
    query,
    srs = NULL,
    ...
  ) {
    if (grepl("XXXXX", query$refcat, fixed = TRUE)) {
      return(NULL)
    }

    n <- if (query$StoredQuerie_id == "GetNeighbourParcel") 2 else 1
    geometry <- sf::st_sfc(
      lapply(seq_len(n), function(i) sf::st_point(c(i, i))),
      crs = if (is.null(srs)) 3857 else srs
    )
    sf::st_sf(id = seq_len(n), geometry = geometry)
  })

  neigh <- catr_wfs_get_parcels_neigh_parcel("3662303TF3136B")
  sing <- catr_wfs_get_parcels_parcel("3662303TF3136B")

  expect_gt(nrow(neigh), nrow(sing))

  # NULL
  expect_null(catr_wfs_get_parcels_neigh_parcel("3662303TFXXXXX", srs = 3857))
  expect_null(catr_wfs_get_parcels_parcel("3662303TFXXXXX", srs = 3857))
})

test_that("CP WFS functions can call the real API", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  bbox <- catr_wfs_get_parcels_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829
  )
  expect_s3_class(bbox, "sf")

  zoning <- catr_wfs_get_parcels_zoning("41624TF3146S")
  expect_s3_class(zoning, "sf")

  parcel_zoning <- catr_wfs_get_parcels_parcel_zoning(
    "41624TF3146S",
    srs = 3857
  )
  expect_s3_class(parcel_zoning, "sf")

  parcel <- catr_wfs_get_parcels_parcel("3662303TF3136B")
  expect_s3_class(parcel, "sf")

  neigh <- catr_wfs_get_parcels_neigh_parcel("3662303TF3136B")
  expect_s3_class(neigh, "sf")
})
