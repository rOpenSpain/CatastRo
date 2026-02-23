# ATOM INSPIRE: Download all cadastral parcels of a municipality

Retrieve the spatial data of all cadastral parcels belonging to a single
municipality using the INSPIRE ATOM service.

## Usage

``` r
catr_atom_get_parcels(
  munic,
  to = NULL,
  what = c("parcel", "zoning"),
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Arguments

- munic:

  Municipality to extract. It can be a part of a string or the cadastral
  code. See
  [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md)
  for getting the cadastral codes.

- to:

  Optional argument for defining the territorial office to which `munic`
  belongs. This argument is a helper for narrowing the search.

- what:

  Information to load. It can be:

  - `"parcel"` for cadastral parcels.

  - `"zoning"` for cadastral zoning.

- cache:

  **\[deprecated\]** `cache` is no longer supported; this function will
  always cache results.

- update_cache:

  logical. Should the cached file be refreshed? Default is `FALSE`. When
  set to `TRUE` it would force a new download.

- cache_dir:

  A path to a cache directory. On `NULL` the function would store the
  cached files on a temporary dir (See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

- verbose:

  logical. If `TRUE` displays informational messages.

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## References

[API
Documentation](https://www.catastro.hacienda.gob.es/webinspire/documentos/inspire-ATOM.pdf).

[INSPIRE Services for Cadastral
Cartography](https://www.catastro.hacienda.gob.es/webinspire/index.html).

## See also

INSPIRE API functions:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md),
[`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/reference/inspire_wfs_get.md)

Other INSPIRE ATOM services:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md)

Other parcels:
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)

Other spatial:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)

## Examples

``` r
# \donttest{
s <- catr_atom_get_parcels("Melque", to = "Segovia", what = "parcel")

library(ggplot2)

ggplot(s) +
  geom_sf() +
  labs(
    title = "Cadastral Parcels",
    subtitle = "Melque de Cercos, Segovia"
  )

# }
```
