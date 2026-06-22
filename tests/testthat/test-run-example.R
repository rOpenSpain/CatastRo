test_that("On mac", {
  skip_on_cran()
  skip_if_offline()
  skip_on_os("mac")

  expect_false(on_mac())
  expect_true(run_example())
  local_mocked_bindings(on_mac = function(...) {
    TRUE
  })

  expect_false(run_example())
})


test_that("Offline", {
  skip_on_cran()
  skip_on_os("mac")

  local_mocked_bindings(
    is_online_fun = function(...) FALSE
  )

  expect_false(run_example())
})


test_that("Online", {
  skip_on_cran()
  skip_on_os("mac")

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    on_cran = function(...) FALSE
  )

  expect_true(run_example())
})


test_that("On CRAN", {
  skip_on_cran()
  skip_if_offline()
  skip_on_os("mac")

  withr::local_envvar(c(NOT_CRAN = "false"))

  expect_true(on_cran())
  expect_false(run_example())
})


test_that("NOT_CRAN empty falls back to interactive()", {
  skip_on_cran()
  skip_if_offline()
  skip_on_os("mac")

  withr::local_envvar(c(NOT_CRAN = ""))

  expect_identical(on_cran(), !interactive())
})


test_that("Not on CRAN", {
  skip_on_os("mac")

  withr::local_envvar(c(NOT_CRAN = "true"))

  local_mocked_bindings(
    is_online_fun = function(...) TRUE
  )

  expect_false(on_cran())
  expect_true(run_example())
})
