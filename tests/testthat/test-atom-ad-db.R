test_that("NULL result", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(catr_atom_get_address_db_all = function(...) {
    NULL
  })

  expect_null(catr_atom_get_address_db_to("Madrid"))
})

test_that("Test offline db_all", {
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
    fend <- catr_atom_get_address_db_all(cache_dir = cdir)
  )
  expect_null(fend)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
  unlink(cdir, recursive = TRUE, force = TRUE)
})

test_that("Test offline db_to", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- file.path(tempdir(), "testthat_ex1to")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  expect_snapshot(
    fend <- catr_atom_get_address_db_to("Madrid", cache_dir = cdir)
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
    fend <- catr_atom_get_address_db_all(cache_dir = cdir)
  )
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
  unlink(cdir, recursive = TRUE, force = TRUE)
  # Otherwise work
  expect_silent(
    fend <- catr_atom_get_address_db_all(cache_dir = cdir)
  )
  expect_gt(nrow(fend), 20)

  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
})

test_that("Test 404 to", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "testthat_ex2to")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  fend <- catr_atom_get_address_db_to("Madrid", cache_dir = cdir)

  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
  unlink(cdir, recursive = TRUE, force = TRUE)
  # Otherwise work
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
      to = "Palencia",
      cache_dir = tempdir()
    )
  )

  expect_identical(several, pal)

  # full name
  expect_silent(
    val <- catr_atom_get_address_db_to(
      to = "valencia",
      cache_dir = tempdir()
    )
  )
  expect_false(pal$munic[1] == val$munic[1])
})

test_that("Deprecations", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "testthat_ex2to")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_snapshot(
    fend <- catr_atom_get_address_db_to(
      to = "Madrid",
      cache = FALSE,
      cache_dir = cdir
    )
  )

  expect_snapshot(
    fend <- catr_atom_get_address_db_all(cache_dir = cdir, cache = FALSE)
  )

  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
})

test_that("Test 404 to bis", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "testthat_ex2to2")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  all <- catr_atom_get_address_db_all(cache_dir = cdir)

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  expect_snapshot(
    fend <- catr_atom_get_address_db_to("Madrid", cache_dir = cdir)
  )
  expect_null(fend)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
  unlink(cdir, recursive = TRUE, force = TRUE)
})
