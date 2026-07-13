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

test_that("Check tiles", {
  calls <- list()
  local_mocked_bindings(catr_esp_get_tiles = function(x, type, options, ...) {
    calls[[length(calls) + 1]] <<- list(type = type, options = options)

    bbox <- sf::st_bbox(x)
    out <- terra::rast(
      nrows = 10,
      ncols = 10,
      nlyrs = 3,
      xmin = bbox[["xmin"]] - 100,
      xmax = bbox[["xmax"]] + 100,
      ymin = bbox[["ymin"]] - 100,
      ymax = bbox[["ymax"]] + 100,
      crs = sf::st_crs(x)$wkt
    )
    terra::values(out) <- seq_len(terra::ncell(out) * terra::nlyr(out))
    out
  })

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
  expect_equal(calls[[1]]$type, "Catastro.Building")
  expect_equal(calls[[4]]$type, "Catastro.Building")
  expect_equal(calls[[4]]$options$styles, "ELFCadastre")
  expect_equal(calls[[4]]$options$version, "1.3.0")
  expect_equal(calls[[4]]$options$crs, "EPSG:25830")
  expect_null(calls[[4]]$options$srs)
})

test_that("WMS layer can call the real API", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  cdir <- withr::local_tempdir(pattern = "testthat_wms")
  obj <- catr_wms_get_layer(
    c(222500, 4019500, 222700, 4019700),
    srs = 25830,
    what = "building",
    cache_dir = cdir
  )

  expect_s4_class(obj, "SpatRaster")
})
