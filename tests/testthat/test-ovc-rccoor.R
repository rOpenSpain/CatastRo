test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(
    fend <- catr_ovc_get_rccoor(lat = 40.963200, lon = -5.671420, srs = 4326)
  )
  expect_null(fend)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Test 404 all", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(
    is_404 = function(...) {
      TRUE
    },
    catr_req_perform = mock_404_response
  )

  expect_snapshot(
    fend <- catr_ovc_get_rccoor(lat = 40.963200, lon = -5.671420, srs = 4326)
  )
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Expect error on bad SRS", {
  skip_on_cran()
  skip_if_offline()

  expect_snapshot(
    error = TRUE,
    df <- catr_ovc_get_rccoor(lat = 40.963200, lon = -5.671420, "abcd")
  )
})

test_that("return data.frame given SRS", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_rccoor(
    lat = 38.6196566583596,
    lon = -3.45624183836806,
    srs = "4230"
  )
  expect_s3_class(result, "tbl")
  expect_type(result$geo.xcen, "double")
  expect_type(result$geo.ycen, "double")
})

test_that("return data.frame without SRS", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_rccoor(lat = 38.6196566583596, lon = -3.45624183836806)
  expect_s3_class(result, "tbl")
})

test_that("check fields without SRS", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_rccoor(lat = 38.6196566583596, lon = -3.45624183836806)
  expect_type(result$address, "character")
  expect_type(result$refcat, "character")
})

test_that("check fields given SRS", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_rccoor(
    lat = 38.6196566583596,
    lon = -3.45624183836806,
    srs = "4230"
  )
  expect_type(result$address, "character")
  expect_type(result$refcat, "character")
})

test_that("if data is know return NA", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_rccoor(lat = 99999999, lon = -999999999)
  expect_equal(ncol(result), 3)
})

test_that("unprecised coordinates", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_rccoor(lat = 40.963200, lon = -5.671420, srs = "4326")
  expect_equal(ncol(result), 3)
})

test_that("Verbose", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  expect_snapshot(
    df <- catr_ovc_get_rccoor(
      lat = 40.963200,
      lon = -5.671420,
      srs = "4326",
      verbose = TRUE
    )
  )
})
