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

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  expect_snapshot(fend <- catr_ovc_get_cod_provinces())
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("Callejero provinces", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(ovc_get_xml = function(url, verbose = FALSE) {
    if (verbose) {
      cli::cli_alert_info("Requesting {.url {url}}.")
      cli::cli_alert_success("Request succeeded.")
    }

    list(
      consulta_provinciero = list(
        provinciero = list(
          list(cp = "02", np = "ALBACETE"),
          list(cp = "05", np = "AVILA")
        )
      )
    )
  })

  s <- catr_ovc_get_cod_provinces()
  expect_s3_class(s, "tbl")
  expect_gt(nrow(s), 1)

  expect_snapshot(df <- catr_ovc_get_cod_provinces(verbose = TRUE))
})

test_that("OVC province codes can call the real API", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_cod_provinces()
  expect_s3_class(result, "tbl")
})
