# WMS INSPIRE: Download map images

Get geotagged images from the Spanish Cadastre. This function is a
wrapper of
[`mapSpain::esp_getTiles()`](https://ropenspain.github.io/mapSpain/reference/esp_getTiles.html).

## Usage

``` r
catr_wms_get_layer(
  x,
  srs,
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

  See **Details**. It could be:

  - A numeric vector of length 4 with the coordinates that defines the
    bounding box: `c(xmin, ymin, xmax, ymax)`

  - A `sf/sfc` object, as provided by the
    [sf](https://CRAN.R-project.org/package=sf) package.

- srs:

  SRS/CRS to use on the query. To check the admitted values check
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
  specifically the `wfs_service` column. See **Details**.

- what:

  Layer to be extracted, see **Details**.

- styles:

  Style of the WMS layer. See **Details**.

- update_cache:

  A logical whether to update cache. Default is `FALSE`. When set to
  `TRUE` it would force a fresh download of the source file.

- cache_dir:

  A path to a cache directory. On `NULL` value (the default) the
  function would store the cached files on the
  [`tempdir`](https://rdrr.io/r/base/tempfile.html).

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

- crop:

  `TRUE` if results should be cropped to the specified `x` extent,
  `FALSE` otherwise. If `x` is an
  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object with
  one `POINT`, `crop` is set to `FALSE`.

- options:

  A named list containing additional options to pass to the query.

- ...:

  Arguments passed on to
  [`mapSpain::esp_getTiles`](https://ropenspain.github.io/mapSpain/reference/esp_getTiles.html)

  `res`

  :   Resolution (in pixels) of the final tile. Only valid for WMS.

  `bbox_expand`

  :   A numeric value that indicates the expansion percentage of the
      bounding box of `x`.

  `transparent`

  :   Logical. Provides transparent background, if supported. Depends on
      the selected provider on `type`.

  `mask`

  :   `TRUE` if the result should be masked to `x`.

## Value

A [`SpatRaster`](https://rspatial.github.io/terra/reference/rast.html)
is returned, with 3 (RGB) or 4 (RGBA) layers, see
[`terra::RGB()`](https://rspatial.github.io/terra/reference/RGB.html).

## Details

When `x` is a numeric vector, make sure that the `srs` matches the
coordinate values. When `x` is a
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object, the
value `srs` is ignored.

The query is performed using [EPSG:3857](https://epsg.io/3857) (Web
Mercator) and the tile is projected back to the SRS of `x`. In case that
the tile looks deformed, try either providing `x` or specify the SRS of
the requested tile via the `srs` parameter, that ideally would need to
match the SRS of `x`. See **Examples**.

## Layers

The parameter `what` defines the layer to be extracted. The equivalence
with the [API
Docs](https://www.catastro.hacienda.gob.es/webinspire/documentos/inspire-WMS.pdf)
equivalence is:

- `"parcel"`: CP.CadastralParcel

- `"zoning"`: CP.CadastralZoning

- `"building"`: BU.Building

- `"buildingpart"`: BU.BuildingPart

- `"address"`: AD.Address

- `"admboundary"`: AU.AdministrativeBoundary

- `"admunit"`: AU.AdministrativeUnit

## Styles

The WMS service provide different styles on each layer (`what`
parameter). Some of the styles available are:

- `"parcel"`: styles : `"BoundariesOnly"`, `"ReferencePointOnly"`,
  `"ELFCadastre"`.

- `"zoning"`: styles : `"BoundariesOnly"`, `"ELFCadastre"`.

- `"building"`, `"buildingpart"`: `"ELFCadastre"`

- `"address"`: `"Number.ELFCadastre"`

- `"admboundary"`, `"admunit"`: `"ELFCadastre"`

Check the [API
Docs](https://www.catastro.hacienda.gob.es/webinspire/documentos/inspire-WMS.pdf)
for more information.

## References

[API
Documentation](https://www.catastro.hacienda.gob.es/webinspire/documentos/inspire-WMS.pdf).

[INSPIRE Services for Cadastral
Cartography](https://www.catastro.hacienda.gob.es/webinspire/index.html).

## See also

[`mapSpain::esp_getTiles()`](https://ropenspain.github.io/mapSpain/reference/esp_getTiles.html)
and
[`terra::RGB()`](https://rspatial.github.io/terra/reference/RGB.html).
For plotting see
[`terra::plotRGB()`](https://rspatial.github.io/terra/reference/plotRGB.html)
and
[`tidyterra::geom_spatraster_rgb()`](https://dieghernan.github.io/tidyterra/reference/geom_spatraster_rgb.html).

INSPIRE API functions:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)

Other spatial:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)

## Examples

``` r
# \donttest{

# With a bbox

pict <- catr_wms_get_layer(
  c(222500, 4019500, 223700, 4020700),
  srs = 25830,
  what = "parcel"
)

library(mapSpain)
library(ggplot2)
library(tidyterra)
#> 
#> Attaching package: 'tidyterra'
#> The following object is masked from 'package:stats':
#> 
#>     filter

ggplot() +
  geom_spatraster_rgb(data = pict)



# With a spatial object

parcels <- catr_wfs_get_parcels_neigh_parcel("3662303TF3136B", srs = 25830)
#> Warning: incomplete final line found on 'C:\Users\RUNNER~1\AppData\Local\Temp\Rtmp4ASZdF/file156cacb7642.gml'


# Use styles

parcels_img <- catr_wms_get_layer(parcels,
  what = "buildingpart",
  srs = 25830, # As parcels object
  bbox_expand = 0.3,
  styles = "ELFCadastre"
)


ggplot() +
  geom_sf(data = parcels, fill = "blue", alpha = 0.5) +
  geom_spatraster_rgb(data = parcels_img)

# }
```
