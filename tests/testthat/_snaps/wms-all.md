# catr_wms_get_layer() rejects invalid layer types

    Code
      catr_wms_get_layer(c(760926, 4019259, 761155, 4019366), srs = 25829, what = "aa")
    Condition
      Error in `catr_wms_get_layer()`:
      ! `what` must be one of "building", "buildingpart", "parcel", "zoning", "address", "admboundary" or "admunit", not "aa".

