context("Remote procedure calls")

test_that("giving coordinates", {
  result <- getRC_distance(-3.45624183836806, 38.6196566583596)
  expect_that((is.character(result$address) & is.character(result$RC)), is_true())
})

test_that("giving cordinates and its SRS", {
  result <- getRC_distance(-3.45624183836806, 38.6196566583596, 'EPSG:4230')
  expect_that((is.character(result$address) & is.character(result$RC)), is_true())
})

test_that("giving no real SRS", {
  expect_error(getRC_distance(-3.45624183836806, 38.6196566583596, 'EPSG:32627'))
})
