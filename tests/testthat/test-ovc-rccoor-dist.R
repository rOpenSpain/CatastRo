test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(
    fend <- catr_ovc_get_rccoor_distancia(
      lat = 40.963200,
      lon = -5.671420,
      srs = 4326
    )
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
    fend <- catr_ovc_get_rccoor_distancia(
      lat = 40.963200,
      lon = -5.671420,
      srs = 4326
    )
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
    df <- catr_ovc_get_rccoor_distancia(
      lat = 40.963200,
      lon = -5.671420,
      "abcd"
    )
  )
})

test_that("return tibble given SRS", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas_distancias = list(
        coordenadas_distancias = list(
          coordd = list(
            geo = list(
              xcen = "-5.671420",
              ycen = "40.963200",
              srs = "EPSG:4326"
            ),
            lpcd = list(
              list(
                pc = list(pc1 = "9872023", pc2 = "VH5797S"),
                ldt = "Mocked address",
                dt = list(loine = list(cp = "37", cm = "274"))
              )
            )
          )
        )
      )
    )
  })

  result <- catr_ovc_get_rccoor_distancia(
    lat = 40.963200,
    lon = -5.671420,
    "4326"
  )
  expect_s3_class(result, "tbl")
  expect_type(result$geo.xcen, "double")
  expect_type(result$geo.ycen, "double")
})

test_that("return tibble without SRS", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas_distancias = list(
        coordenadas_distancias = list(
          coordd = list(
            geo = list(
              xcen = "-5.671420",
              ycen = "40.963200",
              srs = "EPSG:4326"
            ),
            lpcd = list(
              list(
                pc = list(pc1 = "9872023", pc2 = "VH5797S"),
                ldt = "Mocked address",
                dt = list(loine = list(cp = "37", cm = "274"))
              )
            )
          )
        )
      )
    )
  })

  result <- catr_ovc_get_rccoor_distancia(lat = 40.963200, lon = -5.671420)
  expect_s3_class(result, "tbl")
})

test_that("check fields without SRS", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas_distancias = list(
        coordenadas_distancias = list(
          coordd = list(
            geo = list(
              xcen = "-5.671420",
              ycen = "40.963200",
              srs = "EPSG:4326"
            ),
            lpcd = list(
              list(
                pc = list(pc1 = "9872023", pc2 = "VH5797S"),
                ldt = "Mocked address",
                dt = list(loine = list(cp = "37", cm = "274"))
              )
            )
          )
        )
      )
    )
  })

  result <- catr_ovc_get_rccoor_distancia(lat = 40.963200, lon = -5.671420)

  expect_type(result$address, "character")
  expect_type(result$refcat, "character")
  expect_type(result$cmun_ine, "character")
})

test_that("check fields given SRS", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas_distancias = list(
        coordenadas_distancias = list(
          coordd = list(
            geo = list(
              xcen = "-5.671420",
              ycen = "40.963200",
              srs = "EPSG:4230"
            ),
            lpcd = list(
              list(
                pc = list(pc1 = "9872023", pc2 = "VH5797S"),
                ldt = "Mocked address",
                dt = list(loine = list(cp = "37", cm = "274"))
              )
            )
          )
        )
      )
    )
  })

  result <- catr_ovc_get_rccoor_distancia(
    lat = 40.963200,
    lon = -5.671420,
    4230
  )
  expect_type(result$address, "character")
  expect_type(result$refcat, "character")
  expect_type(result$cmun_ine, "character")
})

test_that("if data is known return a tibble with 3 cols", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas_distancias = list(
        coordenadas_distancias = list(
          coordd = list(
            geo = list(
              xcen = "-999999999",
              ycen = "99999999",
              srs = "EPSG:4326"
            )
          )
        )
      )
    )
  })

  expect_snapshot(
    df <- catr_ovc_get_rccoor_distancia(
      lat = 99999999,
      lon = -999999999
    )
  )
  result <- catr_ovc_get_rccoor_distancia(lat = 99999999, lon = -999999999)
  expect_equal(ncol(result), 3)
})

test_that("Expect message", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(ovc_get_xml = function(url, verbose = FALSE) {
    if (verbose) {
      cli::cli_alert_info("Requesting {.url {url}}.")
      cli::cli_alert_success("Request succeeded.")
    }

    list(
      consulta_coordenadas_distancias = list(
        coordenadas_distancias = list(
          coordd = list(
            geo = list(
              xcen = "-5.671420",
              ycen = "40.963200",
              srs = "EPSG:4326"
            ),
            lpcd = list(
              list(
                pc = list(pc1 = "9872023", pc2 = "VH5797S"),
                ldt = "Mocked address",
                dt = list(loine = list(cp = "37", cm = "274"))
              )
            )
          )
        )
      )
    )
  })

  expect_snapshot(
    df <- catr_ovc_get_rccoor_distancia(
      lat = 40.963200,
      lon = -5.671420,
      verbose = TRUE
    )
  )
})

test_that("RCCOOR distance can call the real API", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_rccoor_distancia(
    lat = 40.963200,
    lon = -5.671420
  )
  expect_s3_class(result, "tbl")
})
