#' Create messages based on type
#'
#' @param type Character string. Type of message. Accepted values are
#'   `"generic"`, `"success"`, `"warning"`, `"danger"`, or `"info"`.
#'
#' @param verbose Logical. Whether to print messages to the console.
#' @param ... Character strings to combine into the message.
#'
#' @return
#' Invisibly returns `NULL`. Prints messages to console if `verbose` is
#' `TRUE`.
#' @encoding UTF-8
#'
#' @noRd
make_msg <- function(type = "generic", verbose, ...) {
  if (!verbose) {
    return(invisible())
  }
  dots <- list(...)
  msg <- paste(dots, collapse = " ")

  if (type == "generic") {
    cli::cli_alert(msg)
  }
  if (type == "success") {
    cli::cli_alert_success(msg)
  }
  if (type == "warning") {
    cli::cli_alert_warning(msg)
  }
  if (type == "danger") {
    cli::cli_alert_danger(msg)
  }
  if (type == "info") {
    cli::cli_alert_info(msg)
  }
  invisible()
}

#' Match argument with pretty error message
#'
#' @param arg Argument to match.
#' @param choices Possible choices for the argument.
#'
#' @return
#' The matched argument.
#'
#' @noRd
match_arg_pretty <- function(arg, choices) {
  arg_name <- as.character(substitute(arg)) # nolint

  if (missing(choices)) {
    formal_args <- formals(sys.function(sys_par <- sys.parent()))
    choices <- eval(
      formal_args[[as.character(substitute(arg))]],
      envir = sys.frame(sys_par)
    )
  }
  choices <- as.character(choices)

  if (is.null(arg)) {
    return(choices[1L])
  }

  arg <- as.character(arg)

  if (identical(arg, choices)) {
    return(arg[1])
  }

  lmatch <- match(arg, choices)
  # Hint
  aproxmatch <- pmatch(arg, choices)[1]

  if (length(arg) > 1 || is.na(lmatch)) {
    # Create error message
    if (length(choices) == 1) {
      msg <- paste0("{.str ", choices, "}")
    } else {
      l_choices <- length(choices)
      msg <- paste0("{.str ", choices[-l_choices], "}", collapse = ", ")
      msg <- paste0(msg, " or {.str ", choices[l_choices], "}")
      # Add one of at the begining
      msg <- paste0("one of ", msg)
    }

    msg <- paste0(msg, ", not ")
    bad_arg <- paste0("{.str ", arg, "}", collapse = " or ")
    msg <- paste0(msg, bad_arg, ".")

    # Maybe is a regex?
    reg_msg <- NULL
    if (!is.na(aproxmatch)) {
      aprox <- choices[aproxmatch]
      aprox_val <- paste0("{.str ", aprox, "}", collapse = " or ")
      reg_msg <- paste0("Did you mean ", aprox_val, "?")
    }

    cli::cli_abort(
      c(
        paste0("{.arg {arg_name}} should be ", msg),
        "i" = reg_msg
      ),
      call = NULL
    )
  }

  choices[lmatch]
}

ensure_null <- function(x) {
  x_init <- x
  x <- as.vector(x)
  x[is.null(x)] <- NA
  x[is.na(x)] <- NA
  x[nchar(as.character(x)) == 0] <- NA
  if (all(is.na(x))) {
    return(NULL)
  }

  x_init
}

validate_non_empty_arg <- function(arg, call = parent.frame(1)) {
  arg_name <- as.character(substitute(arg)) # nolint

  if (missing(arg)) {
    cli::cli_abort("{.arg {arg_name}} can't be missing.", call = call)
  }

  arg
}
