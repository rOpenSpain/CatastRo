test_that("ATOM feeds are read from local XML files", {
  top_xml <- paste0(
    "<feed>",
    "<entry>",
    "<title>Segovia</title>",
    "<updated>2024-01-01T00:00:00Z</updated>",
    "<link href=\"https://example.test/segovia.xml\"/>",
    "<content><div><div>40112-MELQUE DE CERCOS</div></div></content>",
    "</entry>",
    "<entry>",
    "<title>Madrid</title>",
    "<updated>2024-01-01T00:00:00Z</updated>",
    "<link href=\"https://example.test/madrid.xml\"/>",
    "<content><div><div>28079-MADRID</div></div></content>",
    "</entry>",
    "</feed>"
  )
  top_file <- withr::local_tempfile(fileext = ".xml")
  writeLines(top_xml, top_file)

  top <- catr_read_atom(top_file, top = TRUE)

  expect_equal(top$title, c("Segovia", "Madrid"))
  expect_equal(top$value, c("40112-MELQUE DE CERCOS", "28079-MADRID"))

  to_xml <- paste0(
    "<feed>",
    "<entry>",
    "<title>40112-MELQUE DE CERCOS</title>",
    "<updated>2024-01-01T00:00:00Z</updated>",
    "<link href=\"https://example.test/melque.zip\"/>",
    "</entry>",
    "</feed>"
  )
  to_file <- withr::local_tempfile(fileext = ".xml")
  writeLines(to_xml, to_file)

  to <- catr_read_atom(to_file, top = FALSE)

  expect_equal(to$title, "40112-MELQUE DE CERCOS")
  expect_equal(to$url, "https://example.test/melque.zip")
})

test_that("ATOM database readers can use mocked downloads", {
  top_file <- withr::local_tempfile(fileext = ".xml")
  writeLines(
    paste0(
      "<feed>",
      "<entry>",
      "<title>Segovia</title>",
      "<updated>2024-01-01T00:00:00Z</updated>",
      "<link href=\"https://example.test/segovia.xml\"/>",
      "<content><div><div>40112-MELQUE DE CERCOS</div></div></content>",
      "</entry>",
      "</feed>"
    ),
    top_file
  )

  to_file <- withr::local_tempfile(fileext = ".xml")
  writeLines(
    paste0(
      "<feed>",
      "<entry>",
      "<title>40112-MELQUE DE CERCOS</title>",
      "<updated>2024-01-01T00:00:00Z</updated>",
      "<link href=\"https://example.test/melque.zip\"/>",
      "</entry>",
      "</feed>"
    ),
    to_file
  )

  local_mocked_bindings(download_url = function(url, ...) {
    if (identical(url, "https://example.test/top.xml")) {
      return(top_file)
    }
    to_file
  })

  all <- catr_atom_read_db_all("https://example.test/top.xml")
  expect_named(all, c("territorial_office", "url", "munic", "date"))
  expect_equal(all$territorial_office, "Segovia")

  to <- catr_atom_read_db_to(
    "Segovia",
    all_fn = function(...) all,
    verbose = TRUE
  )
  expect_named(to, c("munic", "url", "date"))
  expect_equal(to$munic, "40112-MELQUE DE CERCOS")
})

test_that("ATOM readers handle mocked failures and ambiguous matches", {
  local_mocked_bindings(download_url = mock_atom_download_null)

  expect_null(catr_atom_read_db_all("https://example.test/top.xml"))
  expect_null(catr_atom_read_db_to("Segovia", all_fn = function(...) NULL))

  local_mocked_bindings(download_url = function(...) {
    withr::local_tempfile(fileext = ".xml")
  })

  all <- data.frame(
    territorial_office = c("Valencia", "Palencia", "Melilla"),
    url = c(
      "https://example.test/val.xml",
      "https://example.test/pal.xml",
      "https://example.test/mel.xml"
    ),
    munic = c("46001-A", "34001-B", "52001-C")
  )

  expect_snapshot(
    result <- catr_atom_read_db_to("No match", all_fn = function(...) all)
  )
  expect_null(result)

  expect_snapshot(
    result <- catr_atom_select_munic(
      all = mock_atom_all(),
      munic = "40",
      to = "Segovia",
      db_all_call = "catr_atom_get_address_db_all",
      verbose = TRUE
    )
  )
  expect_equal(result$munic, "40112-MELQUE DE CERCOS")
})

test_that("ATOM municipality URLs are encoded", {
  municurls <- data.frame(
    munic = "40112-MELQUE DE CERCOS",
    url = "https://example.test/MELQUE DE CERCOS.zip"
  )

  expect_equal(
    catr_atom_get_munic_url(municurls, "40112-MELQUE DE CERCOS"),
    "https://example.test/MELQUE%20DE%20CERCOS.zip"
  )
})
