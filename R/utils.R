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
  alert(msg, .envir = .envir)
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
match_arg_pretty <- function(arg, choices, call = parent.frame()) {
  arg_name <- as.character(substitute(arg)) # nolint

  if (missing(choices)) {
    sys_par <- sys.parent()
    formal_args <- formals(sys.function(sys_par))
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
    # Create the error message.
    if (length(choices) == 1) {
      msg <- paste0("{.str ", choices, "}")
    } else {
      l_choices <- length(choices)
      msg <- paste0("{.str ", choices[-l_choices], "}", collapse = ", ")
      msg <- paste0(msg, " or {.str ", choices[l_choices], "}")
      # Add "one of" to the beginning.
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
      call = call
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

validate_non_empty_arg <- function(
  arg,
  call = parent.frame(1),
  arg_name = as.character(substitute(arg))
) {
  if (missing(arg)) {
    cli::cli_abort("{.arg {arg_name}} cannot be missing.", call = call)
  }

  is_empty <- is.null(arg) ||
    length(arg) == 0L ||
    (is.atomic(arg) && anyNA(arg)) ||
    (is.character(arg) && !all(nzchar(trimws(arg))))

  if (is_empty) {
    cli::cli_abort("{.arg {arg_name}} cannot be empty.", call = call)
  }

  arg
}

validate_scalar_arg <- function(arg, call = parent.frame(1)) {
  arg_name <- as.character(substitute(arg)) # nolint
  arg <- validate_non_empty_arg(arg, call = call, arg_name = arg_name)

  if (!((is.character(arg) || is.numeric(arg)) && length(arg) == 1L)) {
    cli::cli_abort(
      "{.arg {arg_name}} must be a single string or number.",
      call = call
    )
  }

  arg
}

validate_coordinate_arg <- function(arg, call = parent.frame(1)) {
  arg_name <- as.character(substitute(arg)) # nolint
  arg <- validate_non_empty_arg(arg, call = call, arg_name = arg_name)

  if (!(is.numeric(arg) && length(arg) == 1L && is.finite(arg))) {
    cli::cli_abort(
      "{.arg {arg_name}} must be a single finite number.",
      call = call
    )
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

validate_vector_with_srs <- function(
  x,
  srs,
  expected_length,
  call = parent.frame()
) {
  if (!is.numeric(x) || length(x) != expected_length || !all(is.finite(x))) {
    cli::cli_abort(
      paste0(
        "{.arg x} must be a finite numeric vector of length ",
        "{.val {expected_length}}."
      ),
      call = call
    )
  }
  if (is.null(srs)) {
    cli::cli_abort(
      paste0(
        "You must also provide {.arg srs} when {.arg x} is ",
        "{.obj_type_friendly {x}}."
      ),
      call = call
    )
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
