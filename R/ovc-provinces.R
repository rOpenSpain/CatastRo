#' OVCCallejero: extract provinces with their codes
#'
#' @description
#' Implementation of the OVCCallejero service
#' [ConsultaProvincia](`r ovcurl("prov")`). Returns a list of provinces
#' included in the Spanish Cadastre.
#'
#' @inheritParams catr_ovc_get_cpmrc
#' @return A [tibble][tibble::tbl_df].
#'
#' @references
#' [ConsultaProvincia](`r ovcurl("prov")`).
#'
#' @family OVCCallejero
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
