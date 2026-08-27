test_that("catr_atom_get_parcels() returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(fend <- catr_atom_get_parcels("LABAJOS", cache_dir = cdir))
  expect_null(fend)
})

test_that("catr_atom_get_parcels() handles a database HTTP 404", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  expect_snapshot(
    fend <- catr_atom_get_parcels("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)
})
test_that("catr_atom_get_parcels() returns spatial data for a municipality", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "test_cp")
  expect_snapshot(catr_atom_get_parcels("xyxghx", cache_dir = cdir))

  expect_message(
    s <- catr_atom_get_parcels(
      "Nava",
      to = "Segovia",
      verbose = TRUE,
      cache_dir = cdir
    )
  )

  # Deprecations
  expect_snapshot(
    s <- catr_atom_get_parcels(
      "Melque",
      to = "Segovia",
      cache = FALSE,
      cache_dir = cdir
    )
  )

  expect_s3_class(s, "sf")
  expect_false(is.na(sf::st_crs(s)))
  expect_false(any(sf::st_is_empty(s)))
  expect_message(
    catr_atom_get_parcels(
      "Melque",
      to = "XXX",
      verbose = TRUE,
      cache_dir = cdir
    ),
    "Ignoring `to` because no territorial office matched"
  )
  expect_s3_class(s, "sf")

  # Check other options
  me_cp <- catr_atom_get_parcels("Melque", to = "Segovia", cache_dir = cdir)

  me_cpzone <- catr_atom_get_parcels(
    "Melque",
    to = "Segovia",
    what = "zoning",
    cache_dir = cdir
  )

  expect_s3_class(me_cp, "sf")
  expect_s3_class(me_cpzone, "sf")

  expect_gt(nrow(me_cp), nrow(me_cpzone))
})

test_that("catr_atom_get_parcels() reads accented source data", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "test_cp2")

  expect_silent(s1 <- catr_atom_get_parcels("23078", cache_dir = cdir))
  expect_silent(s2 <- catr_atom_get_parcels("03050", cache_dir = cdir))
  expect_silent(s3 <- catr_atom_get_parcels("23051", cache_dir = cdir))
  expect_s3_class(s1, "sf")
  expect_s3_class(s2, "sf")
  expect_s3_class(s3, "sf")
})

test_that("catr_atom_get_parcels() handles a download HTTP 404", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "testthat_ex2to2bu")

  invisible(catr_atom_get_parcels_db_all(cache_dir = cdir))
  invisible(catr_atom_get_parcels_db_to("Segovia", cache_dir = cdir))

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  expect_snapshot(
    fend <- catr_atom_get_parcels("Melque", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})
