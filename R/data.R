#' Reference SRS codes for \CRANpkg{CatastRo} services
#'
#' @description
#' A [tibble][dplyr::tbl_df] containing valid SRS values, also known as CRS
#' values, for each API service. Values are represented as
#' [EPSG codes](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset).
#'
#' @details
#' ```{r, echo=FALSE}
#' tb <- CatastRo::catr_srs_values
#' for(i in seq_len(ncol(tb))){
#'   tb[,i] <- as.vector(paste0("`", tb[[i]], "`"))
#' }
#' nm <- paste0("**", names(tb), "**")
#' knitr::kable(tb, col.names = nm, caption = "Content of [catr_srs_values]")
#'
#' ```
#'
#' @format
#' A [tibble][dplyr::tbl_df] with `r nrow(CatastRo::catr_srs_values)` rows
#' and columns:
#' \describe{
#'   \item{SRS}{Spatial reference system (SRS) value, also known as a
#'     coordinate reference system (CRS), identified by the corresponding
#'     [EPSG](https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset)
#'     code.}
#'   \item{Description}{Description of the SRS/EPSG code.}
#'   \item{ovc_service}{Logical. Whether this code is valid for OVC services.}
#'   \item{wfs_service}{Logical. Whether this code is valid for WFS INSPIRE
#'     services.}
#' }
#' @references
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0("- [OVCCoordenadas](https://ovc.catastro.meh.es/",
#' "ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx)."))
#'
#' ```
#'
#' - [WFS INSPIRE
#' service](https://www.catastro.hacienda.gob.es/webinspire/index.html).
#'
#' @seealso [sf::st_crs()].
#'
#' @docType data
#' @name catr_srs_values
#' @keywords datasets
#'
#' @encoding UTF-8
#' @examples
#' data("catr_srs_values")
#'
#' # OVC valid codes
#' library(dplyr)
#'
#' catr_srs_values |> filter(ovc_service)
#'
#' # WFS valid codes
#'
#' catr_srs_values |> filter(wfs_service)
#'
#' # Use with sf::st_crs()
#'
#' catr_srs_values |>
#'   filter(wfs_service & ovc_service) |>
#'   print() |>
#'   # Select the first value.
#'   slice_head(n = 1) |>
#'   pull(SRS) |>
#'   # Convert to a CRS.
#'   sf::st_crs(.)
NULL
