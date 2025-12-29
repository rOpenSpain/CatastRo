# ATOM INSPIRE: Reference database for ATOM buildings

Create a database containing the urls provided in the INSPIRE ATOM
service of the Spanish Cadastre for extracting buildings.

- `catr_atom_get_buildings_db_all()` provides a top-level table
  including information of all the territorial offices (except Basque
  Country and Navarre) listing the municipalities included on each
  office.

- `catr_atom_get_buildings_db_to()` provides a table for the specified
  territorial office including information for each of the
  municipalities of that office.

## Usage

``` r
catr_atom_get_buildings_db_all(
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)

catr_atom_get_buildings_db_to(
  to,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Source

<https://www.catastro.hacienda.gob.es/INSPIRE/buildings/ES.SDGC.BU.atom.xml>

## Arguments

- cache:

  A logical whether to do caching. Default is `TRUE`. See **About
  caching** section on
  [`catr_set_cache_dir()`](https://ropenspain.github.io/CatastRo/reference/catr_set_cache_dir.md).

- update_cache:

  A logical whether to update cache. Default is `FALSE`. When set to
  `TRUE` it would force a fresh download of the source file.

- cache_dir:

  A path to a cache directory. On `NULL` value (the default) the
  function would store the cached files on the
  [`tempdir`](https://rdrr.io/r/base/tempfile.html).

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

- to:

  Territorial office. It can be any type of string, the function would
  perform a search using
  [`base::grep()`](https://rdrr.io/r/base/grep.html).

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
the information requested.

- `catr_atom_get_buildings_db_all()` includes the following fields:

  - `territorial_office`: Territorial office, corresponding to each
    province of Spain expect Basque Country and Navarre.

  - `url`: ATOM url for the corresponding territorial office.

  - `munic`: Name of the municipality.

  - `date`: Reference date of the data. Note that **the information of
    this service is updated twice a year**.

- `catr_atom_get_buildings_db_to()` includes the following fields:

  - `munic`: Name of the municipality.

  - `url`: url for downloading information of the corresponding
    municipality.

  - `date`: Reference date of the data. Note that **the information of
    this service is updated twice a year**.

## See also

INSPIRE API functions:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
[`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
[`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)

Other INSPIRE ATOM services:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md)

Other buildings:
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md)

Other databases:
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md),
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md)

## Examples

``` r
# \donttest{
catr_atom_get_buildings_db_all()
#> Warning: cannot open URL 'https://www.catastro.hacienda.gob.es/INSPIRE/buildings/ES.SDGC.BU.atom.xml': HTTP status was '500 Internal Server Error'
#> Warning: cannot open URL 'https://www.catastro.hacienda.gob.es/INSPIRE/buildings/ES.SDGC.BU.atom.xml': HTTP status was '500 Internal Server Error'
#> Download failed
#> 
#> url 
#>  https://www.catastro.hacienda.gob.es/INSPIRE/buildings/ES.SDGC.BU.atom.xml not reachable.
#> 
#> Please try with another options. If you think this is a bug please consider opening an issue
#> Error in catr_hlp_dwnload(api_entry, filename, cache_dir, verbose, update_cache,     cache): 
#> Execution halted
# }
```
