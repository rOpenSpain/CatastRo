# WFS INSPIRE: Download buildings

Get the spatial data of buildings. The WFS Service allows to perform two
types of queries:

- By bounding box: Implemented on `catr_wfs_get_buildings_bbox()`.
  Extract objects included on the bounding box provided. See
  **Details**.

&nbsp;

- By cadastral reference: Implemented on `catr_wfs_get_buildings_rc()`.
  Extract objects of specific cadastral references.

## Usage

``` r
catr_wfs_get_buildings_bbox(x, what = "building", srs, verbose = FALSE)

catr_wfs_get_buildings_rc(rc, what = "building", srs = NULL, verbose = FALSE)
```

## Arguments

- x:

  See **Details**. It could be:

  - A numeric vector of length 4 with the coordinates that defines the
    bounding box: `c(xmin, ymin, xmax, ymax)`

  - A `sf/sfc` object, as provided by the
    [sf](https://CRAN.R-project.org/package=sf) package.

- what:

  Information to load. It could be:

  - `"building"` for buildings.

  - `"buildingpart"` for parts of a building.

  - `"other"` for others elements, as swimming pools, etc.

- srs:

  SRS/CRS to use on the query. To check the admitted values check
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
  specifically the `wfs_service` column. See **Details**.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

- rc:

  The cadastral reference to be extracted.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

When `x` is a numeric vector, make sure that the `srs` matches the
coordinate values. Additionally, when the `srs` correspond to a
geographic reference system (4326, 4258), the function queries the
bounding box on [EPSG:3857](https://epsg.io/3857) - Web Mercator, to
overcome a potential bug on the API side. The result is provided always
in the SRS provided in `srs`.

When `x` is a [sf](https://CRAN.R-project.org/package=sf) object, the
value `srs` is ignored. The query is performed using
[EPSG:3857](https://epsg.io/3857) (Web Mercator) and the spatial object
is projected back to the SRS of the initial object.

## API Limits

The API service is limited to a bounding box of 4km2 and a maximum of
5.000 elements.

## References

[API
Documentation](https://www.catastro.hacienda.gob.es/webinspire/documentos/inspire-ad-WFS.pdf).

[INSPIRE Services for Cadastral
Cartography](https://www.catastro.hacienda.gob.es/webinspire/index.html).

## See also

[`sf::st_bbox()`](https://r-spatial.github.io/sf/reference/st_bbox.html)

INSPIRE API functions:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)

Other INSPIRE WFS services:
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)

Other buildings:
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md)

Other spatial:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)

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
