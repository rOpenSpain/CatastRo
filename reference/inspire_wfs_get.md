# Client tool for WFS INSPIRE services

Access WFS INSPIRE services. This function is used internally in WFS
calls and is exposed for users and developers accessing other cadastral
or INSPIRE resources.

## Usage

``` r
inspire_wfs_get(
  scheme = "https",
  hostname = "ovc.catastro.meh.es",
  path = "INSPIRE/wfsCP.aspx",
  query = list(),
  verbose = FALSE
)
```

## Arguments

- scheme:

  Character string. Protocol to access the resource on the Internet.

- hostname:

  Character string. Host that holds the resource.

- path:

  Character string. Specific resource in the host to access.

- query:

  Named list. Names and values of arguments to query.

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

Character string. Path of the resulting file in the
[`tempfile()`](https://rdrr.io/r/base/tempfile.html) folder.

## Details

This function is used internally in all the WFS calls. We expose it to
make it available to other users and/or developers for accessing other
cadastral or INSPIRE resources. See **Examples**.

## See also

INSPIRE API functions:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)

Other INSPIRE WFS services:
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)

## Examples

``` r
# Accessing the Cadastre of Navarra
# Try also https://ropenspain.github.io/CatastRoNav/

file_local <- inspire_wfs_get(
  hostname = "inspire.navarra.es",
  path = "services/BU/wfs",
  query = list(
    service = "WFS",
    request = "getfeature",
    typenames = "BU:Building",
    bbox = "609800,4740100,611000,4741300",
    SRSNAME = "EPSG:25830"
  )
)

if (!is.null(file_local)) {
  pamp <- sf::read_sf(file_local)

  library(ggplot2)
  ggplot(pamp) +
    geom_sf()
}
```
