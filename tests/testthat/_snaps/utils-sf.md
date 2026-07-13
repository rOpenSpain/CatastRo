# read_geo_file_sf warns for large local files

    Code
      out <- read_geo_file_sf(fake_local)
    Message
      ! Reading a large file (21 Mb).
      > This may take a while.

# get_sf_from_bbox

    Code
      get_sf_from_bbox(c(1, 2))
    Condition
      Error in `get_sf_from_bbox()`:
      ! `bbox` must have length 4, not 2.

---

    Code
      get_sf_from_bbox(c(1, 2, 1, 2))
    Condition
      Error in `get_sf_from_bbox()`:
      ! Provide a valid non-empty value for `srs`.

