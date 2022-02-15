# CatastRo (development version)

-   Add ATOM INSPIRE capabilities:

    -   `catr_atom_ad()`, `catr_atom_ad_db_all()`, `catr_atom_cp()`,
        `catr_atom_cp_db_all()`, `catr_atom_bu()`, `catr_atom_bu_db_all()`.

-   Add WFS INSPIRE capabilities:

    -   `catr_wfs_bu_bbox()`,`catr_wfs_bu_rc()`.

-   New interface for OVC Services. Deprecate previous functions in favor of the
    new API:

    -   New SRS database on `catr_srs_values`, replaces `coordinates`.

    -   `catr_ovc_rccoor_distancia()` replaces `near_rc()`.

    -   `catr_ovc_rccoor()` replaces `get_rc()`.

    -   `catr_ovc_cpmrc()` replaces `get_coor()`.

-   Add precomputed vignettes.

# CatastRo 0.1.0

-   Initial release.
