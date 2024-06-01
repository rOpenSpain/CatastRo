#' OVCCallejero: Extract the code of a municipality
#'
#' @description
#' Implementation of the OVCCallejero service
#' [ConsultaMunicipioCodigos](`r ovcurl("mun")`).
#'
#' Return the names and codes of a municipality. Returns both the codes as per
#' the Cadastre and as per the INE (National Statistics Institute).
#'
#' @references
#' [ConsultaMunicipioCodigos](`r ovcurl("mun")`).
#'
#' @family OVCCallejero
#' @family search
#'
#'
#' @return A [`tibble`][tibble::tibble]. See **Details**
#'
#' @export
#'
#' @seealso [mapSpain::esp_get_munic()] to get shapes of municipalities,
#' including the INE code.
#'
#' @inheritParams catr_ovc_get_cpmrc
#' @param cpro The code of a province, as provided by
#'   [catr_ovc_get_cod_provinces()].
#' @param cmun Code of a municipality, as recorded on the Spanish Cadastre.
#' @param cmun_ine Code of a municipality, as recorded on National Statistics
#'   Institute. See [INE: List of
#' municipalities](https://www.ine.es/daco/daco42/codmun/codmun00i.htm)
#'
#' @details
#' Parameter `cpro` is mandatory. Either `cmun` or `cmun_ine` should be
#' provided.
#'
#' On a successful query, the function returns a [`tibble`][tibble::tibble]
#' with one row including the following columns:
#' * `munic`: Name of the municipality as per the Cadastre.
#' * `catr_to`: Cadastral territorial office code.
#' * `catr_munic`: Municipality code as recorded on the Cadastre.
#' * `catrcode`: Full Cadastral code for the municipality.
#' * `cpro`: Province code as per the INE.
#' * `catr_munic`: Municipality code as per the INE.
#' * `catrcode`: Full INE code for the municipality.
#' * Rest of fields: Check the API Docs.
#'
#'
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
#' \donttest{
#' # Get municipality by cadastal code
#' ab <- catr_ovc_get_cod_munic(2, 900)
#'
#' ab
#'
#' # Same query using the INE code
#'
#' ab2 <- catr_ovc_get_cod_munic(2, cmun_ine = 3)
#'
#' ab2
#' }
#'
catr_ovc_get_cod_munic <- function(cpro, cmun = NULL, cmun_ine = NULL,
                                   verbose = FALSE) {
  if (is.null(cmun) && is.null(cmun_ine)) {
    stop("Please provide a value either on 'cmun' or on 'cmun_ine'.")
  }

  # Prepare query
  ##  Build url
  api_entry <- paste0(
    "http://ovc.catastro.meh.es/ovcservweb/",
    "/ovcswlocalizacionrc/ovccallejerocodigos.asmx/ConsultaMunicipioCodigos?"
  )

  # Prepare params
  parms <- list(
    "CodigoProvincia" = cpro,
    "CodigoMunicipio" = cmun,
    "CodigoMunicipioIne" = cmun_ine
  )

  q <- paste0(names(parms), "=", parms, collapse = "&")
  q <- gsub("NULL", "", q)

  api_entry <- paste0(api_entry, q)

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
  err <- content_list[[1]]


  if (("lerr" %in% names(err))) {
    df <- tibble::as_tibble_row(unlist(err["lerr"]))

    message("Error code: ", df[1, 1], ". ", df[1, 2])

    empty <- tibble::tibble(
      name = NA
    )

    return(empty)
  }

  res <- content_list[[1]][["municipiero"]]

  df <- tibble::as_tibble_row(unlist(res))

  # Fix names
  newnames <- vapply(names(df), function(x) {
    rev(unlist(strsplit(x, ".", fixed = TRUE)))[1]
  }, FUN.VALUE = character(1))

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
    catcodes, inecodes,
    df
  )

  return(overall)
}
