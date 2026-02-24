# ATOM INSPIRE: Reference database for ATOM buildings

Create a database containing the URLs provided in the INSPIRE ATOM
service of the Spanish Cadastre for extracting buildings.

- `catr_atom_get_buildings_db_all()` provides a top-level table
  including information on all the territorial offices (except the
  Basque Country and Navarre) listing the municipalities included in
  each office.

- `catr_atom_get_buildings_db_to()` provides a table for the specified
  territorial office including information for each of the
  municipalities of that office.

## Usage

``` r
catr_atom_get_buildings_db_all(
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)

catr_atom_get_buildings_db_to(
  to,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Source

<https://www.catastro.hacienda.gob.es/INSPIRE/buildings/ES.SDGC.BU.atom.xml>

## Arguments

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

- to:

  character. Territorial office. Internally uses
  [`base::grep()`](https://rdrr.io/r/base/grep.html) for matching.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
with the information requested with the following fields:

- `territorial_office`: territorial office, corresponding to each
  province of Spain except the Basque Country and Navarre.

- `url`: ATOM URL for the corresponding territorial office.

- `munic`: Name of the municipality.

- `date`: Reference date of the data. Note that **the information from
  this service is updated twice a year**.

## See also

INSPIRE API functions:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wms_get_layer.md),
[`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/dev/reference/inspire_wfs_get.md)

Other INSPIRE ATOM services:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md),
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md)

Other buildings:
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md)

Other databases:
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md),
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md),
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md)

## Examples

``` r
# \donttest{
catr_atom_get_buildings_db_all()
#> # A tibble: 7,611 × 4
#>    territorial_office             url                  munic date               
#>    <chr>                          <chr>                <chr> <dttm>             
#>  1 Territorial office 02 Albacete http://www.catastro… 0200… 2025-08-08 00:00:00
#>  2 Territorial office 02 Albacete http://www.catastro… 0200… 2025-08-08 00:00:00
#>  3 Territorial office 02 Albacete http://www.catastro… 0200… 2025-08-08 00:00:00
#>  4 Territorial office 02 Albacete http://www.catastro… 0200… 2025-08-08 00:00:00
#>  5 Territorial office 02 Albacete http://www.catastro… 0200… 2025-08-08 00:00:00
#>  6 Territorial office 02 Albacete http://www.catastro… 0200… 2025-08-08 00:00:00
#>  7 Territorial office 02 Albacete http://www.catastro… 0200… 2025-08-08 00:00:00
#>  8 Territorial office 02 Albacete http://www.catastro… 0200… 2025-08-08 00:00:00
#>  9 Territorial office 02 Albacete http://www.catastro… 0201… 2025-08-08 00:00:00
#> 10 Territorial office 02 Albacete http://www.catastro… 0201… 2025-08-08 00:00:00
#> # ℹ 7,601 more rows
# }
```
