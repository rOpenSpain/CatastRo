# ATOM INSPIRE: download all cadastral parcels for a municipality

Retrieve spatial data for all cadastral parcels in a municipality using
the ATOM INSPIRE service.

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

  Municipality name, partial name or cadastral code. Use
  [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md)
  to find cadastral codes.

- to:

  Optional territorial office containing `munic`. Use this argument to
  narrow the search.

- what:

  Information to load. Options are:

  - `"parcel"` for cadastral parcels.

  - `"zoning"` for cadastral zoning.

- cache:

  **\[deprecated\]** This argument is no longer supported because
  results are always cached.

- update_cache:

  Logical. Whether to refresh the cached file. Defaults to `FALSE`.

- cache_dir:

  Path to a cache directory. If `NULL` or `FALSE`, the function stores
  cached files in a temporary directory. See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html).

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

An [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.
Returns `NULL` if the data cannot be retrieved.

## References

[API
documentation](https://www.catastro.hacienda.gob.es/webinspire/documentos/inspire-ATOM.pdf).

[INSPIRE services for cadastral
cartography](https://www.catastro.hacienda.gob.es/webinspire/index.html).

## See also

Download data from ATOM INSPIRE services:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md),
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md)

Work with cadastral parcels:
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md)

## Examples

``` r
# \donttest{
s <- catr_atom_get_parcels("Melque", to = "Segovia", what = "parcel")

library(ggplot2)

ggplot(s) +
  geom_sf() +
  labs(
    title = "Cadastral parcels",
    subtitle = "Melque de Cercos, Segovia"
  )

# }
```
