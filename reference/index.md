# Package index

## INSPIRE services

Retrieve cadastral addresses, buildings, parcels and georeferenced map
images through Spanish Cadastre INSPIRE services.

### ATOM downloads

Download complete municipal cadastral datasets and query their metadata.

- [`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md)
  : ATOM INSPIRE: download all addresses of a municipality
- [`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md)
  [`catr_atom_get_address_db_to()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md)
  : ATOM INSPIRE: reference database for ATOM addresses
- [`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md)
  : ATOM INSPIRE: download all buildings of a municipality
- [`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md)
  [`catr_atom_get_buildings_db_to()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md)
  : ATOM INSPIRE: reference database for ATOM buildings
- [`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md)
  : ATOM INSPIRE: download all cadastral parcels of a municipality
- [`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md)
  [`catr_atom_get_parcels_db_to()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md)
  : ATOM INSPIRE: reference database for ATOM cadastral parcels
- [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md)
  : ATOM INSPIRE: search for municipality codes

### WFS queries

Retrieve cadastral features for a selected bounding box or cadastral
identifier.

- [`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_codvia()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_rc()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_postalcode()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md)
  : WFS INSPIRE: download addresses
- [`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md)
  [`catr_wfs_get_buildings_rc()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md)
  : WFS INSPIRE: download buildings
- [`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_zoning()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_parcel()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_neigh_parcel()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_parcel_zoning()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)
  : WFS INSPIRE: download cadastral parcels
- [`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/reference/inspire_wfs_get.md)
  : Query WFS INSPIRE services

### WMS maps

Download georeferenced cadastral map images.

- [`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)
  : WMS INSPIRE: download map images

## OVC services

Geocode cadastral references, reverse geocode coordinates and query
administrative codes through Spanish Cadastre OVC services.

### Coordinates and cadastral references

Convert between cadastral references and spatial coordinates.

- [`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cpmrc.md)
  : OVCCoordenadas: geocode a cadastral reference
- [`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md)
  : OVCCoordenadas: reverse geocode a cadastral reference
- [`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)
  : OVCCoordenadas: reverse geocode cadastral references near
  coordinates

### Province and municipality codes

Query province and municipality codes used by the Spanish Cadastre.

- [`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md)
  : OVCCallejero: extract the code of a municipality
- [`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)
  : OVCCallejero: extract provinces with their codes

## Utilities and reference data

Search Spanish Cadastre identifiers, manage downloaded files and inspect
package reference data.

### Search

Find cadastral municipality codes and related reference information.

- [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md)
  : ATOM INSPIRE: search for municipality codes
- [`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/reference/catr_get_code_from_coords.md)
  : Get the cadastral municipality code from coordinates
- [`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md)
  : OVCCallejero: extract the code of a municipality
- [`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)
  : OVCCallejero: extract provinces with their codes

### Cache management

Configure, detect and clear the local cache used by **CatastRo**.

- [`catr_clear_cache()`](https://ropenspain.github.io/CatastRo/reference/catr_clear_cache.md)
  :

  Clear your [CatastRo](https://CRAN.R-project.org/package=CatastRo)
  cache directory

- [`catr_set_cache_dir()`](https://ropenspain.github.io/CatastRo/reference/catr_set_cache_dir.md)
  [`catr_detect_cache_dir()`](https://ropenspain.github.io/CatastRo/reference/catr_set_cache_dir.md)
  :

  Set your [CatastRo](https://CRAN.R-project.org/package=CatastRo) cache
  directory

### Datasets

Inspect SRS reference data used by the package services.

- [`catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md)
  :

  Reference SRS codes for
  [CatastRo](https://CRAN.R-project.org/package=CatastRo) services

## Helpers and package metadata

Read package-level documentation.

- [`CatastRo`](https://ropenspain.github.io/CatastRo/reference/CatastRo-package.md)
  [`CatastRo-package`](https://ropenspain.github.io/CatastRo/reference/CatastRo-package.md)
  : CatastRo: Interface to the Spanish 'Catastro' Web Services
