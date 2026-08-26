test_that("catr_atom_get_parcels_db_to() returns NULL without data", {
  local_mocked_bindings(catr_atom_get_parcels_db_all = function(...) {
    NULL
  })

  expect_null(catr_atom_get_parcels_db_to("Madrid"))
})

test_that("catr_atom_get_parcels_db_all() returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(fend <- catr_atom_get_parcels_db_all(cache_dir = cdir))
  expect_null(fend)
})

test_that("catr_atom_get_parcels_db_to() returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "testthat_ex1to")
  expect_snapshot(
    fend <- catr_atom_get_parcels_db_to("Madrid", cache_dir = cdir)
  )
  expect_null(fend)
})

test_that("catr_atom_get_parcels_db_all() returns NULL after an HTTP 404", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  expect_snapshot(fend <- catr_atom_get_parcels_db_all(cache_dir = cdir))
  expect_null(fend)
})

test_that("catr_atom_get_parcels_db_to() returns NULL after an HTTP 404", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex2to")

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  fend <- catr_atom_get_parcels_db_to("Madrid", cache_dir = cdir)

  expect_null(fend)
})

test_that("catr_atom_get_parcels_db_to() ranks office matches", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "testthat_atom_cp")
  expect_message(catr_atom_get_parcels_db_all(verbose = TRUE, cache_dir = cdir))
  expect_snapshot(
    no_res <- catr_atom_get_parcels_db_to(to = "aaaana", cache_dir = cdir)
  )
  expect_null(no_res)

  expect_silent(
    nmel <- catr_atom_get_parcels_db_to(to = "Melilla", cache_dir = cdir)
  )
  expect_s3_class(nmel, "tbl")
  expect_shape(nmel, dim = c(1, 3))
  expect_named(nmel, c("munic", "url", "date"))
  expect_match(nmel$url, "^https://")

  # Several patterns
  expect_snapshot(
    several <- catr_atom_get_parcels_db_to(to = "lencia", cache_dir = cdir)
  )

  expect_silent(
    pal <- catr_atom_get_parcels_db_to(to = "Palencia", cache_dir = cdir)
  )

  expect_identical(several, pal)

  # full name
  expect_silent(
    val <- catr_atom_get_parcels_db_to(to = "valencia", cache_dir = cdir)
  )
  expect_false(pal$munic[1] == val$munic[1])
})

test_that("parcel database functions warn about deprecated cache arguments", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex2to")
  local_mocked_bindings(
    catr_atom_read_db_all = function(...) NULL,
    catr_atom_read_db_to = function(...) NULL
  )

  expect_snapshot(
    fend <- catr_atom_get_parcels_db_to(
      to = "Madrid",
      cache = FALSE,
      cache_dir = cdir
    )
  )

  expect_snapshot(
    fend <- catr_atom_get_parcels_db_all(cache_dir = cdir, cache = FALSE)
  )
})

test_that("catr_atom_get_parcels_db_to() handles a failed cached request", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "testthat_ex2to2")

  invisible(catr_atom_get_parcels_db_all(cache_dir = cdir))

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  expect_snapshot(
    fend <- catr_atom_get_parcels_db_to("Madrid", cache_dir = cdir)
  )
  expect_null(fend)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})
