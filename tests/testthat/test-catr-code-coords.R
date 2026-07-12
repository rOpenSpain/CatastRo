test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("mapSpain")

  cdir <- withr::local_tempdir(pattern = "testthat_ex")
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
})

test_that("Test 404 all", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("mapSpain")

  cdir <- withr::local_tempdir(pattern = "testthat_ex")

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
})

test_that("Test 404 mapSpain", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("mapSpain")

  cdir <- withr::local_tempdir(pattern = "testthat_ex")

  local_mocked_bindings(
    catr_esp_get_munic_siane = function(...) {
      cli::cli_alert_info("Mocking mapSpain")
      NULL
    }
  )

  expect_snapshot(
    fend <- catr_get_code_from_coords(
      c(-16.25462, 28.46824),
      srs = 4326,
      cache_dir = cdir
    )
  )
  expect_null(fend)
})
test_that("Check", {
  skip_on_cran()
  skip_if_offline()
  cdir <- withr::local_tempdir(pattern = "testthat_excoord")
  polygon <- function(xmin, ymin, xmax, ymax) {
    sf::st_polygon(list(matrix(
      c(
        xmin,
        ymin,
        xmin,
        ymax,
        xmax,
        ymax,
        xmax,
        ymin,
        xmin,
        ymin
      ),
      ncol = 2,
      byrow = TRUE
    )))
  }
  mun <- sf::st_sf(
    cpro = c("38", "33", "30"),
    cmun = c("038", "064", "001"),
    geometry = sf::st_sfc(
      polygon(-17, 28, -16, 29),
      polygon(-7, 40, -6, 41),
      polygon(-2, 37, -1, 38),
      crs = 4326
    )
  )

  local_mocked_bindings(
    catr_esp_get_munic_siane = function(...) {
      mun
    },
    catr_ovc_get_cod_munic = function(cpro, cmun = NULL, cmun_ine = NULL, ...) {
      munic <- ifelse(cpro == "33", "SANTO DOMINGO", paste0("MUNIC ", cpro))
      dplyr::tibble(
        munic = munic,
        catr_to = cpro,
        catr_munic = cmun_ine,
        catrcode = paste0(cpro, cmun_ine),
        cpro = cpro,
        cmun = cmun_ine,
        inecode = paste0(cpro, cmun_ine),
        nm = munic,
        cd = cpro,
        cmc = as.character(as.integer(cmun_ine)),
        cp = cpro,
        cm = as.character(as.integer(cmun_ine))
      )
    }
  )

  # Try with coords

  expect_snapshot(error = TRUE, df <- catr_get_code_from_coords(c(0, 0)))
  expect_snapshot(error = TRUE, df <- catr_get_code_from_coords(c(0, 0, 0)))
  expect_snapshot(df <- catr_get_code_from_coords(c(0, 0), srs = 4326))
  expect_s3_class(
    catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326),
    "tbl"
  )

  # Try with sf
  m <- mun[2:3, ]

  expect_snapshot(catr_get_code_from_coords(m, cache_dir = cdir))
  expect_silent(catr_get_code_from_coords(m[1, ]))

  # Try polis
  m2 <- mun[3, ]
  s3 <- catr_get_code_from_coords(m2, cache_dir = cdir)

  expect_s3_class(s3, "tbl")

  # Try with sfc
  sfc <- sf::st_geometry(m2)

  expect_s3_class(sfc, "sfc")
  s4 <- catr_get_code_from_coords(sfc, cache_dir = cdir)
  expect_s3_class(s4, "tbl")
})

test_that("coordinate lookup can call the real APIs", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()
  skip_if_not_installed("mapSpain")

  result <- catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326)
  expect_s3_class(result, "tbl")
})
