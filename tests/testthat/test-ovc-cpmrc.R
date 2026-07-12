test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(fend <- catr_ovc_get_cpmrc("9872023VH5797S"))
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

  expect_snapshot(fend <- catr_ovc_get_cpmrc("9872023VH5797S"))
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
    df <- catr_ovc_get_cpmrc(rc = "s", srs = "abcd")
  )
})

test_that("giving all the arguments", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_cpmrc(
    "13077A01800039",
    "4230",
    "CIUDAD REAL",
    "SANTA CRUZ DE MUDELA"
  )
  expect_s3_class(result, "tbl")
  expect_setequal(
    intersect(c("geo.xcen", "geo.ycen"), names(result)),
    c("geo.xcen", "geo.ycen")
  )
})

test_that("giving cadastral reference and SRS", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_cpmrc("9872023VH5797S", "4230")
  expect_type(result$xcoord, "double")
  expect_type(result$ycoord, "double")
})

test_that("giving only the cadastral reference", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  expect_snapshot(df <- catr_ovc_get_cpmrc("9872023VH5797S", verbose = TRUE))

  result <- catr_ovc_get_cpmrc(rc = "13077A01800039")
  expect_s3_class(result, "tbl")
})


test_that("given Municipio, Provincia is needed", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  expect_snapshot(
    nnn <- catr_ovc_get_cpmrc(
      rc = "13077A01800039",
      srs = "4230",
      municipality = "SANTA CRUZ DE MUDELA"
    )
  )

  expect_equal(ncol(nnn), 2)
})
