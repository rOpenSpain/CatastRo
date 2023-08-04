#' @title Reference SRS codes for **CatastRo** APIs
#'
#' @family databases
#' @family WFS
#' @family OVCCoordenadas
#'
#' @name catr_srs_values
#'
#' @docType data
#'
#' @description
#' A tibble including the valid SRS (also known as CRS) values that may be
#' used on each API service.
#'
#' @references
#' * [OVCCoordenadas](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx)
#' * [INSPIRE WFS 
#' Service](https://www.catastro.minhap.es/webinspire/index.html)
#'
#' @encoding UTF-8
#'
#' @format
#' A tibble with `r nrow(CatastRo::catr_srs_values)` rows and columns:
#' \describe{
#'   \item{SRS}{Spatial Reference System (CRS) value, identified by the
#'     corresponding EPSG code.}
#'   \item{Description}{Description of the SRS/EPSG code.}
#'   \item{ovc_service}{Logical. Is this code valid on OVC services?}
#'   \item{wfs_service}{Logical. Is this code valid on INSPIRE WFS services?}
#' }
#' @details
#'
#' ```{r, echo=FALSE}
#'
#' tb <- CatastRo::catr_srs_values
#'
#' knitr::kable(tb)
#'
#'
#' ```
#'
#' @examples
#' data(catr_srs_values)
#'
#' # OVC valid codes
#' library(dplyr)
#'
#' catr_srs_values %>% filter(ovc_service == TRUE)
#'
#' # WFS valid codes
#'
#' catr_srs_values %>% filter(ovc_service == TRUE)
NULL
