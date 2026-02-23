test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(
    fend <- catr_ovc_get_cod_munic(4, 5)
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
    fend <- catr_ovc_get_cod_munic(4, 5)
  )
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})


test_that("Callejero munic", {
  skip_on_cran()
  skip_if_offline()

  expect_snapshot(error = TRUE, catr_ovc_get_cod_munic(2))
  s <- catr_ovc_get_cod_munic(5, 900)
  expect_gt(ncol(s), 1)

  # With INE code
  s2 <- catr_ovc_get_cod_munic(5, cmun_ine = s$cmun)
  expect_identical(s, s2)

  expect_message(catr_ovc_get_cod_munic(5, 1304))

  nil <- catr_ovc_get_cod_munic(5, 1304)

  expect_true(ncol(nil) == 1)
  expect_s3_class(nil, "tbl")
  expect_true(is.na(nil[1, 1]))
})
