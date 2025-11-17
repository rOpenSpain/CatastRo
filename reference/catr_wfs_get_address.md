# WFS INSPIRE: Download addresses

Get the spatial data of addresses The WFS Service allows to perform
several types of queries:

- By bounding box: Implemented on `catr_wfs_get_address_bbox()`. Extract
  objects included on the bounding box provided. See **Details**.

&nbsp;

- By street code: Implemented on `catr_wfs_get_address_codvia()`.
  Extract objects of specific addresses.

&nbsp;

- By cadastral reference: Implemented on `catr_wfs_get_address_rc()`.
  Extract objects of specific cadastral references

&nbsp;

- By postal codes: Implemented on `catr_wfs_get_address_postalcode()`.
  Extract objects of specific cadastral references

## Usage

``` r
catr_wfs_get_address_bbox(x, srs, verbose = FALSE)

catr_wfs_get_address_codvia(codvia, del, mun, srs = NULL, verbose = FALSE)

catr_wfs_get_address_rc(rc, srs = NULL, verbose = FALSE)

catr_wfs_get_address_postalcode(postalcode, srs = NULL, verbose = FALSE)
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

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

- codvia:

  Cadastral street code.

- del:

  Cadastral office code.

- mun:

  Cadastral municipality code.

- rc:

  The cadastral reference to be extracted.

- postalcode:

  Postal code.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

When `x` is a numeric vector, make sure that the `srs` matches the
coordinate values. Additionally, when the `srs` correspond to a
geographic reference system (4326, 4258), the function queries the
bounding box on [EPSG:3857](https://epsg.io/3857) - Web Mercator, to
overcome a potential bug on the API side.

When `x` is a [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object, the value `srs` is ignored. In this case, the bounding box of
the [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
would be used for the query (see
[`sf::st_bbox()`](https://r-spatial.github.io/sf/reference/st_bbox.html)).
The query is performed using [EPSG:3857](https://epsg.io/3857) (Web
Mercator). The result is provided always in the SRS of the
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object provided
as input.

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
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)

Other INSPIRE WFS services:
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)

Other addresses:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md)

Other spatial:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)

## Examples

``` r
# \donttest{
ad <- catr_wfs_get_address_bbox(
  c(
    233673, 4015968, 233761, 4016008
  ),
  srs = 25830
)

library(ggplot2)

ggplot(ad) +
  geom_sf()

# }
```
