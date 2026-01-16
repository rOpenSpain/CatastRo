# Package index

## ATOM INSPIRE API

These functions return
[sf](https://r-spatial.github.io/sf/reference/sf.html) objects as
provided by the INSPIRE ATOM services of the Spanish Cadastre.

- [`catr_atom_get_address()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address.md)
  : ATOM INSPIRE: Download all addresses of a municipality
- [`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md)
  [`catr_atom_get_address_db_to()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md)
  : ATOM INSPIRE: Reference database for ATOM addresses
- [`catr_atom_get_buildings()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings.md)
  : ATOM INSPIRE: Download all buildings of a municipality
- [`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md)
  [`catr_atom_get_buildings_db_to()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md)
  : ATOM INSPIRE: Reference database for ATOM buildings
- [`catr_atom_get_parcels()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels.md)
  : ATOM INSPIRE: Download all cadastral parcels of a municipality
- [`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md)
  [`catr_atom_get_parcels_db_to()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md)
  : ATOM INSPIRE: Reference database for ATOM cadastral parcels
- [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md)
  : ATOM INSPIRE: Search for municipality codes

## WFS INSPIRE API

These functions return
[sf](https://r-spatial.github.io/sf/reference/sf.html) objects as
provided by the INSPIRE WFS services of the Spanish Cadastre.

- [`catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md)
  :

  Reference SRS codes for
  [CatastRo](https://CRAN.R-project.org/package=CatastRo) APIs

- [`catr_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_codvia()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_rc()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md)
  [`catr_wfs_get_address_postalcode()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_address.md)
  : WFS INSPIRE: Download addresses

- [`catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md)
  [`catr_wfs_get_buildings_rc()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.md)
  : WFS INSPIRE: Download buildings

- [`catr_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_zoning()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_parcel()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_neigh_parcel()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)
  [`catr_wfs_get_parcels_parcel_zoning()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_parcels.md)
  : WFS INSPIRE: Download cadastral parcels

## WMS INSPIRE API

These functions return
[`SpatRaster`](https://rspatial.github.io/terra/reference/rast.html)
objects.

- [`catr_wms_get_layer()`](https://ropenspain.github.io/CatastRo/reference/catr_wms_get_layer.md)
  : WMS INSPIRE: Download map images

- [`esp_getTiles()`](https://ropenspain.github.io/mapSpain/reference/esp_getTiles.html)
  : Get static tiles from public administrations of Spain (from
  mapSpain)

- [`plotRGB(`*`<SpatRaster>`*`)`](https://rspatial.github.io/terra/reference/plotRGB.html)
  : Red-Green-Blue plot of a multi-layered SpatRaster (from terra)

- [`geom_spatraster_rgb()`](https://dieghernan.github.io/tidyterra/reference/geom_spatraster_rgb.html)
  :

  Visualise `SpatRaster` objects as images (from tidyterra)

## OVCCoordenadas API

These functions allows to access the
[OVCCoordenadas](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx)
service.

- [`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cpmrc.md)
  : OVCCoordenadas: Geocode a cadastral reference

- [`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor.md)
  : OVCCoordenadas: Reverse geocode a cadastral reference

- [`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_rccoor_distancia.md)
  : OVCCoordenadas: Reverse geocode cadastral references on a region

- [`catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md)
  :

  Reference SRS codes for
  [CatastRo](https://CRAN.R-project.org/package=CatastRo) APIs

## OVCCallejero API

These functions allows to access the
[OVCCallejero](http://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx)
service.

- [`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md)
  : OVCCallejero: Extract the code of a municipality
- [`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)
  : OVCCallejero: Extract a list of provinces with their codes

## Search functions

- [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md)
  : ATOM INSPIRE: Search for municipality codes
- [`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/reference/catr_get_code_from_coords.md)
  : Get the cadastral municipality code from coordinates
- [`catr_ovc_get_cod_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_munic.md)
  : OVCCallejero: Extract the code of a municipality
- [`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)
  : OVCCallejero: Extract a list of provinces with their codes

## Cache management

- [`catr_clear_cache()`](https://ropenspain.github.io/CatastRo/reference/catr_clear_cache.md)
  :

  Clear your [CatastRo](https://CRAN.R-project.org/package=CatastRo)
  cache dir

- [`catr_set_cache_dir()`](https://ropenspain.github.io/CatastRo/reference/catr_set_cache_dir.md)
  [`catr_detect_cache_dir()`](https://ropenspain.github.io/CatastRo/reference/catr_set_cache_dir.md)
  :

  Set your [CatastRo](https://CRAN.R-project.org/package=CatastRo) cache
  dir

## Databases and reference data

- [`catr_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md)
  [`catr_atom_get_address_db_to()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_address_db.md)
  : ATOM INSPIRE: Reference database for ATOM addresses

- [`catr_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md)
  [`catr_atom_get_buildings_db_to()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_buildings_db.md)
  : ATOM INSPIRE: Reference database for ATOM buildings

- [`catr_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md)
  [`catr_atom_get_parcels_db_to()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_get_parcels_db.md)
  : ATOM INSPIRE: Reference database for ATOM cadastral parcels

- [`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md)
  : ATOM INSPIRE: Search for municipality codes

- [`catr_srs_values`](https://ropenspain.github.io/CatastRo/reference/catr_srs_values.md)
  :

  Reference SRS codes for
  [CatastRo](https://CRAN.R-project.org/package=CatastRo) APIs

## About the package

- [`CatastRo`](https://ropenspain.github.io/CatastRo/reference/CatastRo-package.md)
  [`CatastRo-package`](https://ropenspain.github.io/CatastRo/reference/CatastRo-package.md)
  : CatastRo: Interface to the API 'Sede Electronica Del Catastro'
