## ---- message=FALSE, eval=FALSE------------------------------------------
#  library(devtools)
#  install_github("rOpenSpain/CatastRo")

## ---- message=FALSE------------------------------------------------------
library(CatastRo)

## ------------------------------------------------------------------------
reference <- get_rc(lat = 38.6196566583596, lon =  -3.45624183836806, SRS = 'EPSG:4230')
print(reference)

## ------------------------------------------------------------------------
reference <- get_rc(lat =  38.6196566583596, lon =-3.45624183836806)
print(reference)

## ------------------------------------------------------------------------
references <- near_rc(lat = 40.96002, lon = -5.663408, SRS = 'EPSG:4230')
print(references)

## ------------------------------------------------------------------------
direction <- get_coor(RC = '13077A01800039', 
                      SRS = 'EPSG:4230',
                      Province = 'CIUDAD REAL', 
                      Municipality = 'SANTA CRUZ DE MUDELA')
print(direction)

## ------------------------------------------------------------------------
direction <- get_coor(RC = '13077A01800039', 
                     Province = 'CIUDAD REAL', 
                     Municipality = 'SANTA CRUZ DE MUDELA')
print(direction)

## ----error=TRUE----------------------------------------------------------
direction <- get_coor(RC = '13077A01800039',  Municipality = 'SANTA CRUZ DE MUDELA')
direction <- get_coor(RC = '13077A01800039')
print(direction)

## ----error=TRUE----------------------------------------------------------
library(testthat)
test_that("giving only the cadastral reference", {
  result <- get_coor('9872023VH5797S')
  expect_that((is.numeric(result$coord) & is.character(result$SRS)), is_true())
})

test_that("given Municipio, Provincia is needed", {
  result <- get_coor(RC = '13077A01800039',SRS = 'EPSG:4230', Municipality = 'SANTA CRUZ DE MUDELA')
  expect_that(result, throws_error())
})

