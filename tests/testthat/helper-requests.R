mock_404_response <- function(...) {
  httr2::response(status_code = 404)
}
