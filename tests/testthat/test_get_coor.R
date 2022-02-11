
test_that("giving all the arguments", {
  result <- get_coor("13077A01800039", "EPSG:4230", "CIUDAD REAL", "SANTA CRUZ DE MUDELA")
  expect_true((is.numeric(result$coord) & is.character(result$SRS)))
})


test_that("giving cadastral reference and SRS", {
  result <- get_coor("9872023VH5797S", "EPSG:4230")
  expect_true((is.numeric(result$coord) & is.character(result$SRS)))
})


test_that("giving only the cadastral reference", {
  result <- get_coor("9872023VH5797S")
  expect_true((is.numeric(result$coord) & is.character(result$SRS)))
})


test_that("given Municipio, Provincia is needed", {
  expect_error(get_coor(
    RC = "13077A01800039",
    SRS = "EPSG:4230",
    Municipality = "SANTA CRUZ DE MUDELA"
  ))
})
