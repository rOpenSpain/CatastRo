test_that("Expect error on bad SRS", {
  skip_on_cran()
  expect_error(catr_ovc_get_cpmrc(
    rc = "s",
    srs = "abcd"
  ))
})


test_that("giving all the arguments", {
  skip_on_cran()
  skip_if_offline()
  skip_on_os("linux")

  result <- catr_ovc_get_cpmrc(
    "13077A01800039",
    "4230", "CIUDAD REAL", "SANTA CRUZ DE MUDELA"
  )
  expect_s3_class(result, "tbl")
  expect_true(all(c("geo.xcen", "geo.ycen") %in% names(result)))
})


test_that("giving cadastral reference and SRS", {
  skip_on_cran()
  skip_if_offline()
  skip_on_os("linux")

  result <- catr_ovc_get_cpmrc("9872023VH5797S", "4230")
  expect_true((is.numeric(result$xcoord) & is.numeric(result$ycoord)))
})


test_that("giving only the cadastral reference", {
  skip_on_cran()
  skip_if_offline()
  skip_on_os("linux")

  expect_message(catr_ovc_get_cpmrc("9872023VH5797S",
    verbose = TRUE
  ))

  result <- catr_ovc_get_cpmrc(rc = "13077A01800039")
  expect_s3_class(result, "tbl")
})


test_that("given Municipio, Provincia is needed", {
  skip_on_cran()
  skip_if_offline()
  skip_on_os("linux")


  nnn <- catr_ovc_get_cpmrc(
    rc = "13077A01800039",
    srs = "4230",
    municipality = "SANTA CRUZ DE MUDELA"
  )
  expect_true(ncol(nnn) == 2)
})
