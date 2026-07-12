test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(fend <- catr_ovc_get_cod_provinces())
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

  expect_snapshot(fend <- catr_ovc_get_cod_provinces())
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Callejero provinces can be mocked", {
  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_provinciero = list(
        provinciero = list(
          list(cp = "28", np = "MADRID"),
          list(cp = "40", np = "SEGOVIA")
        )
      )
    )
  })

  result <- catr_ovc_get_cod_provinces()

  expect_s3_class(result, "tbl")
  expect_equal(result$cp, c("28", "40"))
  expect_equal(result$np, c("MADRID", "SEGOVIA"))
})

test_that("Callejero provinces", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  s <- catr_ovc_get_cod_provinces()
  expect_s3_class(s, "tbl")

  expect_snapshot(df <- catr_ovc_get_cod_provinces(verbose = TRUE))
})
