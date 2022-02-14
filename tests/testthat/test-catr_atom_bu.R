test_that("ATOM Buildings", {
  expect_message(catr_atom_bu("xyxghx"))
  expect_error(catr_atom_bu("Melque", what = "aa"))

  skip_on_cran()
  skip_on_ci()
  skip_on_covr()
  s <- catr_atom_bu("Melque",
    to = "Segovia",
    verbose = TRUE
  )
  expect_s3_class(s, "sf")
  expect_message(catr_atom_bu("Melque",
    to = "XXX",
    what = "buildingpart",
    verbose = TRUE
  ), "Ignoring 'to' parameter. No results for XXX")
  expect_s3_class(s, "sf")

  expect_message(catr_atom_bu("Melque",
    to = "XXX",
    what = "other",
    verbose = TRUE
  ), "Ignoring 'to' parameter. No results for XXX")
})
