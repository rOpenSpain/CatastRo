test_that("Read shp", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
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

  unlink(cdir, recursive = TRUE, force = TRUE)
  expect_false(dir.exists(cdir))
})

test_that("Read shp address", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "testthat_ex")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
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

  unlink(cdir, recursive = TRUE, force = TRUE)
  expect_false(dir.exists(cdir))
})
