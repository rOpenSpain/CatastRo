test_that("ATOM Cadastral Parcels", {
  skip_on_cran()
  expect_message(catr_atom_get_parcels("xyxghx"))
  expect_error(catr_atom_get_parcels("Melque", what = "aa"))

  s <- catr_atom_get_parcels("Melque",
    to = "Segovia",
    verbose = TRUE
  )
  expect_s3_class(s, "sf")
  expect_message(catr_atom_get_parcels("Melque",
    to = "XXX",
    what = "zoning",
    verbose = TRUE
  ), "Ignoring 'to' parameter. No results for XXX")
  expect_s3_class(s, "sf")
})

test_that("ATOM Encoding issue", {
  skip_on_cran()

  s <- catr_atom_get_parcels("12028")
  expect_s3_class(s, "sf")

  expect_silent(catr_atom_get_parcels("23078"))
  expect_silent(catr_atom_get_parcels("03050"))
  expect_silent(catr_atom_get_parcels("23051"))
})
