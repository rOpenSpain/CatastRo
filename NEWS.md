# CatastRo 1.0.2

- `download_url()` and `get_request_body()` now return `NULL` when transport errors interrupt HTTP requests, including reset connections.
- Improve internal maintenance, **cli** messages, **roxygen2** metadata and package documentation.

# CatastRo 1.0.1

- Improve documentation for cache behavior, INSPIRE services and OVC reference
  data.

# CatastRo 1.0.0

This major release introduces a full overhaul of the codebase and test suite.
All requests now use **httr2**. Cached files are organized into topic-based
subdirectories for easier management.

> Because of internal changes, **existing caches are not compatible** with this
> release and must be rebuilt.

Persistent cache directories now use `tools::R_user_dir()` instead of
`rappdirs::user_config_dir()`. If you already have a cache directory,
**CatastRo** displays a one-time migration message.

The package now requires **R ≥ 4.1.0** and dependency updates improve both
performance and maintainability. All functions return tidy objects (tibbles or
`sf` objects with tibble data).

## Major changes

- Minimum required **R** version is now **4.1.0**.
- Refactor the code and test suite for improved stability.
- Switch API requests to **httr2**.
- New options (especially for macOS and Linux users):
  - On SSL errors, use `options(catastro_ssl_verify = 0)` to disable SSL
    verification.
  - Query timeout can be controlled with `options(catastro_timeout = 300)`
    (default value). Check `httr2::req_timeout()` for details.
- Reorganize the cache into topic-based subfolders.

> **Note:** Previous caches must be recreated.

### Compatibility and performance

- Require **R ≥ 4.1.0**.
- Update dependencies:
  - Add: **cli**, **lifecycle**, **withr**.
  - Remove: **png**, **slippymath**.
- Return tidy objects consistently.
- Migrate the vignette engine to Quarto.

## Deprecations

- The `cache` argument is deprecated in all functions.

## New features

- Add `inspire_wfs_get()`, a general function that downloads data from any
  INSPIRE-based service endpoint.

## Other updates

- Review and improve documentation.
- Rewrite the full test suite.
- Use **cli** for all messages.

# CatastRo 0.4.1

- Update documentation and URLs.

# CatastRo 0.4.0

- Update entry points (#53).

# CatastRo 0.3.1

- Migrate from **httr** to **httr2** (#44), with no visible change for users.
- Improve documentation.

# CatastRo 0.3.0

- `catr_atom_get_address()` also returns the names of the streets (layer
  `"ThoroughfareName"` of the `*.gml` file). The new fields are named with the
  prefix `tfname_*`.
- Add a helper function for detecting `cache_dir`:
  `catr_detect_cache_dir()`.
- Update documentation and tests.

# CatastRo 0.2.3

- Update documentation and package maintenance files.
- Adapt `catr_wms_get_layer()` to **mapSpain** (\>= 0.7.0).

# CatastRo 0.2.2

- Add **tidyterra** to `Suggests`.
- `catr_get_code_from_coords()` now handles `sfc` objects (#26).
- `catr_clear_cache()` now has `config = FALSE` as default argument.

# CatastRo 0.2.1

- Fix **CRAN** tests.

# CatastRo 0.2.0

**Overall revamp of the package. Major changes to the API.**

- Add **ATOM INSPIRE** capabilities:
  - Addresses: `catr_atom_get_address()`, `catr_atom_get_address_db_all()`.
  - Cadastral parcels: `catr_atom_get_parcels()`,
    `catr_atom_get_parcels_db_all()`.
  - Buildings: `catr_atom_get_buildings()`, `catr_atom_get_buildings_db_all()`.
- Add **WFS INSPIRE** capabilities:
  - Addresses: `catr_wfs_get_address_bbox()`, `catr_wfs_get_address_codvia()`,
    `catr_wfs_get_address_postalcode()`, `catr_wfs_get_address_rc()`.
  - Cadastral parcels: `catr_wfs_get_parcels_neigh_parcel()`,
    `catr_wfs_get_parcels_parcel()`, `catr_wfs_get_parcels_parcel_zoning()`,
    `catr_wfs_get_parcels_zoning()`.
  - Buildings: `catr_wfs_get_buildings_bbox()`, `catr_wfs_get_buildings_rc()`.
- Add **WMS INSPIRE** capabilities: `catr_wms_get_layer()`.
- Add a new interface for **OVC services**. Deprecated previous functions in
  favor of the new API:
  - The new SRS reference dataset in `?catr_srs_values` replaces `coordinates`.
  - `catr_ovc_get_rccoor_distancia()` replaces `near_rc()`.
  - `catr_ovc_get_rccoor()` replaces `get_rc()`.
  - `catr_ovc_get_cpmrc()` replaces `get_coor()`.
- Add
  [precomputed](https://ropensci.org/blog/2019/12/08/precompute-vignettes/)
  vignettes.

# CatastRo 0.1.0

- Initial release.
