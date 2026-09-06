# read_geo_file_sf() warns before reading large files

    Code
      out <- read_geo_file_sf(fake_local)
    Message
      ! Reading a large file (21 Mb).
      > This may take a while.

# sf_bbox_to_sf() converts bounding boxes to spatial features

    Code
      get_sf_from_bbox(c(1, 2))
    Condition
      Error:
      ! `bbox` must be a numeric vector of length 4.

---

    Code
      get_sf_from_bbox(rep("x", 4), srs = 4326)
    Condition
      Error:
      ! `bbox` must be a numeric vector of length 4.

---

    Code
      get_sf_from_bbox(c(1, 2, 1, 2))
    Condition
      Error:
      ! Provide a valid non-empty value for `srs`.

