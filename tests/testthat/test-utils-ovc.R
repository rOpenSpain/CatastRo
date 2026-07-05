test_that("OVC URL and SRS helpers work", {
  skip_on_cran()

  expect_identical(
    ovc_base_url("OVCCallejero/ConsultaProvincia"),
    "http://ovc.catastro.meh.es/ovcservweb/OVCCallejero/ConsultaProvincia"
  )
  expect_identical(ovc_validate_srs(4326), "EPSG:4326")
})

test_that("OVC XML responses are parsed", {
  skip_on_cran()

  local_mocked_bindings(get_request_body = function(url, verbose = FALSE) {
    expect_identical(url, "http://example.test/ovc.xml")
    expect_true(verbose)

    httr2::response(
      status_code = 200,
      headers = list("content-type" = "application/xml"),
      body = charToRaw("<root><item><x>1</x></item></root>")
    )
  })

  parsed <- ovc_get_xml("http://example.test/ovc.xml", verbose = TRUE)
  expect_identical(parsed$root$item$x[[1]], "1")
})

test_that("OVC XML response failures return NULL", {
  skip_on_cran()

  local_mocked_bindings(get_request_body = function(url, verbose = FALSE) {
    expect_identical(url, "http://example.test/empty.xml")
    expect_false(verbose)
    NULL
  })

  expect_null(ovc_get_xml("http://example.test/empty.xml"))
})

test_that("OVC XML nodes are converted to tibbles", {
  skip_on_cran()

  expect_equal(
    ovc_as_tibble_row(list(a = "one", b = list(c = "two"))),
    tibble::tibble(a = "one", b.c = "two")
  )

  expect_equal(
    ovc_as_tibble_rows(list(
      list(a = "one", b = "two"),
      list(a = "three", b = "four")
    )),
    tibble::tibble(a = c("one", "three"), b = c("two", "four"))
  )
})

test_that("OVC error helpers detect and report API errors", {
  skip_on_cran()

  err <- list(lerr = list(code = "1", message = "Bad request"))

  expect_true(ovc_has_error(err))
  expect_false(ovc_has_error(list(ok = TRUE)))
  expect_message(ovc_report_error(err), "OVC service error 1: Bad request")
})

test_that("OVC response fields are normalized", {
  skip_on_cran()

  expect_equal(
    ovc_ref_address(tibble::tibble(
      pc.pc1 = "1234567",
      pc.pc2 = "AB1234C",
      ldt = "Calle Falsa 123"
    )),
    tibble::tibble(refcat = "1234567AB1234C", address = "Calle Falsa 123")
  )

  coords <- ovc_numeric_coords(tibble::tibble(
    geo.xcen = "1.25",
    geo.ycen = "2.50",
    name = "parcel"
  ))

  expect_type(coords$geo.xcen, "double")
  expect_type(coords$geo.ycen, "double")
  expect_equal(coords$geo.xcen, 1.25)
  expect_equal(coords$geo.ycen, 2.50)
  expect_identical(coords$name, "parcel")
})
