test_that("return data.frame given SRS", {
  result <- near_rc(lat = 40.963200, lon = -5.671420, "EPSG:4326")
  expect_true(is.data.frame(result))
})

test_that("return data.frame without SRS", {
  result <- near_rc(lat = 40.963200, lon = -5.671420)
  expect_true(is.data.frame(result))
})

test_that("check fields without SRS", {
  result <- near_rc(lat = 40.963200, lon = -5.671420)
  expect_true((is.character(result$address) & is.character(result$RC)))
})

test_that("check fields given SRS", {
  result <- near_rc(lat = 40.963200, lon = -5.671420, "EPSG:4230")
  expect_true((is.character(result$address) & is.character(result$RC)))
})

test_that("if data is known return NA", {
  result <- near_rc(lat = 99999999, lon = -999999999)
  expect_true(all(is.na(result)))
})

test_that("unprecised coordinates", {
  result <- near_rc(lat = 40.963200, lon = -5.671420, SRS = "EPSG:4326")
  expect_true(is.data.frame(result))
})
