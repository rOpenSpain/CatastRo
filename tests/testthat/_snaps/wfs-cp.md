# catr_wfs_get_parcels_bbox() rejects invalid coordinates

    Code
      catr_wfs_get_parcels_bbox(x = "1234", what = "xxx")
    Condition
      Error in `catr_wfs_get_parcels_bbox()`:
      ! `what` must be one of "parcel" or "zoning", not "xxx".

---

    Code
      catr_wfs_get_parcels_bbox(x = "1234")
    Condition
      Error in `wfs_get_bbox()`:
      ! `x` must have length 4, not 1.

---

    Code
      catr_wfs_get_parcels_bbox(x = c("1234", "a", "3", "4"))
    Condition
      Error in `wfs_get_bbox()`:
      ! You must also provide `srs` when `x` is a character vector.

---

    Code
      catr_wfs_get_parcels_bbox(x = c(1, 2, 3))
    Condition
      Error in `wfs_get_bbox()`:
      ! `x` must have length 4, not 3.

---

    Code
      catr_wfs_get_parcels_bbox(x = c(1, 2, 3, 4))
    Condition
      Error in `wfs_get_bbox()`:
      ! You must also provide `srs` when `x` is a double vector.

