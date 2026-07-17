# WMS INSPIRE: download georeferenced map images

Retrieve georeferenced map images from the Spanish Cadastre WMS service.
This function wraps
[`mapSpain::esp_get_tiles()`](https://ropenspain.github.io/mapSpain/reference/esp_get_tiles.html).

## Usage

``` r
catr_wms_get_layer(
  x,
  srs = NULL,
  what = c("building", "buildingpart", "parcel", "zoning", "address", "admboundary",
    "admunit"),
  styles = "default",
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  crop = FALSE,
  options = NULL,
  ...
)
```

## Arguments

- x:

  Input defining the query area. See **Bounding box**. It can be:

  - A numeric vector of length 4 with the coordinates that define the
    bounding box: `c(xmin, ymin, xmax, ymax)`.

  - An `sf` or `sfc` object from
    [sf](https://CRAN.R-project.org/package=sf).

- srs:

  SRS/CRS to use in the query. To see allowed values, use
  [catr_srs_values](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
  specifically the `wfs_service` column. See **Bounding box**.

- what:

  WMS layer to download. See **Layers and styles**.

- styles:

  Style to apply to the selected WMS layer. See **Layers and styles**.

- update_cache:

  Logical. Whether to refresh the cached file. Defaults to `FALSE`.

- cache_dir:

  Path to a cache directory. If `NULL` or `FALSE`, the function stores
  cached files in a temporary directory. See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html).

- verbose:

  Logical. If `TRUE`, displays informational messages.

- crop:

  Logical. If `TRUE`, crop results to the specified `x` extent. If `x`
  is an [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
  with one `POINT`, `crop` is set to `FALSE`. See
  [`terra::crop()`](https://rspatial.github.io/terra/reference/crop.html).

- options:

  A named list containing additional options to pass to the query.

- ...:

  Arguments passed on to
  [`mapSpain::esp_get_tiles`](https://ropenspain.github.io/mapSpain/reference/esp_get_tiles.html)

  `res`

  :   Character string or number. Only valid for WMS providers.
      Resolution (in pixels) of the final tile.

  `bbox_expand`

  :   Number. Expansion percentage of the bounding box of `x`.

  `transparent`

  :   Logical. Whether to use a transparent background, if supported.

  `mask`

  :   Logical. `TRUE` to mask the result to `x`. See
      [`terra::mask()`](https://rspatial.github.io/terra/reference/mask.html).

## Value

A [`SpatRaster`](https://rspatial.github.io/terra/reference/rast.html)
with three RGB or four RGBA layers. See
[`terra::RGB()`](https://rspatial.github.io/terra/reference/RGB.html).

## Bounding box

When `x` is a numeric vector, make sure that the `srs` matches the
coordinate values. When `x` is a
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object, the
value `srs` is ignored.

The query uses [EPSG:3857](https://epsg.io/3857) (Web Mercator), then
transforms the tile back to the SRS of `x`. If the tile appears
distorted, provide a spatial object as `x` or set `srs` to the SRS of
the requested tile. See **Examples**.

## Layers and styles

### Layers

The `what` argument selects one of the following API layers:

- `"parcel"`: `CP.CadastralParcel`.

- `"zoning"`: `CP.CadastralZoning`.

- `"building"`: `BU.Building`.

- `"buildingpart"`: `BU.BuildingPart`.

- `"address"`: `AD.Address`.

- `"admboundary"`: `AU.AdministrativeBoundary`.

- `"admunit"`: `AU.AdministrativeUnit`.

### Styles

The WMS service provides different styles for each layer (`what`
argument). Available styles include:

- `"parcel"`: `"BoundariesOnly"`, `"ReferencePointOnly"` and
  `"ELFCadastre"`.

- `"zoning"`: `"BoundariesOnly"` and `"ELFCadastre"`.

- `"building"` and `"buildingpart"`: `"ELFCadastre"`.

- `"address"`: `"Number.ELFCadastre"`.

- `"admboundary"` and `"admunit"`: `"ELFCadastre"`.

See the [API
documentation](https://www.catastro.hacienda.gob.es/webinspire/documentos/inspire-WMS.pdf)
for complete layer and style information.

## See also

- [`mapSpain::esp_get_tiles()`](https://ropenspain.github.io/mapSpain/reference/esp_get_tiles.html)
  downloads map tiles.

- [`terra::RGB()`](https://rspatial.github.io/terra/reference/RGB.html)
  identifies RGB channels.

- [`terra::plotRGB()`](https://rspatial.github.io/terra/reference/plotRGB.html)
  and
  [`tidyterra::geom_spatraster_rgb()`](https://dieghernan.github.io/tidyterra/reference/geom_spatraster_rgb.html)
  plot RGB rasters.

## Examples

``` r
# \donttest{

# With a bounding box

pict <- catr_wms_get_layer(
  c(222500, 4019500, 223700, 4020700),
  srs = 25830,
  what = "parcel"
)

library(mapSpain)
library(ggplot2)
library(tidyterra)
#> 
#> Attaching package: ‘tidyterra’
#> The following object is masked from ‘package:stats’:
#> 
#>     filter

ggplot() +
  geom_spatraster_rgb(data = pict)
#> ! `data` has 4 layers. Selecting layers 1, 2, and 3.


# With a spatial object

parcels <- catr_wfs_get_parcels_neigh_parcel("3662303TF3136B", srs = 25830)
#> ✖ The download request could not be completed.
#> ! Failed to perform HTTP request.
#> Caused by error in `curl::curl_fetch_memory()`:
#> ! Failure when receiving data from the peer [ovc.catastro.meh.es]:
#> Recv failure: Connection reset by peer
#> → Returning "NULL" because the download failed.

# Use styles

parcels_img <- catr_wms_get_layer(parcels,
  what = "buildingpart",
  srs = 25830, # Same as the parcels object
  bbox_expand = 0.3,
  styles = "ELFCadastre"
)
#> Error in get_sf_from_bbox(x, srs): `bbox` must have length 4, not 0.

ggplot() +
  geom_sf(data = parcels, fill = "blue", alpha = 0.5) +
  geom_spatraster_rgb(data = parcels_img)
#> Error: object 'parcels_img' not found
# }
```
