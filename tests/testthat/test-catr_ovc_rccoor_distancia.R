test_that("Expect error on bad SRS", {
  expect_error(catr_ovc_rccoor_distancia(
    lat = 40.963200, lon = -5.671420,
    "abcd"
  ))
})


test_that("return tibble given SRS", {
  skip_on_cran()
  skip_if_offline()

  result <- catr_ovc_rccoor_distancia(lat = 40.963200, lon = -5.671420, "4326")
  expect_s3_class(result, "tbl")
  expect_true(is.numeric(result$geo.xcen))
  expect_true(is.numeric(result$geo.ycen))
})

test_that("return tibble without SRS", {
  skip_on_cran()
  skip_if_offline()

  result <- catr_ovc_rccoor_distancia(lat = 40.963200, lon = -5.671420)
  expect_s3_class(result, "tbl")
})

test_that("check fields without SRS", {
  skip_on_cran()
  skip_if_offline()

  result <- catr_ovc_rccoor_distancia(lat = 40.963200, lon = -5.671420)



  expect_true((is.character(result$address) & is.character(result$refcat) &
    is.character(result$cmun_ine)))
})

test_that("check fields given SRS", {
  skip_on_cran()
  skip_if_offline()

  result <- catr_ovc_rccoor_distancia(lat = 40.963200, lon = -5.671420, 4230)
  expect_true((is.character(result$address) & is.character(result$refcat) &
    is.character(result$cmun_ine)))
})

test_that("if data is known return a tibble with 3 cols", {
  skip_on_cran()
  skip_if_offline()

  expect_message(catr_ovc_rccoor_distancia(lat = 99999999, lon = -999999999))
  result <- catr_ovc_rccoor_distancia(lat = 99999999, lon = -999999999)
  expect_true(ncol(result) == 3)
})

test_that("Expect message", {
  skip_on_cran()
  skip_if_offline()

  expect_message(catr_ovc_rccoor_distancia(
    lat = 40.963200,
    lon = -5.671420, verbose = TRUE
  ))
})
