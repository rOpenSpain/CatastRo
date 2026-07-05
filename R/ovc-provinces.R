#' OVCCallejero: get province codes
#'
#' @description
#' Query the OVCCallejero
#' [ConsultaProvincia](`r ovcurl("prov")`) service to retrieve provinces and
#' their Spanish Cadastre codes.
#'
#' @inheritParams catr_ovc_get_cpmrc
#' @return A [tibble][tibble::tbl_df] with province names and codes. Returns
#'   `NULL` if the request fails.
#'
#' @references
#' [ConsultaProvincia](`r ovcurl("prov")`).
#'
#' @family ovc_street_directory
#' @family search
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' \donttest{
#' catr_ovc_get_cod_provinces()
#' }
#'
catr_ovc_get_cod_provinces <- function(verbose = FALSE) {
  # Build the query URL.
  api_entry <- ovc_base_url(
    "/ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaProvincia?"
  )

  # Extract results.
  content_list <- ovc_get_xml(api_entry, verbose = verbose)
  if (is.null(content_list)) {
    return(NULL)
  }

  res <- content_list[["consulta_provinciero"]][["provinciero"]]
  ovc_as_tibble_rows(res)
}
