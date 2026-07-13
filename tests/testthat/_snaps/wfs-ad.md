# BBOX Check

    Code
      fend <- catr_wfs_get_address_bbox(c(-20, -20, -19, -20), srs = 4326)
    Message
      x The WFS query returned an exception for a mocked response:
      Area de la extensión fuera de los límites

# AD CODVIA

    Code
      obj <- catr_wfs_get_address_codvia("1", 110, 390)
    Message
      x The WFS query returned an exception for a mocked response:
      No records found for mocked address query

---

    Code
      obj <- catr_wfs_get_address_codvia("1", 110, 390, srs = 9999)
    Condition
      Error:
      ! `srs` must be one of "3785", "3857", "4258", "4326", "25829", "25830" or "25831", not "9999".

# AD RC

    Code
      obj <- catr_wfs_get_address_rc("3662303TF")
    Message
      x The WFS query returned an exception for a mocked response:
      Invalid length of REFCAT parameter

---

    Code
      obj <- catr_wfs_get_address_rc("3662303TF", srs = 9999)
    Condition
      Error:
      ! `srs` must be one of "3785", "3857", "4258", "4326", "25829", "25830" or "25831", not "9999".

# AD Postal Code

    Code
      obj <- catr_wfs_get_address_postalcode("XXXXX")
    Message
      x The WFS query returned an exception for a mocked response:
      No records found for mocked address query

---

    Code
      obj <- catr_wfs_get_address_rc("XXXXX", srs = 9999)
    Condition
      Error:
      ! `srs` must be one of "3785", "3857", "4258", "4326", "25829", "25830" or "25831", not "9999".

