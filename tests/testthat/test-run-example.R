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

test_that("On CRAN", {
  skip_on_cran()
  skip_if_offline()

  # Imagine we are in CRAN
  env_orig <- Sys.getenv("NOT_CRAN")
  Sys.setenv("NOT_CRAN" = "false")
  expect_true(on_cran())
  expect_false(run_example())

  # Restore
  Sys.setenv("NOT_CRAN" = env_orig)
  expect_identical(Sys.getenv("NOT_CRAN"), env_orig)
  expect_true(run_example())
})
