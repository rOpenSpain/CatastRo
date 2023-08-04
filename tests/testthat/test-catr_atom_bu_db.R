test_that("Test atom bu", {
  skip_on_cran()
  skip_if_offline()

  expect_message(
    catr_atom_get_buildings_db_all(
      verbose = TRUE,
      cache_dir = tempdir()
    )
  )
  expect_invisible(
    catr_atom_get_buildings_db_to(
      to = "aaaana",
      cache_dir = tempdir()
    )
  )
  expect_message(
    catr_atom_get_buildings_db_to(to = "aaaana", cache_dir = tempdir()),
    "No Territorial office found for aaaana"
  )
  expect_true(is.na(
    catr_atom_get_buildings_db_to(
      to = "aaaana",
      cache_dir = tempdir()
    )
  ))
  expect_message(
    catr_atom_get_buildings_db_to(
      to = "Melilla", verbose = TRUE,
      cache_dir = tempdir()
    )
  )
  expect_s3_class(
    catr_atom_get_buildings_db_to(to = "Melilla", cache_dir = tempdir()),
    "tbl"
  )
})
