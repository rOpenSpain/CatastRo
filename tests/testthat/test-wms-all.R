test_that("Check error", {
  expect_snapshot(
    error = TRUE,
    catr_wms_get_layer(
      c(760926, 4019259, 761155, 4019366),
      srs = 25829,
      what = "aa"
    )
  )
})

test_that("WMS layer requests can be mocked", {
  local_mocked_bindings(catr_esp_get_tiles = function(...) {
    list(...)
  })

  result <- catr_wms_get_layer(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829,
    cache_dir = tempdir(),
    verbose = TRUE
  )

  expect_equal(result$type, "Catastro.Building")
  expect_equal(result$options$styles, "default")
  expect_equal(result$options$srs, "EPSG:25829")
  expect_true(result$verbose)

  result <- catr_wms_get_layer(
    c(222500, 4019500, 222700, 4019700),
    srs = 25830,
    what = "parcel",
    styles = "ELFCadastre",
    options = list(version = "1.3.0"),
    cache_dir = tempdir()
  )

  expect_equal(result$type, "Catastro.CadastralParcel")
  expect_equal(result$options$styles, "ELFCadastre")
  expect_equal(result$options$crs, "EPSG:25830")
  expect_null(result$options$srs)
})

test_that("Check tiles", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()
  cdir <- withr::local_tempdir(pattern = "testthat_ex")
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

  expect_gt(terra::nrow(obj), terra::nrow(objcrop))

  # Convert to spatial object
  bbox <- get_sf_from_bbox(c(760926, 4019259, 761155, 4019366), 25829)
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
})
