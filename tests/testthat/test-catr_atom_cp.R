test_that("ATOM Cadastral Parcels", {
  expect_message(catr_atom_cp("xyxghx"))
  expect_error(catr_atom_cp("Melque", what = "aa"))

  skip_on_cran()
  s <- catr_atom_cp("Melque",
    to = "Segovia",
    verbose = TRUE
  )
  expect_s3_class(s, "sf")
  expect_message(catr_atom_cp("Melque",
    to = "XXX",
    what = "zoning",
    verbose = TRUE
  ), "Ignoring 'to' parameter. No results for XXX")
  expect_s3_class(s, "sf")
})

test_that("ATOM Encoding issue", {
  skip_on_cran()

  s <- catr_atom_cp("12028")
  expect_s3_class(s, "sf")

  s <- catr_atom_cp("23044")
  expect_s3_class(s, "sf")

  s <- catr_atom_cp("03050")
  expect_s3_class(s, "sf")
})
