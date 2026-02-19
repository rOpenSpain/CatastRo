test_that("Messages", {
  skip_on_cran()
  expect_silent(make_msg(verbose = FALSE))
  expect_snapshot(make_msg(
    "generic",
    TRUE,
    "Hi",
    "I am a generic.",
    "See {.var avar}."
  ))
  expect_snapshot(make_msg("info", TRUE, "Info here.", "See {.pkg igoR}."))

  expect_snapshot(make_msg(
    "warning",
    TRUE,
    "Caution! A warning.",
    "But still OK."
  ))

  expect_snapshot(make_msg("danger", TRUE, "OOPS!", "I did it again :("))

  expect_snapshot(make_msg("success", TRUE, "Hooray!", "5/5 ;)"))
})


test_that("Pretty match", {
  skip_on_cran()
  my_fun <- function(
    arg_one = c(10, 1000, 3000, 5000)
  ) {
    match_arg_pretty(arg_one)
  }

  # OK, returns character
  expect_identical(my_fun(1000), "1000")
  expect_identical(my_fun("1000"), "1000")
  expect_identical(my_fun(NULL), "10")
  expect_identical(my_fun(), "10")
  # Some errors here
  # Single value no match
  expect_snapshot(
    my_fun("error here"),
    error = TRUE
  )

  # Several values no match
  expect_snapshot(
    my_fun(c("an", "error")),
    error = TRUE
  )

  # One value regex
  expect_snapshot(
    my_fun("5"),
    error = TRUE
  )
  # Several value regex
  expect_snapshot(
    my_fun("00"),
    error = TRUE
  )

  my_fun2 <- function(year = 20) {
    match_arg_pretty(year)
  }

  # Pass more options than expected
  expect_snapshot(
    my_fun2(c(1, 2)),
    error = TRUE
  )

  # With custom options
  my_fun3 <- function(an_arg = 20) {
    match_arg_pretty(an_arg, c("30", "20"))
  }
  expect_identical(my_fun3(), "20")
  expect_snapshot(my_fun3("3"), error = TRUE)
  # Pass more options than expected
  expect_snapshot(
    my_fun2(c(1, 2)),
    error = TRUE
  )
})

test_that("Ensure NULL", {
  expect_null(ensure_null(NULL))
  expect_null(ensure_null(c(NULL, NA)))
  expect_null(ensure_null(c(NULL, NA, "")))
  expect_null(ensure_null(c("", character(0))))
  expect_identical(ensure_null(c(1, 2)), c(1, 2))
  expect_identical(letters, letters)
})

test_that("Not empty", {
  a_fun <- function(a, b) {
    a <- validate_non_empty_arg(a)
    b <- validate_non_empty_arg(b)
    c(a, b)
  }

  expect_snapshot(error = TRUE, a_fun())
  expect_snapshot(error = TRUE, a_fun(a = 1))
  expect_identical(a_fun(a = 1, b = 1), c(1, 1))
})
