#' WMS INSPIRE: download georeferenced map images
#'
#' @description
#' Retrieve georeferenced map images from the Spanish Cadastre WMS service.
#' This function wraps [mapSpain::esp_get_tiles()].
#'
#' @param what WMS layer to download. See **Layers and styles**.
#' @param styles Style to apply to the selected WMS layer. See
#'   **Layers and styles**.
#'
#' @inheritParams catr_wfs_get_address_bbox
#' @inheritParams catr_atom_get_address_db_all
#' @inheritParams mapSpain::esp_get_tiles
#' @inheritDotParams mapSpain::esp_get_tiles res:mask
#'
#' @return
#' A [`SpatRaster`][terra::rast] with three RGB or four RGBA layers. See
#' [terra::RGB()].
#'
#' @section Bounding box:
#' When `x` is a numeric vector, make sure that the `srs` matches the
#' coordinate values. When `x` is a [`sf`][sf::st_sf] object, the value
#' `srs` is ignored.
#'
#' The query uses [EPSG:3857](https://epsg.io/3857) (Web Mercator), then
#' transforms the tile back to the SRS of `x`. If the tile appears distorted,
#' provide a spatial object as `x` or set `srs` to the SRS of the requested
#' tile. See **Examples**.
#'
#' @section Layers and styles:
#'
#' ## Layers
#' The `what` argument selects one of the following API layers:
#' - `"parcel"`: `CP.CadastralParcel`.
#' - `"zoning"`: `CP.CadastralZoning`.
#' - `"building"`: `BU.Building`.
#' - `"buildingpart"`: `BU.BuildingPart`.
#' - `"address"`: `AD.Address`.
#' - `"admboundary"`: `AU.AdministrativeBoundary`.
#' - `"admunit"`: `AU.AdministrativeUnit`.
#'
#' ## Styles
#' The WMS service provides different styles for each layer (`what` argument).
#' Available styles include:
#' - `"parcel"`: `"BoundariesOnly"`, `"ReferencePointOnly"` and
#'   `"ELFCadastre"`.
#' - `"zoning"`: `"BoundariesOnly"` and `"ELFCadastre"`.
#' - `"building"` and `"buildingpart"`: `"ELFCadastre"`.
#' - `"address"`: `"Number.ELFCadastre"`.
#' - `"admboundary"` and `"admunit"`: `"ELFCadastre"`.
#'
#' See the
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(
#'    " [API documentation](https://www.catastro.hacienda.gob.es/",
#'      "webinspire/documentos/inspire-WMS.pdf) ")
#'      )
#'
#' ```
#' for complete layer and style information.
#'
#' @seealso
#' - [mapSpain::esp_get_tiles()] downloads map tiles.
#' - [terra::RGB()] identifies RGB channels.
#' - [terra::plotRGB()] and [tidyterra::geom_spatraster_rgb()] plot RGB rasters.
#'
#' @family wms
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' \donttest{
#'
#' # With a bounding box
#'
#' pict <- catr_wms_get_layer(
#'   c(222500, 4019500, 223700, 4020700),
#'   srs = 25830,
#'   what = "parcel"
#' )
#'
#' library(mapSpain)
#' library(ggplot2)
#' library(tidyterra)
#'
#' ggplot() +
#'   geom_spatraster_rgb(data = pict)
#'
#' # With a spatial object
#'
#' parcels <- catr_wfs_get_parcels_neigh_parcel("3662303TF3136B", srs = 25830)
#'
#' # Use styles
#'
#' parcels_img <- catr_wms_get_layer(parcels,
#'   what = "buildingpart",
#'   srs = 25830, # Same as the parcels object
#'   bbox_expand = 0.3,
#'   styles = "ELFCadastre"
#' )
#'
#' ggplot() +
#'   geom_sf(data = parcels, fill = "blue", alpha = 0.5) +
#'   geom_spatraster_rgb(data = parcels_img)
#' }
catr_wms_get_layer <- function(
  x,
  srs = NULL,
  what = c(
    "building",
    "buildingpart",
    "parcel",
    "zoning",
    "address",
    "admboundary",
    "admunit"
  ),
  styles = "default",
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  crop = FALSE,
  options = NULL,
  ...
) {
  x <- ensure_null(x)
  bbox_res <- get_sf_from_bbox(x, srs)
  cache_dir <- create_cache_dir(cache_dir)

  # Map the requested value to a WMS layer name.

  what <- match_arg_pretty(what)

  layer <- switch(
    what,
    "building" = "Catastro.Building",
    "buildingpart" = "Catastro.BuildingPart",
    "parcel" = "Catastro.CadastralParcel",
    "zoning" = "Catastro.CadastralZoning",
    "address" = "Catastro.Address",
    "admboundary" = "Catastro.AdministrativeBoundary",
    "admunit" = "Catastro.AdministrativeUnit"
  )

  # Set custom WMS options.
  opts <- list(styles = styles, version = "1.1.0")

  # Add SRS.
  if (!is.null(srs) && !any(grepl("epsg", srs, ignore.case = TRUE))) {
    opts <- modifyList(opts, list(srs = paste0("EPSG:", srs)))
  }

  # Merge caller-provided options.
  if (is.null(options)) {
    finalopts <- opts
  } else {
    names(options) <- tolower(names(options))
    finalopts <- modifyList(opts, options)
  }

  # Use the CRS parameter name required by WMS 1.3.0.

  if (finalopts$version >= "1.3.0") {
    newnames <- gsub("srs", "crs", names(finalopts), fixed = TRUE)
    names(finalopts) <- newnames
  }

  # Query the WMS service.

  out <- catr_esp_get_tiles(
    x = bbox_res,
    type = layer,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose,
    options = finalopts,
    ...
  )

  if (crop) {
    out <- terra::crop(out, bbox_res)
  }

  out
}

catr_esp_get_tiles <- mapSpain::esp_get_tiles
