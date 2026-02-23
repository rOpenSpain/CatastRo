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
    fend <- catr_atom_search_munic("LABAJOS", cache_dir = cdir)
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
    fend <- catr_atom_search_munic("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
  unlink(cdir, recursive = TRUE, force = TRUE)
  # Otherwise work
  expect_silent(
    fend <- catr_atom_search_munic("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_shape(fend, dim = c(1, 3))

  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
})


test_that("Test search", {
  skip_on_cran()
  skip_if_offline()
  cdir <- file.path(tempdir(), "testthat_ex2")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  a <- catr_atom_search_munic("Mad", cache_dir = cdir)
  expect_gt(nrow(a), 1)

  # Try with to
  b <- catr_atom_search_munic("Mad", to = 3, cache_dir = cdir)

  expect_gt(nrow(a), nrow(b))

  # Try with no result

  expect_snapshot(
    c <- catr_atom_search_munic("XXX", cache_dir = cdir)
  )
  expect_null(c)

  expect_message(
    d <- catr_atom_search_munic(
      "Melque",
      to = "XXX",
      verbose = TRUE,
      cache_dir = cdir
    ),
    'Ignoring `to` argument. No results found with pattern "Melque" in "XXX".'
  )

  d <- catr_atom_search_munic("Mel", to = "XXX", cache_dir = cdir)

  expect_gt(nrow(d), 5)

  expect_snapshot(
    ff <- catr_atom_search_munic("Melilla", to = "Burgos", cache_dir = cdir)
  )

  expect_null(ff)
  unlink(cdir)
})

test_that("Deprecations", {
  skip_on_cran()
  skip_if_offline()
  cdir <- file.path(tempdir(), "testthat_ex2")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  expect_snapshot(
    a <- catr_atom_search_munic("Mad", cache_dir = cdir, cache = TRUE)
  )
  unlink(cdir, recursive = TRUE, force = TRUE)
})
