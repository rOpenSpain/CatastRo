# Changelog

## CatastRo 1.0.0

This major release introduces a full overhaul of the codebase and test
suite. All requests now use **httr2**, and cached files are reorganized
into topic-based subfolders for easier management.

> Because of internal changes, **existing caches are not compatible**
> with this release and must be rebuilt.

We have transitioned from
[`rappdirs::user_config_dir()`](https://rappdirs.r-lib.org/reference/user_data_dir.html)
to [`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) for
managing your persistent cache directory. If you are a heavy
**CatastRo** user and already have a cache directory in place, you’ll
receive a one-time friendly message informing you about this migration.
Consider it a warm welcome to **CatastRo** 1.0.0 😉.

The package now requires **R ≥ 4.1.0**, and dependency updates improve
both performance and maintainability. All functions return tidy objects
(tibbles or `sf` objects with tibble data).

### Major changes

- Minimum required R version is now **4.1.0**.
- Refactor code and test suite for improved stability.
- Switch API requests to **httr2**.
- New options (especially for macOS and Linux users):
  - On SSL errors use `options(catastro_ssl_verify = 0)` to disable SSL
    verification.
  - Query timeout can be controlled with
    `options(catastro_timeout = 300)` (Default value). Check
    [`httr2::req_timeout()`](https://httr2.r-lib.org/reference/req_timeout.html)
    for details.
- Reorganize cache into topic-based subfolders.

> **Note:** Previous caches must be recreated.

#### Compatibility and performance

- Require **R ≥ 4.1.0**.
- Update dependencies:
  - Add: **cli**, **lifecycle**, **withr**.
  - Remove: **png**, **slippymath**.
- Return tidy objects consistently.
- Vignettes engine has been migrated to Quarto.

### Deprecations

- `cache` argument has been deprecated in all functions.

### New features

- Added
  [`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/reference/inspire_wfs_get.md),
  a general function that downloads data of any INSPIRE-based API
  endpoint.

### Other updates

- Rewrite the full test suite.
- Review and improve documentation.
- Use **cli** for all messages.

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
  now has `config = FALSE` as default argument.

## CatastRo 0.2.1

CRAN release: 2022-03-08

- Fix **CRAN** tests.

## CatastRo 0.2.0

CRAN release: 2022-02-28

**Overall revamp of the package. Major changes to the API.**

- Added **ATOM INSPIRE** capabilities:
  - Addresses:
    [`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md),
    [`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md).
  - Cadastral Parcels:
    [`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md),
    [`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md).
  - Buildings:
    [`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md),
    [`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md).
- Added **WFS INSPIRE** capabilities:
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
- Added **WMS INSPIRE** capabilities:
  [`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md).
- Added new interface for **OVC Services**. Deprecated previous
  functions in favor of the new API:
  - New SRS database in
    [`?catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md),
    replaces `coordinates`.
  - [`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)
    replaces `near_rc()`.
  - [`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md)
    replaces `get_rc()`.
  - [`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cpmrc.md)
    replaces `get_coor()`.
- Added
  [pre-computed](https://ropensci.org/blog/2019/12/08/precompute-vignettes/)
  vignettes.

## CatastRo 0.1.0

- Initial release.
