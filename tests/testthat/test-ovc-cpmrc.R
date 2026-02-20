test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(
    fend <- catr_ovc_get_cpmrc("9872023VH5797S")
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

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  expect_snapshot(
    fend <- catr_ovc_get_cpmrc("9872023VH5797S")
  )
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Expect error on bad SRS", {
  skip_on_cran()
  skip_if_offline()
  expect_error(
    catr_ovc_get_cpmrc(
      rc = "s",
      srs = "abcd"
    )
  )
})

test_that("giving all the arguments", {
  skip_on_cran()
  skip_if_offline()

  result <- catr_ovc_get_cpmrc(
    "13077A01800039",
    "4230",
    "CIUDAD REAL",
    "SANTA CRUZ DE MUDELA"
  )
  expect_s3_class(result, "tbl")
  expect_true(all(c("geo.xcen", "geo.ycen") %in% names(result)))
})

test_that("giving cadastral reference and SRS", {
  skip_on_cran()
  skip_if_offline()

  result <- catr_ovc_get_cpmrc("9872023VH5797S", "4230")
  expect_true((is.numeric(result$xcoord) & is.numeric(result$ycoord)))
})


test_that("giving only the cadastral reference", {
  skip_on_cran()
  skip_if_offline()

  expect_message(catr_ovc_get_cpmrc("9872023VH5797S", verbose = TRUE))

  result <- catr_ovc_get_cpmrc(rc = "13077A01800039")
  expect_s3_class(result, "tbl")
})


test_that("given Municipio, Provincia is needed", {
  skip_on_cran()
  skip_if_offline()

  expect_message(
    nnn <- catr_ovc_get_cpmrc(
      rc = "13077A01800039",
      srs = "4230",
      municipality = "SANTA CRUZ DE MUDELA"
    )
  )

  expect_true(ncol(nnn) == 2)
})
