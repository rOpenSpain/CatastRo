test_that("Check error", {
  expect_error(catr_wms_get_layer(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829,
    what = "aa"
  ))
})

test_that("Check tiles", {
  skip_on_cran()
  skip_if_offline()
  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  obj <- catr_wms_get_layer(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829,
    cache_dir = cdir
  )

  expect_s4_class(obj, "SpatRaster")

  # test crop
  objcrop <- catr_wms_get_layer(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829,
    crop = TRUE,
    cache_dir = cdir
  )

  expect_true(terra::nrow(obj) > terra::nrow(objcrop))

  # Convert to spatial object
  bbox <- get_sf_from_bbox(
    c(760926, 4019259, 761155, 4019366),
    25829
  )
  expect_s3_class(bbox, "sfc")

  obj2 <- catr_wms_get_layer(bbox, cache_dir = cdir)

  expect_s4_class(obj2, "SpatRaster")

  # With styles
  obj3 <- catr_wms_get_layer(
    c(222500, 4019500, 222700, 4019700),
    srs = 25830,
    what = "building",
    styles = "ELFCadastre",
    options = list(version = "1.3.0"),
    cache_dir = cdir
  )

  expect_s4_class(obj3, "SpatRaster")
  unlink(cdir, recursive = TRUE, force = TRUE)
})
