test_that("catr_read_atom() preserves each entry update date", {
  feed <- withr::local_tempfile(
    lines = c(
      "<feed>",
      "  <entry>",
      "    <title>Office one</title>",
      "    <link href='https://example.com/one'/>",
      "    <updated>2024-01-01T00:00:00Z</updated>",
      "    <content><div><div>001-MUNICIPALITY ONE</div></div></content>",
      "  </entry>",
      "  <entry>",
      "    <title>Office two</title>",
      "    <link href='https://example.com/two'/>",
      "    <updated>2025-02-02T00:00:00Z</updated>",
      "    <content><div><div>002-MUNICIPALITY TWO</div></div></content>",
      "  </entry>",
      "</feed>"
    )
  )

  top <- catr_read_atom(feed, top = TRUE)
  nested <- catr_read_atom(feed, top = FALSE)

  expected <- as.POSIXct(
    c("2024-01-01 00:00:00", "2025-02-02 00:00:00"),
    tz = "UTC"
  )
  expect_equal(top$date, expected)
  expect_equal(nested$date, expected)
})

test_that("catr_atom_read_db_to() propagates request options", {
  seen <- NULL
  all_fn <- function(update_cache, cache_dir, verbose) {
    seen <<- list(
      update_cache = update_cache,
      cache_dir = cache_dir,
      verbose = verbose
    )
    dplyr::tibble(
      territorial_office = "Madrid",
      url = "https://example.com/madrid"
    )
  }

  local_mocked_bindings(
    download_url = function(...) "feed.xml",
    catr_read_atom = function(...) {
      dplyr::tibble(
        title = "28001-MADRID",
        url = "https://example.com/data",
        date = as.POSIXct("2025-01-01", tz = "UTC")
      )
    }
  )

  out <- catr_atom_read_db_to(
    "Madrid",
    all_fn,
    update_cache = TRUE,
    cache_dir = "cache",
    verbose = TRUE
  )

  expect_identical(
    seen,
    list(update_cache = TRUE, cache_dir = "cache", verbose = TRUE)
  )
  expect_named(out, c("munic", "url", "date"))
})

test_that("catr_atom_select_munic() respects one exact office match", {
  all <- dplyr::tibble(
    territorial_office = c("Segovia", "Madrid"),
    munic = c("40146-MELQUE", "28079-MADRID")
  )

  out <- catr_atom_select_munic(
    all,
    munic = "MELQUE",
    to = "Segovia",
    db_all_call = "catr_atom_get_address_db_all"
  )

  expect_identical(out$territorial_office, "Segovia")
  expect_identical(out$munic, "40146-MELQUE")
})
