#' OVCCallejero: Extract a list of provinces with their codes
#'
#' @description
#' Implementation of the OVCCallejero service
#' [ConsultaProvincia](`r ovcurl("prov")`). Returns a list of provinces
#' included in the Spanish Cadastre.
#'
#' @encoding UTF-8
#' @family OVCCallejero
#' @family search
#' @inheritParams catr_ovc_get_cpmrc
#' @export
#'
#' @references
#' [ConsultaProvincia](`r ovcurl("prov")`).
#'
#' @return A [tibble][tibble::tbl_df].
#'
#' @examplesIf run_example()
#' \donttest{
#' catr_ovc_get_cod_provinces()
#' }
#'
catr_ovc_get_cod_provinces <- function(verbose = FALSE) {
  # Prepare query
  ##  Build url
  api_entry <- paste0(
    "http://ovc.catastro.meh.es/ovcservweb/",
    "/ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaProvincia?"
  )

  # Extract results
  resp <- get_request_body(api_entry, verbose = verbose)

  if (is.null(resp)) {
    return(NULL)
  }

  content_list <- xml2::as_list(httr2::resp_body_xml(resp))

  res <- content_list[["consulta_provinciero"]][["provinciero"]]

  # Get a list of tibbles
  res_tibble <- lapply(res, function(x) {
    df <- tibble::as_tibble_row(unlist(x))
    df
  })

  # Bind all
  overall <- dplyr::bind_rows(res_tibble)

  overall
}
