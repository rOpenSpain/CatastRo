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
    fend <- catr_atom_get_parcels("LABAJOS", cache_dir = cdir)
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
    fend <- catr_atom_get_parcels("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
  unlink(cdir, recursive = TRUE, force = TRUE)
  # Otherwise work
  expect_silent(
    fend <- catr_atom_get_parcels("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_gt(nrow(fend), 20)

  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
})
test_that("ATOM parcels", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "test_cp")
  unlink(cdir, force = TRUE, recursive = TRUE)
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
  expect_message(
    catr_atom_get_parcels(
      "Melque",
      to = "XXX",
      verbose = TRUE,
      cache_dir = cdir
    ),
    'Ignoring `to` argument. No results found with pattern "Melque" in "XXX".'
  )
  expect_s3_class(s, "sf")

  # Check other options
  me_cp <- catr_atom_get_parcels(
    "Melque",
    to = "Segovia",
    cache_dir = cdir
  )

  me_cpzone <- catr_atom_get_parcels(
    "Melque",
    to = "Segovia",
    what = "zoning",
    cache_dir = cdir
  )

  expect_s3_class(me_cp, "sf")
  expect_s3_class(me_cpzone, "sf")

  expect_gt(nrow(me_cp), nrow(me_cpzone))

  unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("ATOM Encoding issue", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "test_cp2")
  unlink(cdir, force = TRUE, recursive = TRUE)

  expect_silent(catr_atom_get_parcels("23078", cache_dir = cdir))
  expect_silent(catr_atom_get_parcels("03050", cache_dir = cdir))
  expect_silent(catr_atom_get_parcels("23051", cache_dir = cdir))
  unlink(cdir, force = TRUE, recursive = TRUE)
})

test_that("Test 404 single", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "testthat_ex2to2bu")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  all <- catr_atom_get_parcels_db_all(cache_dir = cdir)
  all <- catr_atom_get_parcels_db_to("Segovia", cache_dir = cdir)

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  expect_snapshot(
    fend <- catr_atom_get_parcels(
      "Melque",
      to = "Segovia",
      cache_dir = cdir
    )
  )
  expect_null(fend)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
  unlink(cdir, recursive = TRUE, force = TRUE)
})
