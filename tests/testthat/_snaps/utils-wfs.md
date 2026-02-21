# wfs_get_bbox

    Code
      wfs_get_bbox(c(1, 2))
    Condition
      Error in `wfs_get_bbox()`:
      ! Length of `x` should be 4, not 2.

---

    Code
      wfs_get_bbox(c(1, 2, 3, 4))
    Condition
      Error in `wfs_get_bbox()`:
      ! You should provide also the `srs` argument when x is a double vector.

---

    Code
      wfs_get_bbox(buf, limit_km2 = 1)
    Message
      ! API Endpoint Restriction: 1 km2. Your query is 100 km2.
      i Operation may fail, check the results or reduce the area of `x`.
    Output
       xmin  ymin  xmax  ymax 
          0     0 10000 10000 

