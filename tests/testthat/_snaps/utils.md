# Messages

    Code
      make_msg("generic", TRUE, "Hi", "I am a generic.", "See {.var avar}.")
    Message
      > Hi I am a generic. See `avar`.

---

    Code
      make_msg("info", TRUE, "Info here.", "See {.pkg igoR}.")
    Message
      i Info here. See igoR.

---

    Code
      make_msg("warning", TRUE, "Caution! A warning.", "But still OK.")
    Message
      ! Caution! A warning. But still OK.

---

    Code
      make_msg("danger", TRUE, "OOPS!", "I did it again :(")
    Message
      x OOPS! I did it again :(

---

    Code
      make_msg("success", TRUE, "Hooray!", "5/5 ,)")
    Message
      v Hooray! 5/5 ,)

# Pretty match

    Code
      my_fun("error here")
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "error here".

---

    Code
      my_fun(c("an", "error"))
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "an" or "error".

---

    Code
      my_fun("5")
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "5".
      i Did you mean "5000"?

---

    Code
      my_fun("00")
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "00".

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` must be "20", not "1" or "2".

---

    Code
      my_fun3("3")
    Condition
      Error:
      ! `an_arg` must be one of "30" or "20", not "3".
      i Did you mean "30"?

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` must be "20", not "1" or "2".

# Not empty

    Code
      a_fun()
    Condition
      Error in `a_fun()`:
      ! `a` cannot be missing.

---

    Code
      a_fun(a = 1)
    Condition
      Error in `a_fun()`:
      ! `b` cannot be missing.

# cli_abort_if_not validates conditions

    Code
      cli_abort_if_not(`Message supports {.cls inline} {.str markup}.` = is.logical(1))
    Condition
      Error:
      ! Message supports <inline> "markup".

---

    Code
      cli_abort_if_not(`Missing conditions fail.` = NA)
    Condition
      Error:
      ! Missing conditions fail.

---

    Code
      cli_abort_if_not(`Empty conditions fail.` = logical())
    Condition
      Error:
      ! Empty conditions fail.

---

    Code
      cli_abort_if_not(FALSE)
    Condition
      Error:
      ! All conditions supplied to `cli_abort_if_not()` must be named.

---

    Code
      test_msg("Testing fun reference.", verbose = TRUE)
    Message
      x Testing fun reference.

---

    Code
      test_msg("Testing fun reference with error.", verbose = 1)
    Condition
      Error in `test_msg()`:
      ! `verbose` must be `TRUE` or `FALSE`.

---

    Code
      test_msg("Testing missing verbose.", verbose = NA)
    Condition
      Error in `test_msg()`:
      ! `verbose` must be `TRUE` or `FALSE`.

---

    Code
      test_msg("Testing empty verbose.", verbose = logical())
    Condition
      Error in `test_msg()`:
      ! `verbose` must be `TRUE` or `FALSE`.

---

    Code
      test_msg("Testing vector verbose.", verbose = c(TRUE, FALSE))
    Condition
      Error in `test_msg()`:
      ! `verbose` must be `TRUE` or `FALSE`.

