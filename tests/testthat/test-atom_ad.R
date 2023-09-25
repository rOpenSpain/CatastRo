test_that("ATOM Addresses", {
  skip_on_cran()
  skip_if_offline()
  expect_message(catr_atom_get_address("xyxghx"))


  expect_message(catr_atom_get_address("xyxghx"))

  s <- catr_atom_get_address("Melque",
    to = "Segovia",
    verbose = TRUE
  )
  expect_s3_class(s, "sf")
  expect_message(
    catr_atom_get_address("Melque",
      to = "XXX",
      verbose = TRUE
    ), "Ignoring 'to' parameter. No results for XXX"
  )
  expect_s3_class(s, "sf")
})


test_that("ATOM Encoding issue", {
  skip_on_cran()
  skip_if_offline()

  s <- catr_atom_get_address("12028")
  expect_s3_class(s, "sf")

  expect_true("tfname_text" %in% names(s))

  expect_silent(catr_atom_get_address("23078"))
  expect_silent(catr_atom_get_address("03050"))
  expect_silent(catr_atom_get_address("23051"))
})
