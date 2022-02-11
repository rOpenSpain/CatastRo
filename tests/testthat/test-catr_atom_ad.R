test_that("ATOM Addresses", {
  expect_message(catr_atom_ad("xyxghx"))

  skip_on_cran()
  skip_on_ci()
  skip_on_covr()

  s <- catr_atom_ad("Melque",
    to = "Segovia",
    verbose = TRUE
  )
  expect_s3_class(s, "sf")
  expect_message(catr_atom_ad("Melque",
    to = "XXX",
    verbose = TRUE
  ), "Ignoring 'to' parameter. No results for XXX")
  expect_s3_class(s, "sf")
})
