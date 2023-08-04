test_that("Test search", {
  skip_on_cran()
  skip_if_offline()

  a <- catr_atom_search_munic("Mad")
  expect_gt(nrow(a), 1)

  # Try with to
  b <- catr_atom_search_munic("Mad", to = 3)

  expect_gt(nrow(a), nrow(b))


  # Try with no result

  c <- catr_atom_search_munic("XXX")
  expect_true(is.na(c))

  expect_message(
    catr_atom_search_munic("Melque",
      to = "XXX",
      verbose = TRUE
    ), "Ignoring 'to' parameter. No results for XXX"
  )

  d <- catr_atom_search_munic("Mel",
    to = "XXX"
  )

  expect_gt(nrow(d), 5)

  expect_message(
    catr_atom_search_munic("Melilla", to = "Burgos"),
    "No Municipality found for Melilla Burgos."
  )
})
