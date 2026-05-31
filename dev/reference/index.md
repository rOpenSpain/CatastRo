# Package index

## ATOM INSPIRE services

These functions return
[sf](https://r-spatial.github.io/sf/reference/sf.html) objects from the
ATOM INSPIRE services of the Spanish Cadastre.

- [`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address.md)
  : ATOM INSPIRE: download all addresses of a municipality
- [`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md)
  [`catr_atom_get_address_db_to()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md)
  : ATOM INSPIRE: reference database for ATOM addresses
- [`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings.md)
  : ATOM INSPIRE: download all buildings of a municipality
- [`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md)
  [`catr_atom_get_buildings_db_to()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md)
  : ATOM INSPIRE: reference database for ATOM buildings
- [`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels.md)
  : ATOM INSPIRE: download all cadastral parcels of a municipality
- [`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md)
  [`catr_atom_get_parcels_db_to()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md)
  : ATOM INSPIRE: reference database for ATOM cadastral parcels
- [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md)
  : ATOM INSPIRE: search for municipality codes

## WFS INSPIRE services

These functions return
[sf](https://r-spatial.github.io/sf/reference/sf.html) objects from the
WFS INSPIRE services of the Spanish Cadastre.

- [`catr_srs_values`](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md)
  :

  Reference SRS codes for
  [CatastRo](https://CRAN.R-project.org/package=CatastRo) services

- [`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_codvia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_rc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_postalcode()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_address.md)
  : WFS INSPIRE: download addresses

- [`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md)
  [`catr_wfs_get_buildings_rc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_buildings.md)
  : WFS INSPIRE: download buildings

- [`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_zoning()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_parcel()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_neigh_parcel()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_parcel_zoning()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wfs_get_parcels.md)
  : WFS INSPIRE: download cadastral parcels

- [`inspire_wfs_get()`](https://ropenspain.github.io/CatastRo/dev/reference/inspire_wfs_get.md)
  : Client tool for WFS INSPIRE services

## WMS INSPIRE services

These functions return
[`SpatRaster`](https://rspatial.github.io/terra/reference/rast.html) map
images from the WMS INSPIRE services of the Spanish Cadastre.

- [`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_wms_get_layer.md)
  : WMS INSPIRE: download map images

- [`esp_get_tiles()`](https://ropenspain.github.io/mapSpain/reference/esp_get_tiles.html)
  [`esp_get_attributions()`](https://ropenspain.github.io/mapSpain/reference/esp_get_tiles.html)
  : Get static tiles from public administrations of Spain (from
  mapSpain)

- [`plotRGB(`*`<SpatRaster>`*`)`](https://rspatial.github.io/terra/reference/plotRGB.html)
  : Red-Green-Blue plot of a multi-layered SpatRaster (from terra)

- [`geom_spatraster_rgb()`](https://dieghernan.github.io/tidyterra/reference/geom_spatraster_rgb.html)
  :

  Visualise `SpatRaster` objects as images (from tidyterra)

## OVCCoordenadas service

These functions geocode and reverse geocode cadastral references using
the
[OVCCoordenadas](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx)
service.

- [`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cpmrc.md)
  : OVCCoordenadas: geocode a cadastral reference

- [`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor.md)
  : OVCCoordenadas: reverse geocode a cadastral reference

- [`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor_distancia.md)
  : OVCCoordenadas: reverse geocode cadastral references near
  coordinates

- [`catr_srs_values`](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md)
  :

  Reference SRS codes for
  [CatastRo](https://CRAN.R-project.org/package=CatastRo) services

## OVCCallejero service

These functions query province and municipality codes using the
[OVCCallejero](http://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx)
service.

- [`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_munic.md)
  : OVCCallejero: extract the code of a municipality
- [`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_provinces.md)
  : OVCCallejero: extract provinces with their codes

## Search functions

Helpers for finding cadastral municipality codes and related reference
data.

- [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md)
  : ATOM INSPIRE: search for municipality codes
- [`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_get_code_from_coords.md)
  : Get the cadastral municipality code from coordinates
- [`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_munic.md)
  : OVCCallejero: extract the code of a municipality
- [`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cod_provinces.md)
  : OVCCallejero: extract provinces with their codes

## Cache management

Tools for configuring, detecting and clearing the local cache used by
**CatastRo**.

- [`catr_clear_cache()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_clear_cache.md)
  :

  Clear your [CatastRo](https://CRAN.R-project.org/package=CatastRo)
  cache directory

- [`catr_set_cache_dir()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_set_cache_dir.md)
  [`catr_detect_cache_dir()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_set_cache_dir.md)
  :

  Set your [CatastRo](https://CRAN.R-project.org/package=CatastRo) cache
  directory

## Databases and reference data

Reference tables and helper databases used by the package services.

- [`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md)
  [`catr_atom_get_address_db_to()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_address_db.md)
  : ATOM INSPIRE: reference database for ATOM addresses

- [`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md)
  [`catr_atom_get_buildings_db_to()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_buildings_db.md)
  : ATOM INSPIRE: reference database for ATOM buildings

- [`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md)
  [`catr_atom_get_parcels_db_to()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_get_parcels_db.md)
  : ATOM INSPIRE: reference database for ATOM cadastral parcels

- [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_atom_search_munic.md)
  : ATOM INSPIRE: search for municipality codes

- [`catr_srs_values`](https://ropenspain.github.io/CatastRo/dev/reference/catr_srs_values.md)
  :

  Reference SRS codes for
  [CatastRo](https://CRAN.R-project.org/package=CatastRo) services

## Helpers and package metadata

Package-level documentation and example helpers.

- [`CatastRo`](https://ropenspain.github.io/CatastRo/dev/reference/CatastRo-package.md)
  [`CatastRo-package`](https://ropenspain.github.io/CatastRo/dev/reference/CatastRo-package.md)
  : CatastRo: Access Spanish Cadastre Services
