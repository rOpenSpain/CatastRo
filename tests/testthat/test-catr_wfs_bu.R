test_that("BU Check error on srs", {
  expect_error(catr_wfs_bu_rc(rc = "1234", srs = 20))
  expect_error(catr_wfs_bu_rc(rc = 1234, what = "xxx"))
})

test_that("Check error on bad rc", {
  skip_on_cran()
  skip_on_os("linux")

  expect_message(catr_wfs_bu_rc(rc = "1234"))

  expect_message(catr_wfs_bu_rc(rc = "3662303TFxxxxx"))
})

test_that("BU Check srs", {
  skip_on_cran()
  skip_on_os("linux")

  obj <- catr_wfs_bu_rc(
    "3662303TF3136B",
    srs = 3857,
    verbose = TRUE
  )

  expect_true(sf::st_crs(obj) == sf::st_crs(3857))
})

test_that("BU Check verbose", {
  skip_on_cran()
  skip_on_os("linux")

  expect_message(catr_wfs_bu_rc("3662303TF3136B", verbose = TRUE))
})


test_that("BU Part Check", {
  skip_on_cran()
  skip_on_os("linux")

  obj <- catr_wfs_bu_rc("9398516VK3799G",
    what = "buildingpart"
  )
  expect_true(nrow(obj) > 1)
  expect_s3_class(obj, "sf")
})


test_that("BU Other Check", {
  skip_on_cran()
  skip_on_os("linux")

  obj <- catr_wfs_bu_rc("9398516VK3799G",
    what = "other"
  )
  expect_s3_class(obj, "sf")
})
