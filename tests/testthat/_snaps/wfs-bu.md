# BBOX Check

    Code
      fend <- catr_wfs_get_buildings_bbox(c(-20, -20, -19, -20), srs = 4326)
    Message
      x The WFS query returned an exception for <https://ovc.catastro.meh.es/INSPIRE/wfsBU.aspx?service=wfs&version=2.0.0&request=getfeature&typenames=BU.BUILDING&bbox=-1298652.47788616,-2304672.72126797,-1190638.18200508,-2293724.13416048&srsname=EPSG:25830>:
      Area of extension out of limits

# Check error on bad rc

    Code
      f <- catr_wfs_get_buildings_rc(rc = "1234")
    Message
      x The WFS query returned an exception for <https://ovc.catastro.meh.es/INSPIRE/wfsBU.aspx?service=wfs&version=2.0.0&request=getfeature&storedquerie_id=GetBuildingByParcel&refcat=1234>:
      Invalid length of REFCAT parameter

