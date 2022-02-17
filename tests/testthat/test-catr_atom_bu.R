test_that("ATOM Buildings", {
  expect_message(catr_atom_bu("xyxghx"))
  expect_error(catr_atom_bu("Melque", what = "aa"))

  skip_on_cran()
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

test_that("ATOM Encoding issue", {
  skip_on_cran()

  expect_silent(catr_atom_bu("23078"))
  expect_silent(catr_atom_bu("03050"))
  expect_silent(catr_atom_bu("23051"))
})
