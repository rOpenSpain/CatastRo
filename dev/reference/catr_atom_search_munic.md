# ATOM INSPIRE: Search for municipality codes

Search for a municipality (as a string, part of a string, or code) and
get the corresponding code as per the Cadastre.

## Usage

``` r
catr_atom_search_munic(
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

  Municipality to extract. It can be a part of a string or the cadastral
  code. See `catr_atom_search_munic()` for getting the cadastral codes.

- to:

  Optional argument for defining the territorial office to which `munic`
  belongs. This argument is a helper for narrowing the search.

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

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html).

## See also

Other INSPIRE ATOM services:
[`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md),
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md)

Other search:
[`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_get_code_from_coords.md),
[`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_munic.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_provinces.md)

Other databases:
[`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md),
[`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md),
[`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md),
[`catr_srs_values`](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md)

## Examples

``` r
# \donttest{
catr_atom_search_munic("Mad")
#>                     territorial_office                               munic
#> 1257      Territorial office 09 Burgos                        09178-HUMADA
#> 4323      Territorial office 28 Madrid                        28900-MADRID
#> 1338      Territorial office 09 Burgos                       09287-QUEMADA
#> 1899 Territorial office 13 Ciudad Real                       13011-ALMADEN
#> 4098        Territorial office 27 Lugo                       27021-XERMADE
#> 4222      Territorial office 28 Madrid                      28078-MADARCOS
#> 5078   Territorial office 37 Salamanca                      37177-MADROÑAL
#> 1604     Territorial office 10 Cáceres                     10116-MADROÑERA
#> 5537     Territorial office 40 Segovia                     40134-MADERUELO
#> 7564    Territorial office 50 Zaragoza                     50280-VALMADRID
#> 2494      Territorial office 17 Girona                    17104-MADREMANYA
#> 2812 Territorial office 19 Guadalajara                    19024-ALMADRONES
#> 4777    Territorial office 34 Palencia                    34182-TORQUEMADA
#> 4972   Territorial office 37 Salamanca                    37059-BUENAMADRE
#> 5701     Territorial office 41 Sevilla                    41057-EL MADROÑO
#> 6439      Territorial office 45 Toledo                    45088-MADRIDEJOS
#> 7140      Territorial office 49 Zamora                    49115-EL MADERAL
#> 7141      Territorial office 49 Zamora                    49116-MADRIDANOS
#> 44      Territorial office 02 Albacete                   02045-MADRIGUERAS
#> 1603     Territorial office 10 Cáceres                   10115-MADRIGALEJO
#> 1900 Territorial office 13 Ciudad Real                   13012-ALMADENEJOS
#> 3643        Territorial office 24 León                   24203-VEGAQUEMADA
#> 4055    Territorial office 26 La Rioja                   26161-VALDEMADERA
#> 4348      Territorial office 29 Málaga                   29025-BENALMADENA
#> 1685     Territorial office 10 Cáceres                  10198-TORREQUEMADA
#> 3368        Territorial office 23 Jaén                  23004-ALDEAQUEMADA
#> 6345      Territorial office 44 Teruel                 44275-VILLARQUEMADO
#> 1266      Territorial office 09 Burgos             09187-JARAMILLO QUEMADO
#> 1624     Territorial office 10 Cáceres             10136-NAVAS DEL MADROÑO
#> 4217      Territorial office 28 Madrid             28073-HUMANES DE MADRID
#> 4262      Territorial office 28 Madrid             28123-RIVAS-VACIAMADRID
#> 57      Territorial office 02 Albacete            02058-PATERNA DEL MADERA
#> 1274      Territorial office 09 Burgos            09200-MADRIGAL DEL MONTE
#> 1602     Territorial office 10 Cáceres           10114-MADRIGAL DE LA VERA
#> 4266      Territorial office 28 Madrid           28127-LAS ROZAS DE MADRID
#> 5653     Territorial office 41 Sevilla           41009-ALMADEN DE LA PLATA
#> 1275      Territorial office 09 Burgos         09201-MADRIGALEJO DEL MONTE
#> 5440     Territorial office 40 Segovia         40005-ALCONADA DE MADERUELO
#> 429        Territorial office 05 Avila  05114-MADRIGAL DE LAS ALTAS TORRES
#> 3600        Territorial office 24 León 24156-SANTA CRISTINA DE VALMADRIGAL
#>      catrcode
#> 1257    09178
#> 4323    28900
#> 1338    09287
#> 1899    13011
#> 4098    27021
#> 4222    28078
#> 5078    37177
#> 1604    10116
#> 5537    40134
#> 7564    50280
#> 2494    17104
#> 2812    19024
#> 4777    34182
#> 4972    37059
#> 5701    41057
#> 6439    45088
#> 7140    49115
#> 7141    49116
#> 44      02045
#> 1603    10115
#> 1900    13012
#> 3643    24203
#> 4055    26161
#> 4348    29025
#> 1685    10198
#> 3368    23004
#> 6345    44275
#> 1266    09187
#> 1624    10136
#> 4217    28073
#> 4262    28123
#> 57      02058
#> 1274    09200
#> 1602    10114
#> 4266    28127
#> 5653    41009
#> 1275    09201
#> 5440    40005
#> 429     05114
#> 3600    24156
# }
```
