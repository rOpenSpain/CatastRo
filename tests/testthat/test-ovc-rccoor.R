test_that("catr_ovc_get_rccoor() returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(
    fend <- catr_ovc_get_rccoor(lat = 40.963200, lon = -5.671420, srs = 4326)
  )
  expect_null(fend)
})

test_that("catr_ovc_get_rccoor() returns NULL after an HTTP 404", {
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  expect_snapshot(
    fend <- catr_ovc_get_rccoor(lat = 40.963200, lon = -5.671420, srs = 4326)
  )
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("catr_ovc_get_rccoor() rejects an unsupported SRS", {
  expect_snapshot(
    error = TRUE,
    df <- catr_ovc_get_rccoor(lat = 40.963200, lon = -5.671420, "abcd")
  )
})

test_that("catr_ovc_get_rccoor() returns a tibble with an explicit SRS", {
  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas = list(
        coordenadas = list(
          coord = list(
            geo = list(
              xcen = "38.6196566583596",
              ycen = "-3.45624183836806",
              srs = "EPSG:4230"
            ),
            pc = list(pc1 = "13077A01800039", pc2 = "0000AB"),
            ldt = "Mocked address"
          )
        )
      )
    )
  })

  result <- catr_ovc_get_rccoor(
    lat = 38.6196566583596,
    lon = -3.45624183836806,
    srs = "4230"
  )
  expect_s3_class(result, "tbl")
  expect_type(result$geo.xcen, "double")
  expect_type(result$geo.ycen, "double")
})

test_that("catr_ovc_get_rccoor() returns a tibble without an explicit SRS", {
  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas = list(
        coordenadas = list(
          coord = list(
            geo = list(
              xcen = "38.6196566583596",
              ycen = "-3.45624183836806",
              srs = "EPSG:4326"
            ),
            pc = list(pc1 = "13077A01800039", pc2 = "0000AB"),
            ldt = "Mocked address"
          )
        )
      )
    )
  })

  result <- catr_ovc_get_rccoor(lat = 38.6196566583596, lon = -3.45624183836806)
  expect_s3_class(result, "tbl")
})

test_that("catr_ovc_get_rccoor() returns standard fields without an SRS", {
  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas = list(
        coordenadas = list(
          coord = list(
            geo = list(
              xcen = "38.6196566583596",
              ycen = "-3.45624183836806",
              srs = "EPSG:4326"
            ),
            pc = list(pc1 = "13077A01800039", pc2 = "0000AB"),
            ldt = "Mocked address"
          )
        )
      )
    )
  })

  result <- catr_ovc_get_rccoor(lat = 38.6196566583596, lon = -3.45624183836806)
  expect_type(result$address, "character")
  expect_type(result$refcat, "character")
})

test_that("catr_ovc_get_rccoor() returns standard fields with an SRS", {
  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas = list(
        coordenadas = list(
          coord = list(
            geo = list(
              xcen = "38.6196566583596",
              ycen = "-3.45624183836806",
              srs = "EPSG:4230"
            ),
            pc = list(pc1 = "13077A01800039", pc2 = "0000AB"),
            ldt = "Mocked address"
          )
        )
      )
    )
  })

  result <- catr_ovc_get_rccoor(
    lat = 38.6196566583596,
    lon = -3.45624183836806,
    srs = "4230"
  )
  expect_type(result$address, "character")
  expect_type(result$refcat, "character")
})

test_that("catr_ovc_get_rccoor() returns three columns without a reference", {
  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas = list(
        lerr = list(
          code = "16",
          message = "PARA ESAS COORDENADAS NO HAY REFERENCIA DISPONIBLE"
        )
      )
    )
  })

  result <- catr_ovc_get_rccoor(lat = 99999999, lon = -999999999)
  expect_equal(ncol(result), 3)
})

test_that("catr_ovc_get_rccoor() handles imprecise coordinates", {
  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas = list(
        lerr = list(
          code = "16",
          message = "PARA ESAS COORDENADAS NO HAY REFERENCIA DISPONIBLE"
        )
      )
    )
  })

  result <- catr_ovc_get_rccoor(lat = 40.963200, lon = -5.671420, srs = "4326")
  expect_equal(ncol(result), 3)
})

test_that("catr_ovc_get_rccoor() reports requests when verbose", {
  local_mocked_bindings(ovc_get_xml = function(url, verbose = FALSE) {
    if (verbose) {
      cli::cli_alert_info("Requesting {.url {url}}.")
      cli::cli_alert_success("Request succeeded.")
    }

    list(
      consulta_coordenadas = list(
        lerr = list(
          code = "16",
          message = "PARA ESAS COORDENADAS NO HAY REFERENCIA DISPONIBLE"
        )
      )
    )
  })

  expect_snapshot(
    df <- catr_ovc_get_rccoor(
      lat = 40.963200,
      lon = -5.671420,
      srs = "4326",
      verbose = TRUE
    )
  )
})

test_that("catr_ovc_get_rccoor() can call the real API", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_rccoor(lat = 38.6196566583596, lon = -3.45624183836806)
  expect_s3_class(result, "tbl")
})
