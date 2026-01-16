# Changelog

## CatastRo (development version)

- The minimum **R** version required is now 4.1.0.

## CatastRo 0.4.1

CRAN release: 2025-03-24

- Update documentation and URLs.

## CatastRo 0.4.0

CRAN release: 2024-06-02

- Update entry points
  ([\#53](https://github.com/rOpenSpain/CatastRo/issues/53)).

## CatastRo 0.3.1

CRAN release: 2024-04-12

- Migrate from **httr** to **httr2**
  ([\#44](https://github.com/rOpenSpain/CatastRo/issues/44)), with no
  visible change for users.
- Improve documentation.

## CatastRo 0.3.0

CRAN release: 2024-01-18

- [`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md)
  also returns the names of the streets (layer `"ThoroughfareName"` of
  the `*.gml` file). The new fields are named with the prefix
  `tfname_*`.
- Add a helper function for easily detecting the `cache_dir`:
  [`catr_detect_cache_dir()`](https://ropenspain.github.io/CatastRo/reference/catr_set_cache_dir.md).
- Update documentation and tests.

## CatastRo 0.2.3

CRAN release: 2023-01-08

- Housekeeping and updates of documentation.
- Adapt
  [`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)
  to **mapSpain** (\>= 0.7.0).

## CatastRo 0.2.2

CRAN release: 2022-05-27

- Add **tidyterra** to ‘Suggests’.
- Now
  [`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/reference/catr_get_code_from_coords.md)
  handles `sfc` objects
  ([\#26](https://github.com/rOpenSpain/CatastRo/issues/26)).
- [`catr_clear_cache()`](https://ropenspain.github.io/CatastRo/reference/catr_clear_cache.md)
  now has `config = FALSE` as default parameter.

## CatastRo 0.2.1

CRAN release: 2022-03-08

- Fix **CRAN** tests.

## CatastRo 0.2.0

CRAN release: 2022-02-28

**Overall revamp of the package. Major changes to the API.**

- Add **ATOM INSPIRE** capabilities:
  - Addresses:
    [`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
    [`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md).
  - Cadastral Parcels:
    [`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
    [`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md).
  - Buildings:
    [`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
    [`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md).
- Add **WFS INSPIRE** capabilities:
  - Addresses:
    [`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
    [`catr_wfs_get_address_codvia()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
    [`catr_wfs_get_address_postalcode()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md),
    [`catr_wfs_get_address_rc()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md).
  - Cadastral Parcels:
    [`catr_wfs_get_parcels_neigh_parcel()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
    [`catr_wfs_get_parcels_parcel()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
    [`catr_wfs_get_parcels_parcel_zoning()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md),
    [`catr_wfs_get_parcels_zoning()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md).
  - Buildings:
    [`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md),
    [`catr_wfs_get_buildings_rc()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md).
- Add **WMS INSPIRE** capabilities:
  [`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md).
- New interface for **OVC Services**. Deprecated previous functions in
  favor of the new API:
  - New SRS database in `catr_srs_values`, replaces `coordinates`.
  - [`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)
    replaces `near_rc()`.
  - [`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md)
    replaces `get_rc()`.
  - [`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cpmrc.md)
    replaces `get_coor()`.
- Add
  [pre-computed](https://ropensci.org/blog/2019/12/08/precompute-vignettes/)
  vignettes.

## CatastRo 0.1.0

- Initial release.
