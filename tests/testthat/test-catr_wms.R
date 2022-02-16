test_that("Check error", {
  expect_error(catr_wms_layer(c(760926, 4019259, 761155, 4019366),
    srs = 25829,
    what = "aa"
  ))
})

test_that("Check tiles", {
  skip_on_cran()
  skip_on_os("linux")

  obj <- catr_wms_layer(c(760926, 4019259, 761155, 4019366),
    srs = 25829
  )

  expect_s4_class(obj, "SpatRaster")


  # test crop
  objcrop <- catr_wms_layer(c(760926, 4019259, 761155, 4019366),
    srs = 25829,
    crop = TRUE
  )


  expect_true(terra::nrow(obj) > terra::nrow(objcrop))


  # Convert to spatial object
  bbox <- get_sf_from_bbox(
    c(760926, 4019259, 761155, 4019366),
    25829
  )
  expect_s3_class(bbox, "sfc")

  obj2 <- catr_wms_layer(bbox)

  expect_s4_class(obj2, "SpatRaster")
})
