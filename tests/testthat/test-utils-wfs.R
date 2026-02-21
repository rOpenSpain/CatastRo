test_that("wfs_get_bbox", {
  expect_snapshot(error = TRUE, wfs_get_bbox(c(1, 2)))
  expect_snapshot(error = TRUE, wfs_get_bbox(c(1, 2, 3, 4)))
  expect_silent(ok <- wfs_get_bbox(c(1, 1, 1, 1), srs = 4326))
  expect_s3_class(ok, "bbox")

  expect_equal(sf::st_crs(ok)$epsg, 3857)

  expect_true(is.numeric(as.vector(ok)))
  expect_length(ok, 4)
  expect_identical(ok, wfs_get_bbox(sf::st_as_sfc(ok)))

  # Trigger limit
  buf <- c(0, 0, 10000, 10000)
  class(buf) <- "bbox"
  buf <- sf::st_as_sfc(buf)
  buf <- sf::st_set_crs(buf, 3857)
  expect_snapshot(wfs_get_bbox(buf, limit_km2 = 1))
})
