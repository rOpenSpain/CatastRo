# wfs_get_bbox

    Code
      wfs_get_bbox(c(1, 2))
    Condition
      Error in `validate_vector_with_srs()`:
      ! `x` must have length 4, not 2.

---

    Code
      wfs_get_bbox(c(1, 2, 3, 4))
    Condition
      Error in `validate_vector_with_srs()`:
      ! You must also provide `srs` when `x` is a double vector.

---

    Code
      wfs_get_bbox(buf, limit_km2 = 1)
    Message
      ! WFS service limit is 1 km2. Your query covers 100 km2.
      i The request may fail. Check the results or use a smaller area in `x`.
    Output
       xmin  ymin  xmax  ymax 
          0     0 10000 10000 

# inspire_wfs_get validates and normalizes mocked queries

    Code
      result <- inspire_wfs_get(path = "INSPIRE/wfsBU.aspx", query = list(request = "getfeature",
        Typenames = "BU.BUILDING", SRSname = 25829, bbox = "", empty = NULL, NA))
    Message
      ! Removed 3 empty or unnamed elements from `query`.

# inspire_wfs_get handles mocked WFS exceptions

    Code
      result <- inspire_wfs_get(path = "INSPIRE/wfsBU.aspx", query = list(request = "getfeature"))
    Message
      x The WFS query returned an exception for <https://ovc.catastro.meh.es/INSPIRE/wfsBU.aspx?request=getfeature>:
      Mocked WFS error

# Test offline

    Code
      fend <- inspire_wfs_get(path = "INSPIRE/wfsBU.aspx", query = list(request = "getfeature",
        Typenames = "BU.BUILDING", SRSname = 25829, bbox = "742438,4046840,742613,4046970"))
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Bad query

    Code
      s <- inspire_wfs_get(path = "INSPIRE/wfsBU.aspx", query = 20)
    Condition
      Error in `inspire_wfs_get()`:
      ! `query` must be a list, not a number.

---

    Code
      s <- inspire_wfs_get(path = "INSPIRE/wfsBU.aspx", query = list(20, NA, NULL))
    Message
      ! Removed 3 empty or unnamed elements from `query`.
    Condition
      Error in `inspire_wfs_get()`:
      ! `query` must contain at least one named value.

