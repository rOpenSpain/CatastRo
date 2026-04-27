#' WMS INSPIRE: Download map images
#'
#' @description
#' Get geotagged images from the Spanish Cadastre. This function is a
#' wrapper of [mapSpain::esp_get_tiles()].
#'
#' @encoding UTF-8
#' @family INSPIRE
#' @family WMS
#' @family spatial
#' @export
#'
#' @inheritParams catr_wfs_get_address_bbox
#' @inheritParams catr_atom_get_address_db_all
#' @inheritParams mapSpain::esp_get_tiles
#' @inheritDotParams mapSpain::esp_get_tiles res:mask
#'
#' @param what,styles Layer and style of the WMS layer to be downloaded. See
#'   **Layers and styles**.
#'
#' @return
#' A [`SpatRaster`][terra::rast] is returned, with 3 (RGB) or 4 (RGBA) layers,
#' see [terra::RGB()].
#'
#' @seealso
#' [mapSpain::esp_get_tiles()] and [terra::RGB()]. For plotting see
#' [terra::plotRGB()] and [tidyterra::geom_spatraster_rgb()].
#'
#' @section Bounding box:
#' When `x` is a numeric vector, make sure that the `srs` matches the
#' coordinate values. When `x` is a [`sf`][sf::st_sf] object, the value
#' `srs` is ignored.
#'
#' The query is performed using [EPSG:3857](https://epsg.io/3857) (Web Mercator)
#' and the tile is projected back to the SRS of `x`. In case that the tile
#' looks deformed, try either providing `x` or specify the SRS of the requested
#' tile via the `srs` argument, which should match the SRS of
#' `x`. See **Examples**.
#'
#' @section Layers and styles:
#'
#' ## Layers
#' The argument `what` defines the layer to be extracted. The equivalence with
#' the
#'
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(
#'    " [API Docs](https://www.catastro.hacienda.gob.es/",
#'      "webinspire/documentos/inspire-WMS.pdf) ")
#'      )
#'
#' ```
#' reference is:
#' - `"parcel"`: CP.CadastralParcel
#' - `"zoning"`: CP.CadastralZoning
#' - `"building"`: BU.Building
#' - `"buildingpart"`: BU.BuildingPart
#' - `"address"`: AD.Address
#' - `"admboundary"`: AU.AdministrativeBoundary
#' - `"admunit"`: AU.AdministrativeUnit
#'
#' ## Styles
#' The WMS service provides different styles on each layer (`what` argument).
#' Some of the styles available are:
#' - `"parcel"`: styles : `"BoundariesOnly"`, `"ReferencePointOnly"`,
#'   `"ELFCadastre"`.
#' - `"zoning"`: styles : `"BoundariesOnly"`, `"ELFCadastre"`.
#' - `"building"`, `"buildingpart"`: `"ELFCadastre"`
#' - `"address"`: `"Number.ELFCadastre"`
#' - `"admboundary"`, `"admunit"`: `"ELFCadastre"`
#'
#' Check the
#' ```{r, echo=FALSE, results='asis'}
#' cat(paste0(
#'    " [API Docs](https://www.catastro.hacienda.gob.es/",
#'      "webinspire/documentos/inspire-WMS.pdf) ")
#'      )
#'
#' ```
#' for more information.
#'
#' @examplesIf run_example()
#' \donttest{
#'
#' # With a bbox
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
#'   srs = 25830, # As parcels object
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

  # Manage layer

  what <- match_arg_pretty(what)

  layer <- switch(what,
    "building" = "Catastro.Building",
    "buildingpart" = "Catastro.BuildingPart",
    "parcel" = "Catastro.CadastralParcel",
    "zoning" = "Catastro.CadastralZoning",
    "address" = "Catastro.Address",
    "admboundary" = "Catastro.AdministrativeBoundary",
    "admunit" = "Catastro.AdministrativeUnit"
  )

  # Manage styles and options
  # Custom options
  opts <- list(
    styles = styles,
    version = "1.1.0"
  )

  # Add srs
  if (!is.null(srs)) {
    if (!any(grepl("epsg", srs, ignore.case = TRUE))) {
      opts <- modifyList(
        opts,
        list(srs = paste0("EPSG:", srs))
      )
    }
  }

  # Add to options
  if (is.null(options)) {
    finalopts <- opts
  } else {
    names(options) <- tolower(names(options))
    finalopts <- modifyList(
      opts,
      options
    )
  }

  # Check if need to change crs

  if (finalopts$version >= "1.3.0") {
    newnames <- gsub("srs", "crs", names(finalopts), fixed = TRUE)
    names(finalopts) <- newnames
  }

  # Query

  out <- mapSpain::esp_get_tiles(
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
