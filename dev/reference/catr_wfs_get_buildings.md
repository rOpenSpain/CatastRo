# WFS INSPIRE: Download buildings

Get the spatial data of buildings. The WFS Service allows performing two
types of queries:

- By bounding box: Implemented on `catr_wfs_get_buildings_bbox()`.
  Extract objects included in the bounding box provided. See **Bounding
  box**.

&nbsp;

- By cadastral reference: Implemented on `catr_wfs_get_buildings_rc()`.
  Extract objects of specific cadastral references.

## Usage

``` r
catr_wfs_get_buildings_bbox(
  x,
  what = c("building", "buildingpart", "other"),
  srs = NULL,
  verbose = FALSE
)

catr_wfs_get_buildings_rc(
  rc,
  what = c("building", "buildingpart", "other"),
  srs = NULL,
  verbose = FALSE
)
```

## Arguments

- x:

  See **Bounding box**. It may be:

  - A numeric vector of length 4 with the coordinates that defines the
    bounding box: `c(xmin, ymin, xmax, ymax)`

  - A `sf/sfc` object, as provided by the
    [sf](https://CRAN.R-project.org/package=sf) package.

- what:

  Information to load. Options are:

  - `"building"` for buildings.

  - `"buildingpart"` for parts of a building.

  - `"other"` for other elements such as swimming pools.

- srs:

  SRS/CRS to use on the query. To see allowed values, use
  [catr_srs_values](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
  specifically the `wfs_service` column. See **Bounding box**.

- verbose:

  logical. If `TRUE` displays informational messages.

- rc:

  The cadastral reference to be extracted.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## API Limits

The API service is limited to a bounding box of 4km2 and a maximum of
5,000 elements.

## Bounding box

When `x` is a numeric vector, make sure that the `srs` matches the
coordinate values. Additionally, the function queries the bounding box
on [EPSG:25830](https://epsg.io/25830) - ETRS89 / UTM zone 30N, to
overcome a potential bug on the API side.

When `x` is a [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object, the value `srs` is ignored. In this case, the bounding box of
the [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object is
used for the query (see
[`sf::st_bbox()`](https://r-spatial.github.io/sf/reference/st_bbox.html)).

The result is always provided in the SRS of the
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object provided
as input.

## References

[API
Documentation](https://www.catastro.hacienda.gob.es/webinspire/documentos/inspire-ad-WFS.pdf).

[INSPIRE Services for Cadastral
Cartography](https://www.catastro.hacienda.gob.es/webinspire/index.html).

## See also

INSPIRE API functions:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wms_get_layer.md),
[`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/dev/reference/inspire_wfs_get.md)

Other INSPIRE WFS services:
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md),
[`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/dev/reference/inspire_wfs_get.md)

Other buildings:
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md)

Other spatial:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wms_get_layer.md)

## Examples

``` r
# \donttest{
# Using bbox
building <- catr_wfs_get_buildings_bbox(
  c(
    376550,
    4545424,
    376600,
    4545474
  ),
  srs = 25830
)
library(ggplot2)
ggplot(building) +
  geom_sf() +
  labs(title = "Search using bbox")


# Using rc
rc <- catr_wfs_get_buildings_rc("6656601UL7465N")
library(ggplot2)
ggplot(rc) +
  geom_sf() +
  labs(title = "Search using rc")

# }
```
