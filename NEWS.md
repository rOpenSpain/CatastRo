# CatastRo (development version)

-   Overall revamp of the package. Major changes on the API.

-   Add **ATOM INSPIRE** capabilities:

    -   Addresses: `catr_atom_ad()`, `catr_atom_ad_db_all()`.
    -   Cadastral Parcels: `catr_atom_cp()`, `catr_atom_cp_db_all()`.
    -   Buildings: `catr_atom_bu()`, `catr_atom_bu_db_all()`.

-   Add **WFS INSPIRE** capabilities:

    -   Addresses: `catr_wfs_ad_bbox()`, `catr_wfs_ad_codvia()`,
        `catr_wfs_ad_postalcode()`, `catr_wfs_ad_rc()`.
    -   Cadastral Parcels: `catr_wfs_cp_neigh_parcel()`, `catr_wfs_cp_parcel()`,
        `catr_wfs_cp_parcel_zoning()`, `catr_wfs_cp_zoning()`.
    -   Buildings: `catr_wfs_bu_bbox()`,`catr_wfs_bu_rc()`.

-   Add **WMS INSPIRE** capabilities: `catr_wms_layer()`.

-   New interface for **OVC Services**. Deprecate previous functions in favor of
    the new API:

    -   New SRS database on `catr_srs_values`, replaces `coordinates`.
    -   `catr_ovc_rccoor_distancia()` replaces `near_rc()`.
    -   `catr_ovc_rccoor()` replaces `get_rc()`.
    -   `catr_ovc_cpmrc()` replaces `get_coor()`.

-   Add precomputed vignettes.

# CatastRo 0.1.0

-   Initial release.
