#' Read an ATOM feed
#'
#' @param file Path to an ATOM feed file.
#' @param top Logical. Whether to extract top-level entries.
#' @param encoding Character string specifying the file encoding. Defaults to
#'   `"UTF-8"`.
#'
#' @return A [tibble][tibble::tbl_df] containing ATOM feed entries.
#'
#' @noRd
catr_read_atom <- function(file, top = TRUE, encoding = "UTF-8") {
  # Retry without encoding when the parser fails.
  feed <- try(
    xml2::as_list(xml2::read_xml(
      file,
      options = "NOCDATA",
      encoding = encoding
    )),
    silent = TRUE
  )

  # Try without encoding on error.
  if (inherits(feed, "try-error")) {
    feed <- xml2::as_list(xml2::read_xml(file, options = "NOCDATA"))
  }

  # Extract feed entries.
  feed <- feed$feed
  feed <- feed[names(feed) == "entry"]

  # Convert feed entries to rows.
  if (top) {
    tbl_all <- lapply(feed, function(x) {
      title <- unlist(x$title)
      url <- unlist(attr(x$link, "href"))
      date <- as.POSIXct(unlist(feed[1]$entry$updated))
      value <- unlist(x$content$div$div)

      # Clean values.
      value <- trimws(gsub("\\n|\\t", "", value))
      value <- value[grepl("^[0-9]", value)]

      tbl <- tibble::tibble(
        title = trimws(title),
        url = trimws(url),
        value = trimws(value),
        date = date
      )

      tbl
    })
  } else {
    tbl_all <- lapply(feed, function(x) {
      title <- unlist(x$title)
      url <- unlist(attr(x$link, "href"))
      date <- as.POSIXct(unlist(feed[1]$entry$updated))

      tbl <- tibble::tibble(
        title = trimws(title),
        url = trimws(url),
        date = date
      )

      tbl
    })
  }

  tbl_all <- dplyr::bind_rows(tbl_all)

  tbl_all
}

#' Read a summary ATOM table
#'
#' @noRd
catr_atom_read_db_all <- function(
  api_entry,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  file_local <- download_url(
    url = api_entry,
    cache_dir = cache_dir,
    subdir = "databases",
    update_cache = update_cache,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  tbl <- catr_read_atom(file_local, top = TRUE)
  names(tbl) <- c("territorial_office", "url", "munic", "date")

  tbl
}

#' Read a territorial office ATOM table
#'
#' @noRd
catr_atom_read_db_to <- function(
  to,
  all_fn,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  all <- all_fn(cache_dir = cache_dir)

  if (is.null(all)) {
    return(NULL)
  }

  alldist <- unique(all[, c("territorial_office", "url")])

  # Escape parentheses in territorial office names for matching.
  to <- gsub("\\(|\\)", "", to)
  allto <- gsub("\\(|\\)", "", alldist$territorial_office)

  to_loc <- ensure_null(grep(to, allto, ignore.case = TRUE))
  if (is.null(to_loc)) {
    cli::cli_alert_warning("No territorial office matched pattern {.str {to}}.")
    return(NULL)
  }

  # Compute string distances for territorial office matching.
  with_d <- data.frame(
    to = alldist$territorial_office,
    dist = as.vector(adist(to, alldist$territorial_office))
  )
  with_d <- with_d[to_loc, ]
  with_d <- with_d[order(with_d$dist), ]

  tb <- with_d$to

  if (length(tb) > 1) {
    cli::cli_alert_info(
      "Found {length(tb)} territorial offices matching {.str {to}}."
    )

    cli::cli_alert_success("Using closest match {.str {tb[1]}}.")
    cli::cli_alert_info("Other matches:")
    bullets <- tb[-1]
    bullets <- paste0("{.str ", bullets, "}")
    names(bullets) <- rep(" ", length(bullets))
    cli::cli_bullets(bullets)

    tb <- tb[1]
  }

  make_msg(
    "info",
    verbose,
    paste0("Retrieving information for {.str ", tb, "}.")
  )

  api_entry <- as.character(alldist[alldist$territorial_office == tb, "url"])

  file_local <- download_url(
    url = api_entry,
    cache_dir = cache_dir,
    subdir = "databases",
    update_cache = update_cache,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  tbl <- catr_read_atom(file_local, top = FALSE)
  names(tbl) <- c("munic", "url", "date")

  tbl
}

#' Select a municipality from an ATOM summary table
#'
#' @noRd
catr_atom_select_munic <- function(
  all,
  munic,
  to = NULL,
  db_all_call,
  verbose = FALSE
) {
  if (!is.null(to)) {
    linesto <- grep(to, all$territorial_office, ignore.case = TRUE)

    # Filter by territorial office if matches are found.
    if (length(linesto) > 1) {
      all <- all[linesto, ]
    } else {
      if (verbose) {
        cli::cli_alert_warning(paste0(
          "Ignoring {.arg to} because no territorial office ",
          "matched {.str {to}}."
        ))
      }
    }
  }

  to_loc <- ensure_null(grep(munic, all$munic, ignore.case = TRUE))

  if (is.null(to_loc)) {
    cli::cli_alert_warning("No municipality matched pattern {.str {munic}}.")
    cli::cli_alert_info(paste0(
      "Check available municipalities with ",
      "{.run CatastRo::",
      db_all_call,
      "()}."
    ))
    return(NULL)
  }

  # Compute string distances for municipality matching.
  with_d <- data.frame(
    munic = all$munic,
    territorial_office = all$territorial_office,
    dist = as.vector(adist(munic, all$munic))
  )
  with_d <- with_d[to_loc, ]
  tb <- with_d[order(with_d$dist), ]

  if (nrow(tb) > 1) {
    cli::cli_alert_info(
      "Found {nrow(tb)} municipalities matching {.str {munic}}."
    )

    cli::cli_alert_success("Using closest match {.str {tb[1,]$munic}}.")
    cli::cli_alert_info("Other matches:")
    bullets <- tb[-1, ]$munic
    bullets <- paste0("{.str ", bullets, "}")
    names(bullets) <- rep(" ", length(bullets))
    cli::cli_bullets(bullets)

    tb <- tb[1, ]
  }

  make_msg(
    "info",
    verbose,
    paste0("Retrieving information for {.str ", tb$munic, "}.")
  )

  tb
}

#' Find a municipality data URL in a territorial office ATOM table
#'
#' @noRd
catr_atom_get_munic_url <- function(municurls, munic) {
  ref <- unlist(strsplit(munic, "-"))[1]
  api_entry <- municurls[grepl(ref, municurls$munic, ignore.case = TRUE), ]$url

  URLencode(api_entry)
}
