context("Remote procedure calls")

test_that("return data.frame given SRS", {
  result <- near_rc(lat = 40.963200, lon = -5.671420, "EPSG:4326")
  expect_that(is.data.frame(result), is_true())
})

test_that("return data.frame without SRS", {
  result <- near_rc(lat = 40.963200, lon = -5.671420)
  expect_that(is.data.frame(result), is_true())
})

test_that("check fields without SRS", {
  result <- near_rc(lat = 40.963200, lon = -5.671420)
  expect_that((is.character(result$address) & is.character(result$RC)), is_true())
})

test_that("check fields given SRS", {
  result <- near_rc(lat = 40.963200,lon = -5.671420,'EPSG:4230')
  expect_that((is.character(result$address) & is.character(result$RC)), is_true())
})

test_that("if data is known return NA", {
  result <- near_rc(lat = 99999999,lon = -999999999)
  expect_that(all(is.na(result)), is_true())
})

test_that("unprecised coordinates", {
  result <- near_rc(lat = 40.963200,lon = -5.671420, SRS = "EPSG:4326")
  expect_that(is.data.frame(result), is_true())
})
