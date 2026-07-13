# ATOM INSPIRE: list building download URLs

Create a table of URLs provided by the Spanish Cadastre ATOM INSPIRE
service for downloading buildings.

`catr_atom_get_buildings_db_all()` provides a summary table with all
territorial offices, except the Basque Country and Navarre and the
municipalities included in each office.
`catr_atom_get_buildings_db_to()` provides a table for one territorial
office and its municipalities.

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

- to:

  Character string. Territorial office to match using
  [`base::grep()`](https://rdrr.io/r/base/grep.html).

## Value

A [tibble](https://dplyr.tidyverse.org/reference/defunct.html) with the
requested information in the following columns:

- `territorial_office`: Territorial office, corresponding to each
  province of Spain except the Basque Country and Navarre.

- `url`: ATOM URL for the corresponding territorial office.

- `munic`: Name of the municipality.

- `date`: Reference date of the data. The information from this service
  is updated twice a year.

## See also

Download data from ATOM INSPIRE services:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md),
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md)

Work with cadastral buildings:
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md)

## Examples

``` r
# \donttest{
catr_atom_get_buildings_db_all()
#> # A tibble: 7,611 × 4
#>    territorial_office             url                  munic date               
#>    <chr>                          <chr>                <chr> <dttm>             
#>  1 Territorial office 02 Albacete http://www.catastro… 0200… 2026-02-20 00:00:00
#>  2 Territorial office 02 Albacete http://www.catastro… 0200… 2026-02-20 00:00:00
#>  3 Territorial office 02 Albacete http://www.catastro… 0200… 2026-02-20 00:00:00
#>  4 Territorial office 02 Albacete http://www.catastro… 0200… 2026-02-20 00:00:00
#>  5 Territorial office 02 Albacete http://www.catastro… 0200… 2026-02-20 00:00:00
#>  6 Territorial office 02 Albacete http://www.catastro… 0200… 2026-02-20 00:00:00
#>  7 Territorial office 02 Albacete http://www.catastro… 0200… 2026-02-20 00:00:00
#>  8 Territorial office 02 Albacete http://www.catastro… 0200… 2026-02-20 00:00:00
#>  9 Territorial office 02 Albacete http://www.catastro… 0201… 2026-02-20 00:00:00
#> 10 Territorial office 02 Albacete http://www.catastro… 0201… 2026-02-20 00:00:00
#> # ℹ 7,601 more rows
# }
```
