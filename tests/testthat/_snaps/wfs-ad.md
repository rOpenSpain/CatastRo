# catr_wfs_get_address_codvia() retrieves addresses by street code

    Code
      obj <- catr_wfs_get_address_codvia("1", 110, 390, srs = 9999)
    Condition
      Error in `wfs_get_bbox()`:
      ! `srs` must be one of "3785", "3857", "4258", "4326", "25829", "25830" or "25831", not "9999".

# catr_wfs_get_address_rc() retrieves by cadastral reference

    Code
      obj <- catr_wfs_get_address_rc("3662303TF", srs = 9999)
    Condition
      Error in `wfs_get_bbox()`:
      ! `srs` must be one of "3785", "3857", "4258", "4326", "25829", "25830" or "25831", not "9999".

# catr_wfs_get_address_postalcode() retrieves by postal code

    Code
      obj <- catr_wfs_get_address_postalcode("XXXXX", srs = 9999)
    Condition
      Error in `wfs_get_bbox()`:
      ! `srs` must be one of "3785", "3857", "4258", "4326", "25829", "25830" or "25831", not "9999".

