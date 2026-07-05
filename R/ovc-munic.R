#' OVCCallejero: get municipality codes
#'
#' @description
#' Query the OVCCallejero
#' [ConsultaMunicipioCodigos](`r ovcurl("mun")`) service to retrieve
#' municipality names and codes from the Spanish Cadastre and the National
#' Statistics Institute (INE).
#'
#' @details
#' On a successful query, this function returns a [tibble][dplyr::tbl_df]
#' with one row including the following columns:
#'
#' - `munic`: Municipality name used by the Spanish Cadastre.
#' - `catr_to`: Cadastral territorial office code.
#' - `catr_munic`: Municipality code as recorded by the Cadastre.
#' - `catrcode`: Full cadastral code for the municipality.
#' - `cpro`: Province code according to the INE.
#' - `cmun`: Municipality code according to the INE.
#' - `inecode`: Full INE code for the municipality.
#' - Remaining fields: See the API documentation.
#'
#' @param cpro Province code returned by
#'   [catr_ovc_get_cod_provinces()].
#' @param cmun,cmun_ine Municipality code as recorded by the Spanish
#'   Cadastre (`cmun`) or the National Statistics Institute. Either `cmun` or
#'   `cmun_ine` must be provided.
#'
#' @inheritParams catr_ovc_get_cpmrc
#' @inherit catr_ovc_get_cpmrc return
#'
#' @references
#' [ConsultaMunicipioCodigos](`r ovcurl("mun")`).
#'
#' @seealso
#' [mapSpain::esp_get_munic_siane()] to get shapes of municipalities, including
#' the INE code.
#'
#' @family ovc_street_directory
#' @family search
#' @encoding UTF-8
#' @export
#' @examplesIf run_example()
#' \donttest{
#' # Get municipality by cadastral code
#' ab <- catr_ovc_get_cod_munic(cpro = 2, cmun = 900)
#'
#' ab
#'
#' # Same query using the INE code
#'
#' ab2 <- catr_ovc_get_cod_munic(cpro = 2, cmun_ine = 3)
#'
#' ab2
#' }
#'
catr_ovc_get_cod_munic <- function(
  cpro,
  cmun = NULL,
  cmun_ine = NULL,
  verbose = FALSE
) {
  cpro <- validate_non_empty_arg(cpro)
  cmun <- ensure_null(cmun)
  cmun_ine <- ensure_null(cmun_ine)

  munis <- c(cmun, cmun_ine)

  if (is.null(munis)) {
    my_arg <- c("cmun", "cmun_ine") # nolint
    cli::cli_abort(
      "Provide a non-{.val NULL} value for either {.or {.arg {my_arg}}}."
    )
  }

  # Build the query URL.
  api_entry <- ovc_base_url(paste0(
    "/ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaMunicipioCodigos?",
    "/CodigoProvincia=&CodigoMunicipio=&CodigoMunicipioIne="
  ))

  api_entry <- httr2::url_modify_query(
    api_entry,
    CodigoProvincia = cpro,
    CodigoMunicipio = ifelse(is.null(cmun), "", cmun),
    CodigoMunicipioIne = ifelse(is.null(cmun_ine), "", cmun_ine)
  )

  # Extract results.
  content_list <- ovc_get_xml(api_entry, verbose = verbose)
  if (is.null(content_list)) {
    return(NULL)
  }

  # Check for API-level errors.
  err <- content_list[[1]]

  if (ovc_has_error(err)) {
    ovc_report_error(err)
    empty <- dplyr::tibble(name = NA)

    return(empty)
  }

  res <- content_list[[1]][["municipiero"]]

  df <- ovc_as_tibble_row(res)

  # Keep only leaf names from nested XML paths.
  newnames <- vapply(
    names(df),
    function(x) {
      rev(unlist(strsplit(x, ".", fixed = TRUE)))[1]
    },
    FUN.VALUE = character(1)
  )

  names(df) <- newnames

  # Create normalized cadastral and INE codes.
  catcodes <- dplyr::tibble(
    munic = df$nm,
    catr_to = sprintf("%02d", as.integer(df$cd)),
    catr_munic = sprintf("%03d", as.integer(df$cmc))
  )

  catcodes$catrcode <- paste0(catcodes$catr_to, catcodes$catr_munic)
  inecodes <- dplyr::tibble(
    cpro = sprintf("%02d", as.integer(df$cp)),
    cmun = sprintf("%03d", as.integer(df$cm))
  )

  inecodes$inecode <- paste0(inecodes$cpro, inecodes$cmun)

  overall <- dplyr::bind_cols(catcodes, inecodes, df)

  overall
}
