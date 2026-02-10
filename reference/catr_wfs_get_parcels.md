# WFS INSPIRE: Download cadastral parcels

Get the spatial data of cadastral parcels and zones. The WFS Service
allows to perform several types of queries:

- By bounding box: Implemented on `catr_wfs_get_parcels_bbox()`. Extract
  objects included on the bounding box provided. See **Details**.

&nbsp;

- By zoning: Implemented on `catr_wfs_get_parcels_zoning()`. Extract
  objects of a specific cadastral zone.

&nbsp;

- By cadastral parcel: Implemented on `catr_wfs_get_parcels_parcel()`.
  Extract cadastral parcels of a specific cadastral reference.

&nbsp;

- Neighbor cadastral parcels: Implemented on
  `catr_wfs_get_parcels_neigh_parcel()`. Extract neighbor cadastral
  parcels of a specific cadastral reference.

&nbsp;

- Cadastral parcels by zoning: Implemented on
  `catr_wfs_get_parcels_parcel_zoning()`. Extract cadastral parcels of a
  specific cadastral zone.

## Usage

``` r
catr_wfs_get_parcels_bbox(x, what = "parcel", srs, verbose = FALSE)

catr_wfs_get_parcels_zoning(cod_zona, srs = NULL, verbose = FALSE)

catr_wfs_get_parcels_parcel(rc, srs = NULL, verbose = FALSE)

catr_wfs_get_parcels_neigh_parcel(rc, srs = NULL, verbose = FALSE)

catr_wfs_get_parcels_parcel_zoning(cod_zona, srs = NULL, verbose = FALSE)
```

## Arguments

- x:

  See **Details**. It could be:

  - A numeric vector of length 4 with the coordinates that defines the
    bounding box: `c(xmin, ymin, xmax, ymax)`

  - A `sf/sfc` object, as provided by the
    [sf](https://CRAN.R-project.org/package=sf) package.

- what:

  Information to load. It could be `"parcel"` for cadastral parcels or
  `"zoning"` for cadastral zoning.

- srs:

  SRS/CRS to use on the query. To check the admitted values check
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
  specifically the `wfs_service` column. See **Details**.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

- cod_zona:

  Cadastral zone code.

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

When `x` is a [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object, the value `srs` is ignored. The query is performed using
[EPSG:3857](https://epsg.io/3857) (Web Mercator) and the spatial object
is projected back to the SRS of the initial object.

## API Limits

The API service is limited to the following constrains:

- `"parcel`: Bounding box of 1km2 and a maximum of 500. elements.

- `"zoning"`: Bounding box of 25km2 and a maximum of 500 elements.

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
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)

Other INSPIRE WFS services:
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md)

Other parcels:
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md)

Other spatial:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)

## Examples

``` r
# \donttest{
cp <- catr_wfs_get_parcels_bbox(
  c(
    233673, 4015968, 233761, 4016008
  ),
  srs = 25830
)
#> Warning: incomplete final line found on 'C:\Users\RUNNER~1\AppData\Local\Temp\RtmpysyoFK/file514417d851.gml'

library(ggplot2)

ggplot(cp) +
  geom_sf()

# }
```
