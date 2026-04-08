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
      ! You should also provide the `srs` argument when x is a double vector.

---

    Code
      wfs_get_bbox(buf, limit_km2 = 1)
    Message
      ! API Endpoint Restriction: 1 km2. Your query is 100 km2.
      i Operation may fail, check the results or use a smaller area on `x`.
    Output
       xmin  ymin  xmax  ymax 
          0     0 10000 10000 

# Test offline

    Code
      fend <- inspire_wfs_get(path = "INSPIRE/wfsBU.aspx", query = list(request = "getfeature",
        Typenames = "BU.BUILDING", SRSname = 25829, bbox = "742438,4046840,742613,4046970"))
    Message
      x Offline
      > Returning "NULL"

# Bad query

    Code
      s <- inspire_wfs_get(path = "INSPIRE/wfsBU.aspx", query = 20)
    Condition
      Error in `inspire_wfs_get()`:
      ! `query` should be a list, not a number.

---

    Code
      s <- inspire_wfs_get(path = "INSPIRE/wfsBU.aspx", query = list(20, NA, NULL))
    Message
      ! Removing 3 empty and/or unnamed elements in `query`.
    Condition
      Error in `inspire_wfs_get()`:
      ! `query` can't be an empty list.

