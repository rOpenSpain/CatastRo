# AD CODVIA

    Code
      obj <- catr_wfs_get_address_codvia("1", 110, 390)
    Message
      x HTTP error 404 (Not Found): <https://ovc.catastro.meh.es/INSPIRE/wfsAD.aspx?service=wfs&version=2.0.0&request=getfeature&storedquerie_id=getadbycodvia&codvia=1&del=110&mun=390>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      > Returning "NULL" because the download failed.

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
      x The WFS query returned an exception for <https://ovc.catastro.meh.es/INSPIRE/wfsAD.aspx?service=wfs&version=2.0.0&request=getfeature&storedquerie_id=GetadByRefcat&refcat=3662303TF>:
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
      x HTTP error 404 (Not Found): <https://ovc.catastro.meh.es/INSPIRE/wfsAD.aspx?service=wfs&version=2.0.0&request=getfeature&storedquerie_id=getadbypostalcode&postalcode=XXXXX>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      > Returning "NULL" because the download failed.

---

    Code
      obj <- catr_wfs_get_address_rc("XXXXX", srs = 9999)
    Condition
      Error:
      ! `srs` must be one of "3785", "3857", "4258", "4326", "25829", "25830" or "25831", not "9999".

