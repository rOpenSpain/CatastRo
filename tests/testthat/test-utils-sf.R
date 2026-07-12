test_that("local geospatial files are read and sanitized", {
  local_file <- withr::local_tempfile(fileext = ".gpkg")
  source_sf <- sf::st_sf(
    name = "área",
    geometry = sf::st_sfc(sf::st_point(c(0, 0)), crs = 4326)
  )
  sf::write_sf(source_sf, local_file, layer = "mock_layer", quiet = TRUE)

  result <- read_geo_file_sf(local_file, layer_hint = "mock")

  expect_s3_class(result, "sf")
  expect_equal(result$name, "área")
  expect_equal(sf::st_crs(result)$epsg, 4326)

  tb <- sanitize_sf(data.frame(name = "área"))
  expect_s3_class(tb, c("tbl_df", "tbl", "data.frame"), exact = TRUE)
  expect_equal(tb$name, "área")
})

test_that("Read shp", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  cdir <- withr::local_tempdir(pattern = "testthat_ex")
  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/Buildings/46/",
    "46900-VALENCIA/A.ES.SDGC.BU.46900.zip"
  )

  fake_local <- download_url(
    url,
    basename(url),
    cdir,
    "fake",
    update_cache = FALSE,
    verbose = FALSE
  )

  s <- read_geo_file_sf(fake_local, hint = "building.gml")

  expect_s3_class(s, "sf")
  expect_s3_class(s, "tbl_df")
  expect_true(file.exists(fake_local))
})

test_that("Read shp address", {
  skip_on_cran()
  skip_if_offline()
  skip_on_ci()

  cdir <- withr::local_tempdir(pattern = "testthat_ex")
  url <- paste0(
    "https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/40/",
    "40146-MELQUE%20DE%20CERCOS/A.ES.SDGC.AD.40146.zip"
  )

  fake_local <- download_url(
    url,
    basename(url),
    cdir,
    "fake",
    update_cache = FALSE,
    verbose = FALSE
  )

  s <- read_geo_file_sf(fake_local, hint = "gml", "address")

  expect_s3_class(s, "sf")
  expect_s3_class(s, "tbl_df")
  expect_true(file.exists(fake_local))

  # But
  tb <- read_geo_file_sf(fake_local, hint = "gml", "fare")
  expect_s3_class(tb, c("tbl_df", "tbl", "data.frame"), exact = TRUE)
})

test_that("get_sf_from_bbox", {
  a <- get_sf_from_bbox(c(1, 2, 3, 4), srs = 3857)
  b <- get_sf_from_bbox(a)

  expect_identical(a, b)

  c <- sf::st_sf(x = 1, geometry = b)
  cc <- get_sf_from_bbox(c)
  expect_identical(c, cc)

  expect_snapshot(error = TRUE, get_sf_from_bbox(c(1, 2)))
  expect_snapshot(error = TRUE, get_sf_from_bbox(c(1, 2, 1, 2)))
})
