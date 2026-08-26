# Package index

## Retrieve cadastral data

Download complete municipal datasets, query individual cadastral
features and retrieve georeferenced map images.

### Complete municipal datasets

Discover and download complete address, building and cadastral parcel
datasets through ATOM INSPIRE services.

- [`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md)
  : ATOM INSPIRE: Download all addresses for a municipality
- [`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md)
  [`catr_atom_get_address_db_to()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md)
  : ATOM INSPIRE: List address download URLs
- [`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md)
  : ATOM INSPIRE: Download all buildings for a municipality
- [`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md)
  [`catr_atom_get_buildings_db_to()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md)
  : ATOM INSPIRE: List building download URLs
- [`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md)
  : ATOM INSPIRE: Download all cadastral parcels for a municipality
- [`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md)
  [`catr_atom_get_parcels_db_to()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md)
  : ATOM INSPIRE: List cadastral parcel download URLs

### Features by area or identifier

Query address, building and cadastral parcel features through WFS
INSPIRE services.

- [`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_codvia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_rc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_postalcode()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md)
  : WFS INSPIRE: Download addresses
- [`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md)
  [`catr_wfs_get_buildings_rc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md)
  : WFS INSPIRE: Download buildings
- [`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_zoning()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_parcel()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_neigh_parcel()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_parcel_zoning()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md)
  : WFS INSPIRE: Download cadastral parcels
- [`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/dev/reference/inspire_wfs_get.md)
  : Query WFS INSPIRE services

### Georeferenced map images

Download cadastral map layers through the WMS INSPIRE service.

- [`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wms_get_layer.md)
  : WMS INSPIRE: Download georeferenced map images

## Find cadastral identifiers

Convert between cadastral references and coordinates, or look up
province and municipality codes.

### References and coordinates

Geocode cadastral references and reverse geocode spatial coordinates.

- [`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cpmrc.md)
  : OVCCoordenadas: Geocode a cadastral reference
- [`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor.md)
  : OVCCoordenadas: Reverse geocode coordinates
- [`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor_distancia.md)
  : OVCCoordenadas: Find cadastral references near coordinates

### Province and municipality lookup

Find Spanish Cadastre province and municipality identifiers by name,
code or coordinates.

- [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md)
  : ATOM INSPIRE: Search for municipality codes
- [`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_get_code_from_coords.md)
  : Get a cadastral municipality code from coordinates
- [`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_munic.md)
  : OVCCallejero: Get municipality codes
- [`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_provinces.md)
  : OVCCallejero: Get province codes

## Configure and inspect CatastRo

Manage downloaded files, inspect supported coordinate systems and access
package-level documentation.

### Cache management

Configure, detect and clear the local cache used by **CatastRo**.

- [`catr_clear_cache()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_clear_cache.md)
  :

  Clear your [CatastRo](https://CRAN.R-project.org/package=CatastRo)
  cache directory

- [`catr_set_cache_dir()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_set_cache_dir.md)
  [`catr_detect_cache_dir()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_set_cache_dir.md)
  :

  Set your [CatastRo](https://CRAN.R-project.org/package=CatastRo) cache
  directory

### Coordinate reference systems

Inspect the SRS codes supported by the package services.

- [`catr_srs_values`](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md)
  :

  Reference SRS codes for
  [CatastRo](https://CRAN.R-project.org/package=CatastRo) services

### Package overview

Read package-level documentation and discover useful links.

- [`CatastRo`](https://ropenspain.github.io/CatastRo/dev/reference/CatastRo-package.md)
  [`CatastRo-package`](https://ropenspain.github.io/CatastRo/dev/reference/CatastRo-package.md)
  : CatastRo: Interface to the Spanish 'Catastro' Web Services
