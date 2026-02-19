test_that("ATOM Addresses", {
  skip_on_cran()
  skip_if_offline()
  skip_on_os("mac")

  cdir <- file.path(tempdir(), "test_ad")
  unlink(cdir, force = TRUE, recursive = TRUE)
  expect_snapshot(catr_atom_get_address("xyxghx", cache_dir = cdir))

  expect_message(
    s <- catr_atom_get_address(
      "Segov",
      to = "Segovia",
      verbose = TRUE,
      cache_dir = cdir
    )
  )

  # Deprecations
  expect_snapshot(
    s <- catr_atom_get_address(
      "Melque",
      to = "Segovia",
      cache = FALSE,
      cache_dir = cdir
    )
  )

  expect_s3_class(s, "sf")
  expect_message(
    catr_atom_get_address(
      "Melque",
      to = "XXX",
      verbose = TRUE,
      cache_dir = cdir
    ),
    'Ignoring `to` argument. No results found with pattern "Melque" in "XXX".'
  )
  expect_s3_class(s, "sf")
  unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("ATOM Encoding issue", {
  skip_on_cran()
  skip_if_offline()
  skip_on_os("mac")

  cdir <- file.path(tempdir(), "test_ad2")
  unlink(cdir, force = TRUE, recursive = TRUE)

  s <- catr_atom_get_address("12028", cache_dir = cdir)
  expect_s3_class(s, "sf")

  expect_true("tfname_text" %in% names(s))

  expect_silent(catr_atom_get_address("23078", cache_dir = cdir))
  expect_silent(catr_atom_get_address("03050", cache_dir = cdir))
  expect_silent(catr_atom_get_address("23051", cache_dir = cdir))
  unlink(cdir, force = TRUE, recursive = TRUE)
})
