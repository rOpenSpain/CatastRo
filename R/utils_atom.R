catr_read_atom <- function(file, top = TRUE, encoding = "UTF-8") {

  # Encoding error sometimes, thanks @dr_xeo
  feed <- try(xml2::as_list(xml2::read_xml(file,
    options = "NOCDATA",
    encoding = encoding
  )), silent = TRUE)

  # On error try without encoding
  if (inherits(feed, "try-error")) {
    feed <- xml2::as_list(xml2::read_xml(file,
      options = "NOCDATA"
    ))
  }

  # Prepare data
  feed <- feed$feed
  feed <- feed[names(feed) == "entry"]

  # Convert to tibble
  if (top) {
    tbl_all <- lapply(feed, function(x) {
      title <- unlist(x$title)
      url <- unlist(attr(x$link, "href"))
      date <- as.POSIXct(unlist(feed[1]$entry$updated))
      value <- unlist(x$content$div$div)

      # Clean
      value <- trimws(gsub("\\n|\\t", "", value))
      value <- value[grepl("^[0-9]", value)]


      tbl <- tibble::tibble(
        title = title,
        url = url,
        value = value,
        date = date
      )

      return(tbl)
    })
  } else {
    tbl_all <- lapply(feed, function(x) {
      title <- unlist(x$title)
      url <- unlist(attr(x$link, "href"))
      date <- as.POSIXct(unlist(feed[1]$entry$updated))

      tbl <- tibble::tibble(
        title = title,
        url = url,
        date = date
      )

      return(tbl)
    })
  }

  tbl_all <- dplyr::bind_rows(tbl_all)

  return(tbl_all)
}
