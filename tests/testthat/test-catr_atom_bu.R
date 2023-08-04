test_that("ATOM Buildings", {
  skip_on_cran()
  skip_if_offline()

  expect_message(catr_atom_get_buildings("xyxghx"))
  expect_error(catr_atom_get_buildings("Melque", what = "aa"))

  s <- catr_atom_get_buildings("Melque",
    to = "Segovia",
    verbose = TRUE
  )
  expect_s3_class(s, "sf")
  expect_message(
  catr_atom_get_buildings("Melque",
    to = "XXX",
    what = "buildingpart",
    verbose = TRUE
  ), "Ignoring 'to' parameter. No results for XXX")
  expect_s3_class(s, "sf")

  expect_message(catr_atom_get_buildings("Melque",
    to = "XXX",
    what = "other",
    verbose = TRUE
  ), "Ignoring 'to' parameter. No results for XXX")
})

test_that("ATOM Encoding issue", {
  skip_on_cran()
  skip_if_offline()

  expect_silent(catr_atom_get_buildings("23078"))
  expect_silent(catr_atom_get_buildings("03050"))
  expect_silent(catr_atom_get_buildings("23051"))
})
