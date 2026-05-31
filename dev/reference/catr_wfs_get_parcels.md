# WFS INSPIRE: download cadastral parcels

Get the spatial data of cadastral parcels and zones. The WFS service
allows several types of queries:

- By bounding box: `catr_wfs_get_parcels_bbox()` extracts objects
  included in the provided bounding box. See **Bounding box**.

&nbsp;

- By zoning: `catr_wfs_get_parcels_zoning()` extracts objects for a
  specific cadastral zone.

&nbsp;

- By cadastral parcel: `catr_wfs_get_parcels_parcel()` extracts
  cadastral parcels for a specific cadastral reference.

&nbsp;

- Neighbor cadastral parcels: `catr_wfs_get_parcels_neigh_parcel()`
  extracts neighbor cadastral parcels for a specific cadastral
  reference.

&nbsp;

- Cadastral parcels by zoning: `catr_wfs_get_parcels_parcel_zoning()`
  extracts cadastral parcels for a specific cadastral zone.

## Usage

``` r
catr_wfs_get_parcels_bbox(
  x,
  what = c("parcel", "zoning"),
  srs = NULL,
  verbose = FALSE
)

catr_wfs_get_parcels_zoning(cod_zona, srs = NULL, verbose = FALSE)

catr_wfs_get_parcels_parcel(rc, srs = NULL, verbose = FALSE)

catr_wfs_get_parcels_neigh_parcel(rc, srs = NULL, verbose = FALSE)

catr_wfs_get_parcels_parcel_zoning(cod_zona, srs = NULL, verbose = FALSE)
```

## Arguments

- x:

  See **Bounding box**. Can be one of:

  - A numeric vector of length 4 with the coordinates that define the
    bounding box: `c(xmin, ymin, xmax, ymax)`.

  - A `sf/sfc` object, as provided by the
    [sf](https://CRAN.R-project.org/package=sf) package.

- what:

  Information to load. Options are:

  - `"parcel"` for cadastral parcels.

  - `"zoning"` for cadastral zoning.

- srs:

  SRS/CRS to use in the query. To see allowed values, use
  [catr_srs_values](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
  specifically the `wfs_service` column. See **Bounding box**.

- verbose:

  Logical. If `TRUE`, displays informational messages.

- cod_zona:

  Cadastral zone code.

- rc:

  The cadastral reference to be extracted.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## API Limits

The API service is limited to the following constraints:

- `"parcel"`: Bounding box of 1 km2 and a maximum of 5,000 elements.

- `"zoning"`: Bounding box of 25 km2 and a maximum of 5,000 elements.

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
documentation](https://www.catastro.hacienda.gob.es/webinspire/documentos/inspire-ad-WFS.pdf).

[INSPIRE services for cadastral
cartography](https://www.catastro.hacienda.gob.es/webinspire/index.html).

## See also

Related INSPIRE API functions:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wms_get_layer.md),
[`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/dev/reference/inspire_wfs_get.md)

Related WFS INSPIRE functions:
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md),
[`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/dev/reference/inspire_wfs_get.md)

Other parcels:
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md)

Other spatial:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wms_get_layer.md)

## Examples

``` r
# \donttest{
cp <- catr_wfs_get_parcels_bbox(
  c(
    233673, 4015968, 233761, 4016008
  ),
  srs = 25830
)

library(ggplot2)

ggplot(cp) +
  geom_sf()

# }
```
