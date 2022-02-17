test_that("ATOM Addresses", {
  expect_message(catr_atom_ad("xyxghx"))

  skip_on_cran()

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


test_that("ATOM Encoding issue", {
  skip_on_cran()

  s <- catr_atom_ad("12028")
  expect_s3_class(s, "sf")

  expect_silent(catr_atom_ad("23078"))
  expect_silent(catr_atom_ad("03050"))
  expect_silent(catr_atom_ad("23051"))
})
