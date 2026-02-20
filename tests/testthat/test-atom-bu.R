test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- file.path(tempdir(), "testthat_ex1")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  expect_snapshot(
    fend <- catr_atom_get_buildings("LABAJOS", cache_dir = cdir)
  )
  expect_null(fend)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
  unlink(cdir, recursive = TRUE, force = TRUE)
})

test_that("Test 404 all", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "testthat_ex2")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  expect_snapshot(
    fend <- catr_atom_get_buildings("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
  unlink(cdir, recursive = TRUE, force = TRUE)
  # Otherwise work
  expect_silent(
    fend <- catr_atom_get_buildings("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_gt(nrow(fend), 20)

  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
})
test_that("ATOM Buildings", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "test_bu")
  unlink(cdir, force = TRUE, recursive = TRUE)
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
  expect_message(
    catr_atom_get_buildings(
      "Melque",
      to = "XXX",
      verbose = TRUE,
      cache_dir = cdir
    ),
    'Ignoring `to` argument. No results found with pattern "Melque" in "XXX".'
  )
  expect_s3_class(s, "sf")

  # Check other options
  me_bu <- catr_atom_get_buildings(
    "Melque",
    to = "Segovia",
    cache_dir = cdir
  )

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

  unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("ATOM Encoding issue", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "test_bu2")
  unlink(cdir, force = TRUE, recursive = TRUE)

  expect_silent(catr_atom_get_buildings("23078", cache_dir = cdir))
  expect_silent(catr_atom_get_buildings("03050", cache_dir = cdir))
  expect_silent(catr_atom_get_buildings("23051", cache_dir = cdir))
  unlink(cdir, force = TRUE, recursive = TRUE)
})
