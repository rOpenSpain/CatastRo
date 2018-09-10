context("Remote procedure calls")

test_that("return data.frame given SRS", {
  result <- get_rc(lat = 38.6196566583596, lon = -3.45624183836806, SRS = "EPSG:4230")
  expect_that(is.data.frame(result), is_true())
})

test_that("return data.frame without SRS", {
  result <- get_rc(lat = 38.6196566583596, lon = -3.45624183836806)
  expect_that(is.data.frame(result), is_true())
})

test_that("check fields without SRS", {
  result <- get_rc(lat = 38.6196566583596, lon = -3.45624183836806)
  expect_that((is.character(result$address) & is.character(result$RC)), is_true())
})

test_that("check fields given SRS", {
  result <- get_rc(lat = 38.6196566583596,lon = -3.45624183836806, SRS = 'EPSG:4230')
  expect_that((is.character(result$address) & is.character(result$RC)), is_true())
})

test_that("if data is know return NA", {
  result <- get_rc(lat = 99999999,lon = -999999999)
  expect_that((is.na(result$address) & is.na(result$RC)), is_true())
})


test_that("unprecised coordinates", {
  result <- get_rc(lat = 40.963200,lon = -5.671420, SRS = "EPSG:4326")
  expect_that((is.na(result$address) & is.na(result$RC)), is_true())
})
