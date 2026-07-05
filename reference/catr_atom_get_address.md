# ATOM INSPIRE: download all addresses for a municipality

Retrieve spatial data for all addresses in a municipality using the ATOM
INSPIRE service. The result also contains corresponding street
information in fields prefixed with `tfname_*`.

## Usage

``` r
catr_atom_get_address(
  munic,
  to = NULL,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Arguments

- munic:

  Municipality name, partial name or cadastral code. Use
  [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md)
  to find cadastral codes.

- to:

  Optional territorial office containing `munic`. Use this argument to
  narrow the search.

- cache:

  **\[deprecated\]** This argument is no longer supported because
  results are always cached.

- update_cache:

  Logical. Whether to refresh the cached file. Defaults to `FALSE`.

- cache_dir:

  Path to a cache directory. If `NULL`, the function stores cached files
  in a temporary directory. See
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
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md)

Work with cadastral addresses:
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md)

## Examples

``` r
# \donttest{
s <- catr_atom_get_address("Melque", to = "Segovia")

library(ggplot2)

ggplot(s) +
  geom_sf(aes(color = specification)) +
  coord_sf(
    xlim = c(376200, 376850),
    ylim = c(4545000, 4546000)
  ) +
  labs(
    title = "Addresses",
    subtitle = "Melque de Cercos, Segovia"
  )

# }
```
