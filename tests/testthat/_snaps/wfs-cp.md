# BBOX Check errors

    Code
      catr_wfs_get_parcels_bbox(x = "1234", what = "xxx")
    Condition
      Error:
      ! `what` must be one of "parcel" or "zoning", not "xxx".

---

    Code
      catr_wfs_get_parcels_bbox(x = "1234")
    Condition
      Error in `validate_vector_with_srs()`:
      ! `x` must have length 4, not 1.

---

    Code
      catr_wfs_get_parcels_bbox(x = c("1234", "a", "3", "4"))
    Condition
      Error in `validate_vector_with_srs()`:
      ! You must also provide `srs` when `x` is a character vector.

---

    Code
      catr_wfs_get_parcels_bbox(x = c(1, 2, 3))
    Condition
      Error in `validate_vector_with_srs()`:
      ! `x` must have length 4, not 3.

---

    Code
      catr_wfs_get_parcels_bbox(x = c(1, 2, 3, 4))
    Condition
      Error in `validate_vector_with_srs()`:
      ! You must also provide `srs` when `x` is a double vector.

---

    Code
      s <- catr_wfs_get_parcels_bbox(x = c(1, 2, 3, 4), srs = 3857)
    Message
      x The WFS query returned an exception for <https://ovc.catastro.meh.es/INSPIRE/wfsCP.aspx?service=wfs&version=2.0.0&request=getfeature&typenames=CP.CADASTRALPARCEL&bbox=833979.557900465,1.98856024422251,833981.55986267,3.97712055424521&srsname=EPSG:25830>:
      No records founded for BBOX and SRS provided

# CP Zone

    Code
      obj <- catr_wfs_get_parcels_zoning("41624TF3146SZZ", srs = 3857)
    Message
      x The WFS query returned an exception for <https://ovc.catastro.meh.es/INSPIRE/wfsCP.aspx?service=wfs&version=2.0.0&request=getfeature&storedquerie_id=GetZoning&cod_zona=41624TF3146SZZ&srsname=EPSG:3857>:
      Invalid length of COD_ZONA parameter

---

    Code
      obj <- catr_wfs_get_parcels_parcel_zoning("41624TF3146SZZ", srs = 3857)
    Message
      x The WFS query returned an exception for <https://ovc.catastro.meh.es/INSPIRE/wfsCP.aspx?service=wfs&version=2.0.0&request=getfeature&storedquerie_id=GetParcelsByZoning&cod_zona=41624TF3146SZZ&srsname=EPSG:3857>:
      Invalid length of COD_ZONA parameter

