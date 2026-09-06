# WFS INSPIRE: Download addresses

Retrieve spatial address data through several types of WFS queries:

- By bounding box: `catr_wfs_get_address_bbox()` retrieves objects
  included in the provided bounding box. See **Bounding box**.

&nbsp;

- By street code: `catr_wfs_get_address_codvia()` retrieves objects for
  specific addresses.

&nbsp;

- By cadastral reference: `catr_wfs_get_address_rc()` retrieves objects
  for specific cadastral references.

&nbsp;

- By postal codes: `catr_wfs_get_address_postalcode()` retrieves objects
  for specific postal codes.

## Usage

``` r
catr_wfs_get_address_bbox(x, srs = NULL, verbose = FALSE)

catr_wfs_get_address_codvia(codvia, del, mun, srs = NULL, verbose = FALSE)

catr_wfs_get_address_rc(rc, srs = NULL, verbose = FALSE)

catr_wfs_get_address_postalcode(postalcode, srs = NULL, verbose = FALSE)
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

- verbose:

  Logical. Whether to display informational messages.

- codvia:

  Cadastral street code.

- del:

  Cadastral office code.

- mun:

  Cadastral municipality code.

- rc:

  Cadastral reference to retrieve.

- postalcode:

  Postal code.

## Value

An [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.
Returns `NULL` if the data cannot be retrieved.

## API limits

The API service is limited to a bounding box of 4 km2 and a maximum of
5,000 elements.

## Bounding box

When `x` is a numeric vector, make sure that `srs` matches the
coordinate values. This function queries the bounding box in
[EPSG:25830](https://epsg.io/25830), ETRS89 / UTM zone 30N, to work
around a potential API issue.

When `x` is an [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object, the `srs` value is ignored. In this case, the bounding box of
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

[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wms_get_layer.md)
downloads a map image using the returned spatial object as its extent
(`x`).

Work with cadastral addresses:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md)

Query WFS INSPIRE services:
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md),
[`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/dev/reference/inspire_wfs_get.md)

## Examples

``` r
# \donttest{
ad <- catr_wfs_get_address_bbox(
  c(
    233673, 4015968, 233761, 4016008
  ),
  srs = 25830
)
#> ✖ The download request could not be completed.
#> ! Failed to perform HTTP request. Caused by error in `curl::curl_fetch_memory()`: ! Timeout was reached [ovc.catastro.meh.es]: Failed to connect to ovc.catastro.meh.es port 443 after 133092 ms: Couldn't connect to server
#> Returning `NULL` because the download failed.

library(ggplot2)

ggplot(ad) +
  geom_sf()

# }
```
