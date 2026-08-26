test_that("run_example() returns FALSE on macOS", {
  skip_on_os("mac")

  expect_false(on_mac())
  expect_true(run_example())
  local_mocked_bindings(on_mac = function(...) {
    TRUE
  })

  expect_false(run_example())
})


test_that("run_example() returns FALSE when offline", {
  skip_on_os("mac")

  local_mocked_bindings(is_online_fun = function(...) FALSE)

  expect_false(run_example())
})


test_that("run_example() returns TRUE when all requirements are met", {
  skip_on_os("mac")

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    on_cran = function(...) FALSE
  )

  expect_true(run_example())
})


test_that("run_example() returns FALSE on CRAN", {
  skip_on_os("mac")

  withr::local_envvar(c(NOT_CRAN = "false"))

  expect_true(on_cran())
  expect_false(run_example())
})


test_that("on_cran() falls back to interactive() when NOT_CRAN is empty", {
  skip_on_os("mac")

  withr::local_envvar(c(NOT_CRAN = ""))

  expect_identical(on_cran(), !interactive())
})


test_that("run_example() returns TRUE outside CRAN in interactive sessions", {
  skip_on_os("mac")

  withr::local_envvar(c(NOT_CRAN = "true"))

  local_mocked_bindings(is_online_fun = function(...) TRUE)

  expect_false(on_cran())
  expect_true(run_example())
})
