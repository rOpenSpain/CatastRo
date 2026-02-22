test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("mapSpain")

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  expect_snapshot(
    fend <- catr_get_code_from_coords(
      c(-16.25462, 28.46824),
      srs = 4326,
      cache_dir = cdir
    )
  )
  expect_null(fend)

  expect_snapshot(
    fend <- catr_get_code_from_coords(
      mapSpain::esp_get_prov_siane("Caceres"),
      cache_dir = cdir
    )
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
  skip_if_not_installed("mapSpain")

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  expect_snapshot(
    fend <- catr_get_code_from_coords(
      c(-16.25462, 28.46824),
      srs = 4326,
      cache_dir = cdir
    )
  )
  expect_null(fend)

  expect_snapshot(
    fend <- catr_get_code_from_coords(
      mapSpain::esp_get_prov_siane("Caceres"),
      cache_dir = cdir
    )
  )
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
  unlink(cdir, recursive = TRUE, force = TRUE)
})

test_that("Test 404 mapSpain", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("mapSpain")

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  local_mocked_bindings(
    esp_get_munic_siane = function(...) {
      cli::cli_alert_info("Mocking mapSpain")
      NULL
    },
    .package = "mapSpain"
  )

  expect_snapshot(
    fend <- catr_get_code_from_coords(
      c(-16.25462, 28.46824),
      srs = 4326,
      cache_dir = cdir
    )
  )
  expect_null(fend)

  unlink(cdir, recursive = TRUE, force = TRUE)
})
test_that("Check", {
  skip_on_cran()
  skip_if_offline()
  cdir <- file.path(tempdir(), "testthat_excoord")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  # Try with coords

  expect_error(catr_get_code_from_coords(c(0, 0)))
  expect_error(catr_get_code_from_coords(c(0, 0, 0)))
  expect_message(
    catr_get_code_from_coords(c(0, 0), srs = 4326)
  )
  expect_s3_class(
    catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326),
    "tbl"
  )

  # Try with sf
  m <- mapSpain::esp_get_ccaa_siane(
    ccaa = c("Asturias", "La Rioja"),
    cache_dir = cdir
  )

  expect_message(catr_get_code_from_coords(m, cache_dir = cdir))
  expect_silent(catr_get_code_from_coords(m[1, ]))

  # Try polis
  m2 <- mapSpain::esp_get_ccaa_siane(
    "Murcia",
    cache_dir = cdir
  )
  s3 <- catr_get_code_from_coords(m2, cache_dir = cdir)

  expect_s3_class(s3, "tbl")

  # Try with sfc
  sfc <- sf::st_geometry(m2)

  expect_s3_class(sfc, "sfc")
  s4 <- catr_get_code_from_coords(sfc, cache_dir = cdir)
  expect_s3_class(s4, "tbl")
  unlink(cdir, recursive = TRUE, force = TRUE)
})
