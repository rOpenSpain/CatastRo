#' OVCCallejero: Extract a list of provinces with their codes
#'
#' @description
#' Implementation of the OVCCallejero service
#' [ConsultaProvincia](`r ovcurl("prov")`).
#'
#' Return a list of the provinces included on the Spanish Cadastre.
#'
#' @references
#' [ConsultaProvincia](`r ovcurl("prov")`).
#'
#' @family OVCCallejero
#' @family search
#'
#'
#' @return A [`tibble`][tibble::tibble].
#'
#' @export
#'
#'
#'
#' @inheritParams catr_ovc_get_cpmrc
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
#' \donttest{
#'
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

  filename <- basename(tempfile(fileext = ".xml"))

  cache_dir <- tempdir()


  path <- catr_hlp_dwnload(
    api_entry, filename, cache_dir,
    verbose,
    update_cache = FALSE, cache = TRUE
  )


  # Extract results
  content <- xml2::read_xml(path)

  # Remove tempfile
  unlink(file.path(cache_dir, filename), recursive = TRUE, force = TRUE)

  content_list <- xml2::as_list(content)


  # Check API custom error
  res <- content_list[["consulta_provinciero"]][["provinciero"]]

  # Get a list of tibbles
  res_tibble <- lapply(res, function(x) {
    df <- tibble::as_tibble_row(unlist(x))
    return(df)
  })

  # Bind all
  overall <- dplyr::bind_rows(res_tibble)

  return(overall)
}
