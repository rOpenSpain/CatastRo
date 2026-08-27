test_that("catr_wfs_get_buildings_bbox() validates coordinates and types", {
  local_mocked_bindings(wfs_read_bbox_query = function(x, srs, typenames, ...) {
    if (is.numeric(x) && x[[1]] < 0) {
      return(NULL)
    }

    crs <- srs
    if (is.null(crs)) {
      crs <- sf::st_crs(x)$epsg
    }
    n <- switch(typenames,
      "BU.BUILDING" = 2,
      "BU.BUILDINGPART" = 3,
      "BU.OTHERCONSTRUCTION" = 1
    )
    geometry <- sf::st_sfc(
      lapply(seq_len(n), function(i) sf::st_point(c(i, i))),
      crs = crs
    )
    sf::st_sf(id = seq_len(n), geometry = geometry)
  })

  fend <- catr_wfs_get_buildings_bbox(c(-20, -20, -19, -20), srs = 4326)
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
  ot <- catr_wfs_get_buildings_bbox(bbox, what = "other")

  expect_s3_class(ot, "sf")

  expect_gt(nrow(obj2), nrow(ot))
})

test_that("catr_wfs_get_buildings_rc() handles invalid cadastral references", {
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

  f <- catr_wfs_get_buildings_rc(rc = "1234")
  expect_null(f)
})

test_that("catr_wfs_get_buildings_rc() preserves the requested SRS", {
  local_mocked_bindings(wfs_read_stored_query = function(
    query,
    srs = NULL,
    ...
  ) {
    wfs_validate_srs(srs)

    geometry <- sf::st_sfc(
      sf::st_point(c(1, 1)),
      crs = if (is.null(srs)) 3857 else srs
    )
    sf::st_sf(id = 1, geometry = geometry)
  })

  obj <- catr_wfs_get_buildings_rc("3662303TF3136B", srs = 3857)
  expect_equal(sf::st_crs(obj), sf::st_crs(3857))
})

test_that("catr_wfs_get_buildings_rc() retrieves building parts", {
  local_mocked_bindings(wfs_read_stored_query = function(
    query,
    srs = NULL,
    ...
  ) {
    wfs_validate_srs(srs)

    n <- if (query$StoredQuerie_id == "GetBuildingPartByParcel") 2 else 1
    geometry <- sf::st_sfc(
      lapply(seq_len(n), function(i) sf::st_point(c(i, i))),
      crs = if (is.null(srs)) 3857 else srs
    )
    sf::st_sf(id = seq_len(n), geometry = geometry)
  })

  obj <- catr_wfs_get_buildings_rc("9398516VK3799G", what = "buildingpart")
  expect_gt(nrow(obj), 1)
  expect_s3_class(obj, "sf")
})

test_that("catr_wfs_get_buildings_rc() retrieves other constructions", {
  local_mocked_bindings(wfs_read_stored_query = function(
    query,
    srs = NULL,
    ...
  ) {
    wfs_validate_srs(srs)

    geometry <- sf::st_sfc(
      sf::st_point(c(1, 1)),
      crs = if (is.null(srs)) 3857 else srs
    )
    sf::st_sf(id = 1, geometry = geometry)
  })

  obj <- catr_wfs_get_buildings_rc("9398516VK3799G", what = "other")
  expect_s3_class(obj, "sf")
})

test_that("building WFS functions can call the real API", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  bbox <- catr_wfs_get_buildings_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829
  )
  expect_s3_class(bbox, "sf")

  building <- catr_wfs_get_buildings_rc("3662303TF3136B", srs = 3857)
  expect_s3_class(building, "sf")

  part <- catr_wfs_get_buildings_rc("9398516VK3799G", what = "buildingpart")
  expect_s3_class(part, "sf")

  other <- catr_wfs_get_buildings_rc("9398516VK3799G", what = "other")
  expect_s3_class(other, "sf")
})
