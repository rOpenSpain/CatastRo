test_that("catr_atom_get_address() returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(fend <- catr_atom_get_address("Madrid", cache_dir = cdir))
  expect_null(fend)
})

test_that("catr_atom_get_address() handles a database HTTP 404", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  expect_snapshot(
    fend <- catr_atom_get_address("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)
})
test_that("catr_atom_get_address() returns spatial address data", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "test_ad")
  expect_snapshot(catr_atom_get_address("xyxghx", cache_dir = cdir))

  expect_message(
    s <- catr_atom_get_address(
      "Segov",
      to = "Segovia",
      verbose = TRUE,
      cache_dir = cdir
    )
  )

  # Deprecations
  expect_snapshot(
    s <- catr_atom_get_address(
      "Melque",
      to = "Segovia",
      cache = FALSE,
      cache_dir = cdir
    )
  )

  expect_s3_class(s, "sf")
  expect_false(is.na(sf::st_crs(s)))
  expect_false(any(sf::st_is_empty(s)))
  expect_setequal(
    intersect(c("gml_id", "tfname_text"), names(s)),
    c("gml_id", "tfname_text")
  )
  expect_message(
    catr_atom_get_address(
      "Melque",
      to = "XXX",
      verbose = TRUE,
      cache_dir = cdir
    ),
    'Ignoring `to` because no territorial office matched "XXX".'
  )
  expect_s3_class(s, "sf")
})

test_that("catr_atom_get_address() preserves fields with accented characters", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "test_ad2")
  expect_silent(s <- catr_atom_get_address("23078", cache_dir = cdir))
  expect_s3_class(s, "sf")

  expect_setequal(intersect("tfname_text", names(s)), "tfname_text")

  expect_silent(catr_atom_get_address("03050", cache_dir = cdir))
  expect_silent(catr_atom_get_address("23051", cache_dir = cdir))
})

test_that("catr_atom_get_address() handles a download HTTP 404", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "testthat_ex2to2")

  invisible(catr_atom_get_address_db_all(cache_dir = cdir))
  invisible(catr_atom_get_address_db_to("Segovia", cache_dir = cdir))

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    is_404 = function(...) TRUE
  )

  expect_snapshot(
    fend <- catr_atom_get_address("Melque", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})
