# AD CODVIA

    Code
      obj <- catr_wfs_get_address_codvia("1", 110, 390)
    Message
      x Error 404 (Not Found): <https://ovc.catastro.meh.es/INSPIRE/wfsAD.aspx?service=wfs&version=2.0.0&request=getfeature&storedquerie_id=getadbycodvia&codvia=1&del=110&mun=390>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

---

    Code
      obj <- catr_wfs_get_address_codvia("1", 110, 390, srs = 9999)
    Condition
      Error:
      ! `srs` should be one of "3785", "3857", "4258", "4326", "25829", "25830" or "25831", not "9999".

# AD RC

    Code
      obj <- catr_wfs_get_address_rc("3662303TF")
    Message
      x The query <https://ovc.catastro.meh.es/INSPIRE/wfsAD.aspx?service=wfs&version=2.0.0&request=getfeature&storedquerie_id=GetadByRefcat&refcat=3662303TF> didn't provide results:
      Invalid length of REFCAT parameter

---

    Code
      obj <- catr_wfs_get_address_rc("3662303TF", srs = 9999)
    Condition
      Error:
      ! `srs` should be one of "3785", "3857", "4258", "4326", "25829", "25830" or "25831", not "9999".

# AD Postal Code

    Code
      obj <- catr_wfs_get_address_postalcode("XXXXX")
    Message
      x Error 404 (Not Found): <https://ovc.catastro.meh.es/INSPIRE/wfsAD.aspx?service=wfs&version=2.0.0&request=getfeature&storedquerie_id=getadbypostalcode&postalcode=XXXXX>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

---

    Code
      obj <- catr_wfs_get_address_rc("XXXXX", srs = 9999)
    Condition
      Error:
      ! `srs` should be one of "3785", "3857", "4258", "4326", "25829", "25830" or "25831", not "9999".

