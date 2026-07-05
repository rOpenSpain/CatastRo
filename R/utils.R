#' Display a message by type
#'
#' @param type Character string specifying the message type. Accepted values are
#'   `"generic"`, `"success"`, `"warning"`, `"danger"` or `"info"`.
#'
#' @param verbose Logical. Whether to display the message.
#' @param ... Character strings to combine into the message.
#'
#' @return Invisibly returns `NULL`.
#' @encoding UTF-8
#'
#' @noRd
make_msg <- function(type = "generic", verbose, ..., .envir = parent.frame()) {
  cli_abort_if_not(
    "{.arg verbose} must be {.code TRUE} or {.code FALSE}." = is.logical(
      verbose
    ) &&
      length(verbose) == 1L &&
      !is.na(verbose),
    .envir = .envir
  )

  if (!verbose) {
    return(invisible())
  }
  dots <- list(...)
  msg <- paste(dots, collapse = " ")

  alert <- switch(type,
    "generic" = cli::cli_alert,
    "success" = cli::cli_alert_success,
    "warning" = cli::cli_alert_warning,
    "danger" = cli::cli_alert_danger,
    "info" = cli::cli_alert_info
  )
  if (is.null(alert)) {
    return(invisible())
  }
  alert(msg)
  invisible()
}

#' Match an argument with an informative error
#'
#' @param arg Argument to match.
#' @param choices Possible values for `arg`.
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
  # Build a hint for approximate matches.
  aproxmatch <- pmatch(arg, choices)[1]

  if (length(arg) > 1 || is.na(lmatch)) {
    # Create error message.
    if (length(choices) == 1) {
      msg <- paste0("{.str ", choices, "}")
    } else {
      l_choices <- length(choices)
      msg <- paste0("{.str ", choices[-l_choices], "}", collapse = ", ")
      msg <- paste0(msg, " or {.str ", choices[l_choices], "}")
      # Add "one of" at the beginning.
      msg <- paste0("one of ", msg)
    }

    msg <- paste0(msg, ", not ")
    bad_arg <- paste0("{.str ", arg, "}", collapse = " or ")
    msg <- paste0(msg, bad_arg, ".")

    # Suggest an approximate match.
    reg_msg <- NULL
    if (!is.na(aproxmatch)) {
      aprox <- choices[aproxmatch]
      aprox_val <- paste0("{.str ", aprox, "}", collapse = " or ")
      reg_msg <- paste0("Did you mean ", aprox_val, "?")
    }

    cli::cli_abort(
      c(paste0("{.arg {arg_name}} must be ", msg), "i" = reg_msg),
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
    cli::cli_abort("{.arg {arg_name}} cannot be missing.", call = call)
  }

  arg
}

warn_deprecated_cache <- function(cache, what) {
  if (lifecycle::is_present(cache)) {
    lifecycle::deprecate_warn(
      when = "1.0.0",
      what = what,
      details = "Results are always cached.",
      user_env = parent.frame(2)
    )
  }
}

validate_vector_with_srs <- function(x, srs, expected_length) {
  if (length(x) != expected_length) {
    cli::cli_abort(paste0(
      "{.arg x} must have length {.val {expected_length}}, not ",
      "{.val {length(x)}}."
    ))
  }
  if (is.null(srs)) {
    cli::cli_abort(paste0(
      "You must also provide {.arg srs} when {.arg x} is ",
      "{.obj_type_friendly {x}}."
    ))
  }

  invisible()
}

# Adapted from https://github.com/r-lib/cli/issues/672.
cli_abort_if_not <- function(
  ...,
  .call = .envir,
  .envir = parent.frame(),
  .frame = .envir
) {
  for (i in seq_len(...length())) {
    condition <- ...elt(i)
    message <- ...names()[i]

    if (is.null(message) || is.na(message) || !nzchar(message)) {
      cli::cli_abort(
        "All conditions supplied to {.fun cli_abort_if_not} must be named.",
        call = .call,
        .envir = .envir,
        .frame = .frame
      )
    }

    condition_is_true <- is.logical(condition) &&
      length(condition) > 0L &&
      !anyNA(condition) &&
      all(condition)

    if (!condition_is_true) {
      cli::cli_abort(message, call = .call, .envir = .envir, .frame = .frame)
    }
  }
  invisible(NULL)
}
