context("Remote procedure calls")

test_that("giving all the arguments", {
  result <- getCOOR('13077A01800039','EPSG:4230','CIUDAD REAL', 'SANTA CRUZ DE MUDELA')
  expect_that((is.numeric(result$coord) & is.character(result$SRS)), is_true())
})

test_that("giving cadastral reference and SRS", {
  result <- getCOOR('9872023VH5797S','EPSG:4230')
  expect_that((is.numeric(result$coord) & is.character(result$SRS)), is_true())
})

test_that("giving only the cadastral reference", {
  result <- getCOOR('9872023VH5797S')
  expect_that((is.numeric(result$coord) & is.character(result$SRS)), is_true())
})

test_that("given Municipio, Provincia is needed", {
  result <- getCOOR(RC = '13077A01800039',SRS = 'EPSG:4230', Municipio = 'SANTA CRUZ DE MUDELA')
  expect_that(result, throws_error())
})
