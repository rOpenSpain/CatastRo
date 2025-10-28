test_that("Check", {
  skip_on_cran()
  skip_if_offline()
  skip_on_os("linux")

  # Try with coords

  expect_error(catr_get_code_from_coords(c(0, 0)))
  expect_error(catr_get_code_from_coords(c(0, 0, 0)))
  expect_message(
    catr_get_code_from_coords(c(0, 0), srs = 4326)
  )
  expect_s3_class(
    catr_get_code_from_coords(c(-16.25462, 28.46824), srs = 4326),
    "tbl"
  )

  # Try with sf

  m <- mapSpain::esp_get_capimun(munic = "Nieva")

  expect_message(catr_get_code_from_coords(m))
  expect_silent(catr_get_code_from_coords(m[1, ]))

  # Try polis
  m2 <- mapSpain::esp_get_ccaa("Murcia")
  s3 <- catr_get_code_from_coords(m2)

  expect_s3_class(s3, "tbl")

  # Try with sfc
  sfc <- sf::st_geometry(m2)

  expect_s3_class(sfc, "sfc")
  s4 <- catr_get_code_from_coords(sfc)
  expect_s3_class(s4, "tbl")
})
