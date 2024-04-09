#' @title Reference SRS codes for \CRANpkg{CatastRo} APIs
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
#' A [`tibble`][tibble::tibble] including the valid SRS (also known as CRS)
#' values that may be used on each API service. The values are provided
#' as [EPSG
#' codes](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset).
#'
#' @references
#'
#' ```{r, echo=FALSE, results='asis'}
#'
#' cat(paste0("* [OVCCoordenadas](https://ovc.catastro.meh.es/",
#' "ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx)."))
#'
#' ```
#'
#' * [INSPIRE WFS
#' Service](https://www.catastro.minhap.es/webinspire/index.html).
#'
#' @encoding UTF-8
#'
#' @seealso [sf::st_crs()].
#'
#' @format
#' A [`tibble`][tibble::tibble] with `r nrow(CatastRo::catr_srs_values)` rows
#' and columns:
#' \describe{
#'   \item{SRS}{Spatial Reference System (CRS) value, identified by the
#'     corresponding
#'     [EPSG](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset)
#'     code.}
#'   \item{Description}{Description of the SRS/EPSG code.}
#'   \item{ovc_service}{Logical. Is this code valid on OVC services?}
#'   \item{wfs_service}{Logical. Is this code valid on INSPIRE WFS services?}
#' }
#' @details
#'
#' ```{r, echo=FALSE}
#'
#' tb <- CatastRo::catr_srs_values
#' for(i in seq_len(ncol(tb))){
#'   tb[,i] <- as.vector(paste0("`", tb[[i]], "`"))
#' }
#' nm <- paste0("**", names(tb), "**")
#' knitr::kable(tb, col.names = nm, caption = "Content of [catr_srs_values]")
#'
#' ```
#'
#' @examples
#' data("catr_srs_values")
#'
#' # OVC valid codes
#' library(dplyr)
#'
#' catr_srs_values %>% filter(ovc_service == TRUE)
#'
#' # WFS valid codes
#'
#' catr_srs_values %>% filter(wfs_service == TRUE)
#'
#' # Use with sf::st_crs()
#'
#' catr_srs_values %>%
#'   filter(wfs_service == TRUE & ovc_service == TRUE) %>%
#'   print() %>%
#'   # First value
#'   slice_head(n = 1) %>%
#'   pull(SRS) %>%
#'   # As crs
#'   sf::st_crs(.)
NULL
