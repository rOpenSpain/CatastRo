test_that("municipality ATOM search can be mocked", {
  local_mocked_bindings(catr_atom_get_address_db_all = mock_atom_all)

  result <- catr_atom_search_munic("Melque", to = "Segovia")

  expect_equal(result$territorial_office, "Segovia")
  expect_equal(result$catrcode, "40112")
})

test_that("municipality ATOM search handles mocked misses", {
  local_mocked_bindings(catr_atom_get_address_db_all = mock_atom_all)

  expect_snapshot(result <- catr_atom_search_munic("No match"))
  expect_null(result)

  expect_snapshot(
    result <- catr_atom_search_munic("Melque", to = "No office", verbose = TRUE)
  )
  expect_equal(result$catrcode, "40112")

  expect_snapshot(result <- catr_atom_search_munic("Madrid", to = "Segovia"))
  expect_null(result)
})

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
  skip_on_ci()

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
  skip_on_ci()
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")
  a <- catr_atom_search_munic("Mad", cache_dir = cdir)
  expect_gt(nrow(a), 1)

  # Try with to
  b <- catr_atom_search_munic("Mad", to = 3, cache_dir = cdir)

  expect_s3_class(a, "tbl_df")
  expect_gt(nrow(a), nrow(b))

  # Try with no result

  expect_snapshot(c <- catr_atom_search_munic("XXX", cache_dir = cdir))
  expect_null(c)

  expect_snapshot(
    d <- catr_atom_search_munic(
      "Melque",
      to = "XXX",
      verbose = TRUE,
      cache_dir = cdir
    )
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
  skip_on_ci()
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")
  expect_snapshot(
    a <- catr_atom_search_munic("Mad", cache_dir = cdir, cache = TRUE)
  )
})
