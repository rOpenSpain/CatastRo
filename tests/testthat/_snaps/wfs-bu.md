# BBOX Check

    Code
      fend <- catr_wfs_get_buildings_bbox(c(-20, -20, -19, -20), srs = 4326)
    Message
      x The WFS query returned an exception for a mocked response:
      Area of extension out of limits

# Check error on bad rc

    Code
      f <- catr_wfs_get_buildings_rc(rc = "1234")
    Message
      x The WFS query returned an exception for a mocked response:
      Invalid length of REFCAT parameter

