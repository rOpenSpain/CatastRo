# ATOM INSPIRE: Search for municipality codes

Search for a municipality (as a string, part of string or code) and get
the corresponding coding as per the Cadastre.

## Usage

``` r
catr_atom_search_munic(
  munic,
  to = NULL,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Arguments

- munic:

  Municipality to extract, It can be a part of a string or the cadastral
  code.

- to:

  Optional parameter for defining the Territorial Office to which
  `munic` belongs. This parameter is a helper for narrowing the search.

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

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html).

## See also

Other INSPIRE ATOM services:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md)

Other search:
[`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/reference/catr_get_code_from_coords.md),
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)

Other databases:
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md),
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md)

## Examples

``` r
# \donttest{
catr_atom_search_munic("Mad")
#> Warning: cannot open URL 'https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/ES.SDGC.AD.atom.xml': HTTP status was '500 Internal Server Error'
#> Warning: cannot open URL 'https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/ES.SDGC.AD.atom.xml': HTTP status was '500 Internal Server Error'
#> Download failed
#> 
#> url 
#>  https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/ES.SDGC.AD.atom.xml not reachable.
#> 
#> Please try with another options. If you think this is a bug please consider opening an issue
#> Error in catr_hlp_dwnload(api_entry, filename, cache_dir, verbose, update_cache,     cache): 
#> Execution halted
# }
```
