test_that("catr_atom_get_buildings() returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(fend <- catr_atom_get_buildings("LABAJOS", cache_dir = cdir))
  expect_null(fend)
})

test_that("catr_atom_get_buildings() handles a database HTTP 404", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  expect_snapshot(
    fend <- catr_atom_get_buildings("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)
})
test_that("catr_atom_get_buildings() returns spatial data for a municipality", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "test_bu")
  expect_snapshot(catr_atom_get_buildings("xyxghx", cache_dir = cdir))

  expect_message(
    s <- catr_atom_get_buildings(
      "Nava",
      to = "Segovia",
      verbose = TRUE,
      cache_dir = cdir
    )
  )

  # Deprecations
  expect_snapshot(
    s <- catr_atom_get_buildings(
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
    catr_atom_get_buildings(
      "Melque",
      to = "XXX",
      verbose = TRUE,
      cache_dir = cdir
    ),
    "Ignoring `to` because no territorial office matched"
  )
  expect_s3_class(s, "sf")

  # Check other options
  me_bu <- catr_atom_get_buildings("Melque", to = "Segovia", cache_dir = cdir)

  me_bupart <- catr_atom_get_buildings(
    "Melque",
    to = "Segovia",
    what = "buildingpart",
    cache_dir = cdir
  )

  me_other <- catr_atom_get_buildings(
    "Melque",
    to = "Segovia",
    what = "other",
    cache_dir = cdir
  )

  expect_s3_class(me_bu, "sf")
  expect_s3_class(me_bupart, "sf")
  expect_s3_class(me_other, "sf")

  expect_gt(nrow(me_bupart), nrow(me_bu))
  expect_gt(nrow(me_bu), nrow(me_other))
})

test_that("catr_atom_get_buildings() reads accented source data", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "test_bu2")

  expect_silent(s1 <- catr_atom_get_buildings("23078", cache_dir = cdir))
  expect_silent(s2 <- catr_atom_get_buildings("03050", cache_dir = cdir))
  expect_silent(s3 <- catr_atom_get_buildings("23051", cache_dir = cdir))
  expect_s3_class(s1, "sf")
  expect_s3_class(s2, "sf")
  expect_s3_class(s3, "sf")
})

test_that("catr_atom_get_buildings() handles a download HTTP 404", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "testthat_ex2to2bu")

  invisible(catr_atom_get_buildings_db_all(cache_dir = cdir))
  invisible(catr_atom_get_buildings_db_to("Segovia", cache_dir = cdir))

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  expect_snapshot(
    fend <- catr_atom_get_buildings("Melque", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})
