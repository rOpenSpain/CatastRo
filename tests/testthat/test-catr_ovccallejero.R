test_that("Callejero provinces", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  s <- catr_ovc_get_cod_provinces()
  expect_s3_class(s, "tbl")

  expect_message(catr_ovc_get_cod_provinces(verbose = TRUE))
})

test_that("Callejero munic", {
  skip_on_cran()
  skip_on_os("linux")
  skip_if_offline()

  expect_error(catr_ovc_get_cod_munic())
  expect_error(catr_ovc_get_cod_munic(cmun = 900))
  s <- catr_ovc_get_cod_munic(5, 900)
  expect_gt(ncol(s), 1)

  # With INE code
  s2 <- catr_ovc_get_cod_munic(5, cmun_ine = s$cmun)
  expect_identical(s, s2)


  expect_message(catr_ovc_get_cod_munic(5, 1304,
    verbose = TRUE
  ))

  nil <- catr_ovc_get_cod_munic(5, 1304)

  expect_true(ncol(nil) == 1)
  expect_s3_class(nil, "tbl")
  expect_true(is.na(nil[1, 1]))
})
