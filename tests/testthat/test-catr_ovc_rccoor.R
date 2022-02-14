test_that("Expect error on bad SRS", {
  expect_error(catr_ovc_rccoor(
    lat = 40.963200, lon = -5.671420,
    "abcd"
  ))
})



test_that("return data.frame given SRS", {
  skip_on_cran()
  skip_if_offline()

  result <- catr_ovc_rccoor(
    lat = 38.6196566583596, lon = -3.45624183836806,
    srs = "4230"
  )
  expect_s3_class(result, "tbl")
  expect_true(is.numeric(result$geo.xcen))
  expect_true(is.numeric(result$geo.ycen))
})

test_that("return data.frame without SRS", {
  skip_on_cran()
  skip_if_offline()

  result <- catr_ovc_rccoor(lat = 38.6196566583596, lon = -3.45624183836806)
  expect_s3_class(result, "tbl")
})

test_that("check fields without SRS", {
  skip_on_cran()
  skip_if_offline()

  result <- catr_ovc_rccoor(lat = 38.6196566583596, lon = -3.45624183836806)
  expect_true((is.character(result$address) & is.character(result$refcat)))
})

test_that("check fields given SRS", {
  skip_on_cran()
  skip_if_offline()

  result <- catr_ovc_rccoor(
    lat = 38.6196566583596, lon = -3.45624183836806,
    srs = "4230"
  )
  expect_true((is.character(result$address) & is.character(result$refcat)))
})

test_that("if data is know return NA", {
  result <- catr_ovc_rccoor(lat = 99999999, lon = -999999999)
  expect_true(ncol(result) == 3)
})


test_that("unprecised coordinates", {
  result <- catr_ovc_rccoor(
    lat = 40.963200, lon = -5.671420,
    srs = "4326"
  )
  expect_true(ncol(result) == 3)
})

test_that("Verbose", {
  expect_message(catr_ovc_rccoor(
    lat = 40.963200, lon = -5.671420,
    srs = "4326",
    verbose = TRUE
  ))
})
