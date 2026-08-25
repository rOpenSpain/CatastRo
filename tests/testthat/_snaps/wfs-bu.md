# building WFS bounding boxes validate their coordinates

    Code
      fend <- catr_wfs_get_buildings_bbox(c(-20, -20, -19, -20), srs = 4326)
    Message
      x The WFS query returned an exception for a mocked response:
      Area of extension out of limits

# building WFS queries reject invalid cadastral references

    Code
      f <- catr_wfs_get_buildings_rc(rc = "1234")
    Message
      x The WFS query returned an exception for a mocked response:
      Invalid length of REFCAT parameter

