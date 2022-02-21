#' **WMS INSPIRE**: Download map images
#'
#' @description
#' Get geotagged images from the Spanish Cadastre. This function is a wrapper of
#' [mapSpain::esp_getTiles()].
#'
#' @inheritParams catr_atom_get_buildings
#' @inheritParams catr_wfs_get_buildings_bbox
#' @inheritParams mapSpain::esp_getTiles
#' @inheritDotParams mapSpain::esp_getTiles res:mask
#'
#' @param what Layer to be extracted. Possible values are `"building"`,
#'   `"parcel"`, `"zoning"`, `"address"`. See **Details**.
#' @param styles Style of the WMS layer. See **Details**.
#'
#' @return A `SpatRaster` is returned, with 3 (RGB) or 4 (RGBA) layers. See
#' [terra::rast()].
#'
#' @family INSPIRE
#' @family WMS
#' @family spatial
#'
#' @seealso [mapSpain::esp_getTiles()], [mapSpain::layer_spatraster()],
#' [terra::plotRGB()].
#'
#' @export
#'
#' @references
#' [API Documentation](https://www.catastro.minhap.es/webinspire/documentos/inspire-WMS.pdf)
#'
#' [INSPIRE Services for Cadastral Cartography](https://www.catastro.minhap.es/webinspire/index.html)
#'
#'
#' @details
#'
#' When `x` is a numeric vector, make sure that the `srs` matches the
#' coordinate values. When `x` is a `sf` object, the value `srs` is ignored.
#'
#' The query is performed using [EPSG:3857](https://epsg.io/3857) (Web Mercator)
#' and the spatial object is projected back to the SRS of the initial object. In
#' case that the tile looks deformed, try either providing `bbox` on EPSG:3857
#' or projecting your `sf` object to `sf::st_crs(3857)`.
#'
#' # Layers
#'
#' The parameter `what` defines the layer to be extracted. The equivalence with
#' the
#' [API Docs](https://www.catastro.minhap.es/webinspire/documentos/inspire-WMS.pdf)
#' equivalence is:
#' - "parcel": CP.CadastralParcel
#' - "zoning": CP.CadastralZoning
#' - "building": BU.Building
#' - "buildingpart": BU.BuildingPart
#' - "address": AD.Address
#' - "admboundary": AU.AdministrativeBoundary
#' - "admunit": AU.AdministrativeUnit
#'
#' # Styles
#'
#' The WMS service provide different styles on each layer (`what` parameter).
#' Some of the styles available are:
#' - "parcel": styles : `"BoundariesOnly"`, `"ReferencePointOnly"`,
#'   `"ELFCadastre"`.
#' - "zoninig": styles : `"BoundariesOnly"`, `"ELFCadastre"`.
#' - "building" and "buildingpart": `"ELFCadastre"`
#' - "address": `"Number.ELFCadastre"`
#' - "admboundary" y "admunit": `"ELFCadastre"`
#'
#' Check the
#' [API Docs](https://www.catastro.minhap.es/webinspire/documentos/inspire-WMS.pdf)
#' for more information.
#'
#' @examplesIf tolower(Sys.info()[["sysname"]]) != "linux"
#' \donttest{
#'
#' # With a bbox
#'
#' pict <- catr_wms_get_layer(c(222500, 4019500, 223700, 4020700),
#'   srs = 25830,
#'   what = "parcel"
#' )
#'
#' library(ggplot2)
#' library(mapSpain)
#'
#' ggplot() +
#'   layer_spatraster(pict)
#'
#'
#' # With a spatial object
#'
#' parcels <- catr_wfs_get_parcels_neigh_parcel("3662303TF3136B")
#'
#' # Transform
#' parcels <- sf::st_transform(parcels, 3857)
#'
#' # Use styles
#'
#' parcels_img <- catr_wms_get_layer(parcels,
#'   what = "buildingpart",
#'   bbox_expand = 0.3,
#'   styles = "ELFCadastre"
#' )
#'
#'
#' ggplot() +
#'   geom_sf(data = parcels, fill = "blue", alpha = 0.5) +
#'   layer_spatraster(parcels_img)
#' }
catr_wms_get_layer <- function(x,
                               srs,
                               what = "building",
                               styles = "default",
                               update_cache = FALSE,
                               cache_dir = NULL,
                               verbose = FALSE,
                               crop = FALSE,
                               ...) {
  bbox_res <- get_sf_from_bbox(x, srs)
  cache_dir <- catr_hlp_cachedir(cache_dir)

  # Manage layer

  valid_values <- c(
    "building", "parcel", "zoning", "address",
    "buildingpart",
    "admboundary",
    "admunit"
  )

  if (!(what %in% valid_values)) {
    stop(
      "'what' should be one of ",
      paste0("'", valid_values, "'", collapse = ", ")
    )
  }

  layer <- switch(what,
    "building" = "Catastro.Building",
    "buildingpart" = "Catastro.BuildingPart",
    "parcel" = "Catastro.CadastralParcel",
    "zoning" = "Catastro.CadastralZoning",
    "address" = "Catastro.Address",
    "admboundary" = "Catastro.AdministrativeBoundary",
    "admunit" = "Catastro.AdministrativeUnit"
  )

  # Manage styles

  if (tolower(styles) == "default") {
    opts <- NULL
  } else {
    opts <- list(styles = styles)
  }

  # Query

  out <- mapSpain::esp_getTiles(
    x = bbox_res,
    type = layer,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose,
    options = opts,
    ...
  )


  if (crop) {
    out <- terra::crop(out, bbox_res)
  }

  return(out)
}
