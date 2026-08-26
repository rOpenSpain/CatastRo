test_that("catr_ovc_get_cpmrc() returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(fend <- catr_ovc_get_cpmrc("9872023VH5797S"))
  expect_null(fend)
})

test_that("catr_ovc_get_cpmrc() returns NULL after an HTTP 404", {
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  expect_snapshot(fend <- catr_ovc_get_cpmrc("9872023VH5797S"))
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})

test_that("catr_ovc_get_cpmrc() rejects an unsupported SRS", {
  expect_snapshot(
    error = TRUE,
    df <- catr_ovc_get_cpmrc(rc = "s", srs = "abcd")
  )
})

test_that("catr_ovc_get_cpmrc() accepts all supported arguments", {
  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas = list(
        coordenadas = list(
          coord = list(
            geo = list(xcen = "450000", ycen = "4300000", srs = "EPSG:4230"),
            pc = list(pc1 = "13077A01800039", pc2 = "0000AB"),
            ldt = "SANTA CRUZ DE MUDELA"
          )
        )
      )
    )
  })

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

test_that("catr_ovc_get_cpmrc() accepts a reference and SRS", {
  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas = list(
        coordenadas = list(
          coord = list(
            geo = list(xcen = "1.25", ycen = "2.50", srs = "EPSG:4230"),
            pc = list(pc1 = "9872023", pc2 = "VH5797S"),
            ldt = "Mocked address"
          )
        )
      )
    )
  })

  result <- catr_ovc_get_cpmrc("9872023VH5797S", "4230")
  expect_type(result$xcoord, "double")
  expect_type(result$ycoord, "double")
})

test_that("catr_ovc_get_cpmrc() accepts only a reference", {
  local_mocked_bindings(ovc_get_xml = function(url, verbose = FALSE) {
    if (verbose) {
      cli::cli_alert_info("Requesting {.url {url}}.")
      cli::cli_alert_success("Request succeeded.")
    }
    list(
      consulta_coordenadas = list(
        coordenadas = list(
          coord = list(
            geo = list(xcen = "1.25", ycen = "2.50", srs = "EPSG:4326"),
            pc = list(pc1 = "9872023", pc2 = "VH5797S"),
            ldt = "Mocked address"
          )
        )
      )
    )
  })

  expect_snapshot(df <- catr_ovc_get_cpmrc("9872023VH5797S", verbose = TRUE))

  result <- catr_ovc_get_cpmrc(rc = "13077A01800039")
  expect_s3_class(result, "tbl")
})


test_that("catr_ovc_get_cpmrc() requires a province and municipality", {
  local_mocked_bindings(ovc_get_xml = function(...) {
    list(
      consulta_coordenadas = list(
        lerr = list(code = "11", message = "LA PROVINCIA ES OBLIGATORIA")
      )
    )
  })

  expect_snapshot(
    nnn <- catr_ovc_get_cpmrc(
      rc = "13077A01800039",
      srs = "4230",
      municipality = "SANTA CRUZ DE MUDELA"
    )
  )

  expect_equal(ncol(nnn), 2)
})

test_that("catr_ovc_get_cpmrc() can call the real API", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  result <- catr_ovc_get_cpmrc("9872023VH5797S")
  expect_s3_class(result, "tbl")
})
