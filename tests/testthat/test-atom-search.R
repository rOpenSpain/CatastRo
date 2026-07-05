test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(fend <- catr_atom_search_munic("LABAJOS", cache_dir = cdir))
  expect_null(fend)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Test 404 all", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "testthat_ex2")

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
})

test_that("Test search", {
  skip_on_cran()
  skip_if_offline()
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")
  a <- catr_atom_search_munic("Mad", cache_dir = cdir)
  expect_gt(nrow(a), 1)

  # Try with to
  b <- catr_atom_search_munic("Mad", to = 3, cache_dir = cdir)

  expect_gt(nrow(a), nrow(b))

  # Try with no result

  expect_snapshot(c <- catr_atom_search_munic("XXX", cache_dir = cdir))
  expect_null(c)

  expect_message(
    d <- catr_atom_search_munic(
      "Melque",
      to = "XXX",
      verbose = TRUE,
      cache_dir = cdir
    ),
    "Ignoring `to` because no territorial office matched"
  )

  d <- catr_atom_search_munic("Mel", to = "XXX", cache_dir = cdir)

  expect_gt(nrow(d), 5)

  expect_snapshot(
    ff <- catr_atom_search_munic("Melilla", to = "Burgos", cache_dir = cdir)
  )

  expect_null(ff)
})

test_that("Deprecations", {
  skip_on_cran()
  skip_if_offline()
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")
  expect_snapshot(
    a <- catr_atom_search_munic("Mad", cache_dir = cdir, cache = TRUE)
  )
})
