test_that("catr_atom_search_munic() returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(fend <- catr_atom_search_munic("LABAJOS", cache_dir = cdir))
  expect_null(fend)
})

test_that("catr_atom_search_munic() returns NULL after an HTTP 404", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  expect_snapshot(
    fend <- catr_atom_search_munic("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)
})

test_that("catr_atom_search_munic() ranks matching municipalities", {
  skip_on_cran()
  skip_if_offline()
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")
  a <- catr_atom_search_munic("Mad", cache_dir = cdir)
  expect_gt(nrow(a), 1)

  # Try with to
  b <- catr_atom_search_munic("Mad", to = 3, cache_dir = cdir)

  expect_s3_class(a, "tbl_df")
  expect_named(a, c("territorial_office", "munic", "catrcode"))
  expect_match(a$catrcode, "^[0-9]{5}$")
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

test_that("catr_atom_search_munic() warns about deprecated arguments", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")
  local_mocked_bindings(catr_atom_get_address_db_all = function(...) NULL)
  expect_snapshot(
    a <- catr_atom_search_munic("Mad", cache_dir = cdir, cache = TRUE)
  )
})
