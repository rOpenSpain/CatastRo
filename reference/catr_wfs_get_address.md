# WFS INSPIRE: download addresses

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
  [catr_srs_values](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
  specifically the `wfs_service` column. See **Bounding box**.

- verbose:

  Logical. If `TRUE`, displays informational messages.

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

When `x` is a numeric vector, make sure that the `srs` matches the
coordinate values. Additionally, the function queries the bounding box
on [EPSG:25830](https://epsg.io/25830), ETRS89 / UTM zone 30N, to work
around a potential API issue.

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

Query data from WFS INSPIRE services:
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
[`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/reference/inspire_wfs_get.md)

Work with cadastral addresses:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md)

## Examples

``` r
# \donttest{
ad <- catr_wfs_get_address_bbox(
  c(
    233673, 4015968, 233761, 4016008
  ),
  srs = 25830
)
#> Error in httr2::req_perform(get_header): Failed to perform HTTP request.
#> Caused by error in `curl::curl_fetch_memory()`:
#> ! Failure when receiving data from the peer [ovc.catastro.meh.es]:
#> Recv failure: Connection reset by peer

library(ggplot2)

ggplot(ad) +
  geom_sf()
#> Error: object 'ad' not found
# }
```
