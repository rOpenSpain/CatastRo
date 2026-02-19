test_that("Test offline", {
  skip_on_cran()
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  expect_snapshot(
    fend <- catr_atom_get_address_db_all(cache_dir = cdir)
  )
  expect_null(fend)

  expect_snapshot(
    fend <- catr_atom_get_address_db_to("Madrid", cache_dir = cdir)
  )
  expect_null(fend)

  expect_length(list.files(cdir, recursive = TRUE), 0)
  unlink(cdir, recursive = TRUE, force = TRUE)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Test 404", {
  skip_on_cran()

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  expect_snapshot(
    fend <- catr_atom_get_address_db_all(cache_dir = cdir)
  )
  expect_null(fend)

  expect_snapshot(
    fend <- catr_atom_get_address_db_to("Madrid", cache_dir = cdir)
  )
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })

  # Otherwise work
  expect_silent(
    fend <- catr_atom_get_address_db_all(cache_dir = cdir)
  )
  expect_gt(nrow(fend), 20)

  expect_silent(
    fend <- catr_atom_get_address_db_to("Madrid", cache_dir = cdir)
  )
  expect_gt(nrow(fend), 100)

  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
})

test_that("Test atom ad", {
  skip_on_cran()
  skip_if_offline()
  expect_message(catr_atom_get_address_db_all(
    verbose = TRUE,
    cache_dir = tempdir()
  ))
  expect_snapshot(
    no_res <- catr_atom_get_address_db_to(
      to = "aaaana",
      cache_dir = tempdir()
    )
  )
  expect_null(no_res)

  expect_silent(
    nmel <- catr_atom_get_address_db_to(
      to = "Melilla",
      cache_dir = tempdir()
    )
  )
  expect_s3_class(nmel, "tbl")
  expect_shape(nmel, dim = c(1, 3))

  # Several patterns
  expect_snapshot(
    several <- catr_atom_get_address_db_to(
      to = "lencia",
      cache_dir = tempdir()
    )
  )

  expect_silent(
    pal <- catr_atom_get_address_db_to(
      to = "$Palencia",
      cache_dir = tempdir()
    )
  )

  expect_identical(several, pal)
})
