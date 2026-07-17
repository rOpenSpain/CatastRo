# WFS INSPIRE: download cadastral parcels

Retrieve spatial cadastral parcel and zoning data through several types
of WFS queries:

- By bounding box: `catr_wfs_get_parcels_bbox()` retrieves objects
  included in the provided bounding box. See **Bounding box**.

&nbsp;

- By zoning: `catr_wfs_get_parcels_zoning()` retrieves objects for a
  specific cadastral zone.

&nbsp;

- By cadastral parcel: `catr_wfs_get_parcels_parcel()` retrieves
  cadastral parcels for a specific cadastral reference.

&nbsp;

- Neighbor cadastral parcels: `catr_wfs_get_parcels_neigh_parcel()`
  retrieves neighboring cadastral parcels for a specific cadastral
  reference.

&nbsp;

- Cadastral parcels by zoning: `catr_wfs_get_parcels_parcel_zoning()`
  retrieves cadastral parcels for a specific cadastral zone.

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

  Input defining the query area. See **Bounding box**. It can be:

  - A numeric vector of length 4 with the coordinates that define the
    bounding box: `c(xmin, ymin, xmax, ymax)`.

  - An `sf` or `sfc` object from
    [sf](https://CRAN.R-project.org/package=sf).

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

  Cadastral reference to retrieve.

## Value

An [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.
Returns `NULL` if the data cannot be retrieved.

## API limits

The API service is limited to the following constraints:

- `"parcel"`: Bounding box of 1 km2 and a maximum of 5,000 elements.

- `"zoning"`: Bounding box of 25 km2 and a maximum of 5,000 elements.

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
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md),
[`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/dev/reference/inspire_wfs_get.md)

Work with cadastral parcels:
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md)

## Examples

``` r
# \donttest{
cp <- catr_wfs_get_parcels_bbox(
  c(
    233673, 4015968, 233761, 4016008
  ),
  srs = 25830
)
#> ✖ The download request could not be completed.
#> ! Failed to perform HTTP request.
#> Caused by error in `curl::curl_fetch_memory()`:
#> ! Failure when receiving data from the peer [ovc.catastro.meh.es]:
#> Recv failure: Connection reset by peer
#> → Returning "NULL" because the download failed.

library(ggplot2)

ggplot(cp) +
  geom_sf()

# }
```
