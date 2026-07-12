test_that("parcel ATOM requests can be mocked", {
  local_mocked_bindings(
    catr_atom_get_parcels_db_all = mock_atom_all,
    catr_atom_get_parcels_db_to = mock_atom_to,
    download_url = mock_atom_download,
    read_geo_file_sf = mock_atom_read_geo
  )

  parcel <- catr_atom_get_parcels("Melque", to = "Segovia")
  expect_equal(parcel$file, "mock-atom.zip")
  expect_equal(parcel$hint, "parcel")

  zoning <- catr_atom_get_parcels("Melque", to = "Segovia", what = "zoning")
  expect_equal(zoning$hint, "zoning")
})

test_that("parcel ATOM returns NULL when mocked dependencies fail", {
  local_mocked_bindings(catr_atom_get_parcels_db_all = function(...) NULL)
  expect_null(catr_atom_get_parcels("Melque"))

  local_mocked_bindings(catr_atom_get_parcels_db_all = mock_atom_all)
  expect_snapshot(result <- catr_atom_get_parcels("No match"))
  expect_null(result)

  local_mocked_bindings(
    catr_atom_get_parcels_db_all = mock_atom_all,
    catr_atom_get_parcels_db_to = mock_atom_to,
    download_url = mock_atom_download_null
  )
  expect_null(catr_atom_get_parcels("Melque"))
})

test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(fend <- catr_atom_get_parcels("LABAJOS", cache_dir = cdir))
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
})
test_that("ATOM parcels", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  cdir <- withr::local_tempdir(pattern = "test_cp")
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
    "Ignoring `to` because no territorial office matched"
  )
  expect_s3_class(s, "sf")

  # Check other options
  me_cp <- catr_atom_get_parcels("Melque", to = "Segovia", cache_dir = cdir)

  me_cpzone <- catr_atom_get_parcels(
    "Melque",
    to = "Segovia",
    what = "zoning",
    cache_dir = cdir
  )

  expect_s3_class(me_cp, "sf")
  expect_s3_class(me_cpzone, "sf")

  expect_gt(nrow(me_cp), nrow(me_cpzone))
})

test_that("ATOM Encoding issue", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  cdir <- withr::local_tempdir(pattern = "test_cp2")

  expect_silent(catr_atom_get_parcels("23078", cache_dir = cdir))
  expect_silent(catr_atom_get_parcels("03050", cache_dir = cdir))
  expect_silent(catr_atom_get_parcels("23051", cache_dir = cdir))
})

test_that("Test 404 single", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  cdir <- withr::local_tempdir(pattern = "testthat_ex2to2bu")

  all <- catr_atom_get_parcels_db_all(cache_dir = cdir)
  all <- catr_atom_get_parcels_db_to("Segovia", cache_dir = cdir)

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  expect_snapshot(
    fend <- catr_atom_get_parcels("Melque", to = "Segovia", cache_dir = cdir)
  )
  expect_null(fend)
  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
})
