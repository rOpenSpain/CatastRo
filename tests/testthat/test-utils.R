test_that("make_msg() dispatches supported message types", {
  expect_silent(make_msg(verbose = FALSE))
  expect_snapshot(make_msg(
    "generic",
    TRUE,
    "Hi",
    "I am a generic.",
    "See {.var avar}."
  ))
  expect_snapshot(make_msg("info", TRUE, "Info here.", "See {.pkg igoR}."))

  caller_env <- list2env(list(caller_value = "caller value"))
  expect_snapshot(make_msg(
    "info",
    TRUE,
    "Value: {.val {caller_value}}.",
    .envir = caller_env
  ))

  expect_snapshot(make_msg(
    "warning",
    TRUE,
    "Caution! A warning.",
    "But still OK."
  ))

  expect_snapshot(make_msg("danger", TRUE, "OOPS!", "I did it again :("))

  expect_snapshot(make_msg("success", TRUE, "Hooray!", "5/5 ,)"))

  expect_silent(no_msg <- make_msg("nothing", TRUE, "aa"))
  expect_null(no_msg)
})

test_that("match_arg_pretty() reports the closest valid choice", {
  my_fun <- function(arg_one = c(10, 1000, 3000, 5000)) {
    match_arg_pretty(arg_one)
  }

  # OK, returns character
  expect_identical(my_fun(1000), "1000")
  expect_identical(my_fun("1000"), "1000")
  expect_identical(my_fun(NULL), "10")
  expect_identical(my_fun(), "10")
  # Some errors here
  # Single value no match
  expect_snapshot(my_fun("error here"), error = TRUE)

  # Several values no match
  expect_snapshot(my_fun(c("an", "error")), error = TRUE)

  # One value regex
  expect_snapshot(my_fun("5"), error = TRUE)
  # Several value regex
  expect_snapshot(my_fun("00"), error = TRUE)

  my_fun2 <- function(year = 20) {
    match_arg_pretty(year)
  }

  # Pass more options than expected
  expect_snapshot(my_fun2(c(1, 2)), error = TRUE)

  # With custom options
  my_fun3 <- function(an_arg = 20) {
    match_arg_pretty(an_arg, c("30", "20"))
  }
  expect_identical(my_fun3(), "20")
  expect_snapshot(my_fun3("3"), error = TRUE)
})

test_that("ensure_null() converts empty values and preserves nonempty values", {
  expect_null(ensure_null(NULL))
  expect_null(ensure_null(c(NULL, NA)))
  expect_null(ensure_null(c(NULL, NA, "")))
  expect_null(ensure_null(c("", character(0))))
  expect_identical(ensure_null(c(1, 2)), c(1, 2))
  expect_identical(ensure_null(letters), letters)
})

test_that("validate_non_empty_arg() rejects missing arguments", {
  a_fun <- function(a, b) {
    a <- validate_non_empty_arg(a)
    b <- validate_non_empty_arg(b)
    c(a, b)
  }

  expect_snapshot(error = TRUE, a_fun())
  expect_snapshot(error = TRUE, a_fun(a = 1))
  expect_identical(a_fun(a = 1, b = 1), c(1, 1))

  expect_error(validate_non_empty_arg(NULL), class = "rlang_error")
  expect_error(validate_non_empty_arg(NA), class = "rlang_error")
  expect_error(validate_non_empty_arg("  "), class = "rlang_error")
})

test_that("scalar and coordinate validators reject malformed values", {
  expect_identical(validate_scalar_arg("abc"), "abc")
  expect_identical(validate_scalar_arg(123), 123)
  expect_identical(validate_coordinate_arg(1.5), 1.5)

  expect_error(validate_scalar_arg(c("a", "b")), class = "rlang_error")
  expect_error(validate_scalar_arg(TRUE), class = "rlang_error")
  expect_error(validate_coordinate_arg("1.5"), class = "rlang_error")
  expect_error(validate_coordinate_arg(Inf), class = "rlang_error")
})

test_that("validate_vector_with_srs() requires finite numeric coordinates", {
  expect_silent(validate_vector_with_srs(c(1, 2), 4326, 2L))
  expect_error(
    validate_vector_with_srs(c("1", "2"), 4326, 2L),
    class = "rlang_error"
  )
  expect_error(
    validate_vector_with_srs(c(1, Inf), 4326, 2L),
    class = "rlang_error"
  )
})
test_that("cli_abort_if_not() validates scalar conditions and caller context", {
  expect_silent(cli_abort_if_not("Condition fails." = TRUE))

  expect_snapshot(
    error = TRUE,
    cli_abort_if_not(
      "Message supports {.cls inline} {.str markup}." = is.logical(1)
    )
  )
  expect_snapshot(
    error = TRUE,
    cli_abort_if_not("Missing conditions fail." = NA)
  )
  expect_snapshot(
    error = TRUE,
    cli_abort_if_not("Empty conditions fail." = logical())
  )
  expect_snapshot(error = TRUE, cli_abort_if_not(FALSE))

  # Report errors from the function that called `make_msg()`.
  test_msg <- function(x, verbose = TRUE) {
    make_msg(type = "danger", verbose, x)
  }

  expect_snapshot(test_msg("Testing fun reference.", verbose = TRUE))
  expect_snapshot(
    error = TRUE,
    test_msg("Testing fun reference with error.", verbose = 1)
  )
  expect_snapshot(
    error = TRUE,
    test_msg("Testing missing verbose.", verbose = NA)
  )
  expect_snapshot(
    error = TRUE,
    test_msg("Testing empty verbose.", verbose = logical())
  )
  expect_snapshot(
    error = TRUE,
    test_msg("Testing vector verbose.", verbose = c(TRUE, FALSE))
  )
})
