#' OVCCallejero: Extract the code of a municipality
#'
#' @description
#' Implementation of the OVCCallejero service
#' [ConsultaMunicipioCodigos](`r ovcurl("mun")`). Returns names and codes
#' of a municipality as per the Cadastre and the INE (National Statistics
#' Institute).
#'
#' @encoding UTF-8
#' @family OVCCallejero
#' @family search
#' @export
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
#' @param cpro The code of a province, as provided by
#'   [catr_ovc_get_cod_provinces()].
#' @param cmun,cmun_ine Code of a municipality, as recorded on the Spanish
#'   Cadastre (`cmun`) or the National Statistics Institute. Either `cmun` or
#'   `cmun_ine` must be provided.
#'
#' @details
#' On a successful query, the function returns a [tibble][tibble::tbl_df]
#' with one row including the following columns:
#'
#' - `munic`: Name of the municipality as per the Cadastre.
#' - `catr_to`: Cadastral territorial office code.
#' - `catr_munic`: Municipality code as recorded on the Cadastre.
#' - `catrcode`: Full Cadastral code for the municipality.
#' - `cpro`: Province code as per the INE.
#' - `cmun`: Municipality code as per the INE.
#' - `inecode`: Full INE code for the municipality.
#' - Rest of fields: Check the API Docs.
#'
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
      "Please provide a non-{.val NULL} value either on {.or {.arg {my_arg}}}."
    )
  }

  # Prepare query
  ##  Build url
  api_entry <- paste0(
    "http://ovc.catastro.meh.es/ovcservweb/",
    "/ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaMunicipioCodigos?",
    "/CodigoProvincia=&CodigoMunicipio=&CodigoMunicipioIne="
  )

  api_entry <- httr2::url_modify_query(
    api_entry,
    CodigoProvincia = cpro,
    CodigoMunicipio = ifelse(is.null(cmun), "", cmun),
    CodigoMunicipioIne = ifelse(is.null(cmun_ine), "", cmun_ine)
  )

  # Extract results
  resp <- get_request_body(api_entry, verbose = verbose)

  if (is.null(resp)) {
    return(NULL)
  }

  content_list <- xml2::as_list(httr2::resp_body_xml(resp))

  # Check API custom error
  err <- content_list[[1]]

  if (("lerr" %in% names(err))) {
    df <- tibble::as_tibble_row(unlist(err["lerr"]))

    cli::cli_alert_danger(
      paste0("Error code: ", df[1, 1], ". ", df[1, 2])
    )

    empty <- tibble::tibble(
      name = NA
    )

    return(empty)
  }

  res <- content_list[[1]][["municipiero"]]

  df <- tibble::as_tibble_row(unlist(res))

  # Fix names
  newnames <- vapply(
    names(df),
    function(x) {
      rev(unlist(strsplit(x, ".", fixed = TRUE)))[1]
    },
    FUN.VALUE = character(1)
  )

  names(df) <- newnames

  # Create friendly codes
  catcodes <- tibble::tibble(
    munic = df$nm,
    catr_to = sprintf("%02d", as.integer(df$cd)),
    catr_munic = sprintf("%03d", as.integer(df$cmc))
  )

  catcodes$catrcode <- paste0(catcodes$catr_to, catcodes$catr_munic)
  inecodes <- tibble::tibble(
    cpro = sprintf("%02d", as.integer(df$cp)),
    cmun = sprintf("%03d", as.integer(df$cm))
  )

  inecodes$inecode <- paste0(inecodes$cpro, inecodes$cmun)

  overall <- dplyr::bind_cols(
    catcodes,
    inecodes,
    df
  )

  overall
}
