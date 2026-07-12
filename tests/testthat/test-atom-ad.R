test_that("address ATOM requests can be mocked", {
  local_mocked_bindings(
    catr_atom_get_address_db_all = mock_atom_all,
    catr_atom_get_address_db_to = mock_atom_to,
    download_url = mock_atom_download,
    read_geo_file_sf = mock_atom_read_geo
  )

  result <- catr_atom_get_address("Melque", to = "Segovia")

  expect_equal(result$file, "mock-atom.zip")
  expect_equal(result$hint, "gml")
  expect_equal(result$tfname_text, "Main street")
})

test_that("address ATOM returns NULL when mocked dependencies fail", {
  local_mocked_bindings(catr_atom_get_address_db_all = function(...) NULL)
  expect_null(catr_atom_get_address("Melque"))

  local_mocked_bindings(catr_atom_get_address_db_all = mock_atom_all)
  expect_snapshot(result <- catr_atom_get_address("No match"))
  expect_null(result)

  local_mocked_bindings(
    catr_atom_get_address_db_all = mock_atom_all,
    catr_atom_get_address_db_to = mock_atom_to,
    download_url = mock_atom_download_null
  )
  expect_null(catr_atom_get_address("Melque"))
})

test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(fend <- catr_atom_get_address("Madrid", cache_dir = cdir))
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
    fend <- catr_atom_get_address("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
  unlink(cdir, recursive = TRUE, force = TRUE)
  # Otherwise work
  expect_silent(
    fend <- catr_atom_get_address("MELQUE", to = "Segovia", cache_dir = cdir)
  )
  expect_gt(nrow(fend), 20)
})
test_that("ATOM Addresses", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

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

test_that("ATOM Encoding issue", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  cdir <- withr::local_tempdir(pattern = "test_ad2")
  expect_silent(s <- catr_atom_get_address("23078", cache_dir = cdir))
  expect_s3_class(s, "sf")

  expect_true("tfname_text" %in% names(s))

  expect_silent(catr_atom_get_address("03050", cache_dir = cdir))
  expect_silent(catr_atom_get_address("23051", cache_dir = cdir))
})

test_that("Test 404 single", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  cdir <- withr::local_tempdir(pattern = "testthat_ex2to2")

  all <- catr_atom_get_address_db_all(cache_dir = cdir)
  all <- catr_atom_get_address_db_to("Segovia", cache_dir = cdir)

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  expect_snapshot(
    fend <- catr_atom_get_address("Melque", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})
