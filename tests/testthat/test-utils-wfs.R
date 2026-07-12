test_that("wfs_get_bbox", {
  expect_snapshot(error = TRUE, wfs_get_bbox(c(1, 2)))
  expect_snapshot(error = TRUE, wfs_get_bbox(c(1, 2, 3, 4)))
  expect_silent(ok <- wfs_get_bbox(c(1, 1, 1, 1), srs = 4326))
  expect_s3_class(ok, "bbox")

  expect_equal(sf::st_crs(ok)$epsg, 3857)

  expect_type(as.vector(ok), "double")
  expect_length(ok, 4)
  expect_identical(ok, wfs_get_bbox(sf::st_as_sfc(ok)))

  # Trigger limit
  buf <- c(0, 0, 10000, 10000)
  class(buf) <- "bbox"
  buf <- sf::st_as_sfc(buf)
  buf <- sf::st_set_crs(buf, 3857)
  expect_snapshot(wfs_get_bbox(buf, limit_km2 = 1))

  # Check transformation to another srs
  geobox <- c(1, 1, 2, 1)
  another <- wfs_get_bbox(geobox, srs = 4326, srs_dest = 25830)
  merc <- wfs_get_bbox(geobox, srs = 4326, srs_dest = 3857)

  expect_false(any(another == merc))
})
test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "wfs_inspire_cache")
  expect_snapshot(
    fend <- inspire_wfs_get(
      path = "INSPIRE/wfsBU.aspx",
      query = list(
        request = "getfeature",
        Typenames = "BU.BUILDING",
        SRSname = 25829,
        bbox = "742438,4046840,742613,4046970"
      )
    )
  )
  expect_null(fend)
  expect_length(list.files(cdir, recursive = TRUE), 0)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Test 404", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "wfs_inspire_cache")

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  expect_message(
    s <- inspire_wfs_get(
      path = "INSPIRE/wfsBU.aspx",
      query = list(
        request = "getfeature",
        Typenames = "BU.BUILDING",
        SRSname = 25829,
        bbox = "742438,4046840,742613,4046970"
      )
    ),
    "HTTP error"
  )
  expect_null(s)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })

  local_mocked_bindings(download_url = function(
    url,
    name,
    cache_dir,
    subdir,
    ...
  ) {
    out <- file.path(cache_dir, subdir, name)
    dir.create(dirname(out), recursive = TRUE, showWarnings = FALSE)
    sfobj <- sf::st_sf(
      id = 1,
      geometry = sf::st_sfc(sf::st_point(c(742438, 4046840)), crs = 25829)
    )
    sf::st_write(sfobj, out, quiet = TRUE)
    out
  })

  expect_silent(
    s <- inspire_wfs_get(
      path = "INSPIRE/wfsBU.aspx",
      query = list(
        request = "getfeature",
        Typenames = "BU.BUILDING",
        SRSname = 25829,
        bbox = "742438,4046840,742613,4046970"
      )
    )
  )
  expect_length(s, 1)
  expect_type(s, "character")
  expect_true(file.exists(s))
  expect_silent(tosf <- sf::read_sf(s))
  expect_s3_class(tosf, "sf")
})

test_that("Error on call", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "wfs_inspire_cache")

  local_mocked_bindings(download_url = function(
    url,
    name,
    cache_dir,
    subdir,
    ...
  ) {
    out <- file.path(cache_dir, subdir, name)
    dir.create(dirname(out), recursive = TRUE, showWarnings = FALSE)
    writeLines(
      c(
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
        "<ExceptionReport>",
        "  <Exception>",
        "    <ExceptionText>Bad WFS query.</ExceptionText>",
        "  </Exception>",
        "</ExceptionReport>"
      ),
      out
    )
    out
  })

  expect_message(
    s <- inspire_wfs_get(
      path = "INSPIRE/wfsBU.aspx",
      query = list(
        request = "getfeatureaa",
        Typenames = "BU.BUILDING",
        SRSname = 25829,
        bbox = "742438,4046840,742613,4046970"
      )
    ),
    "WFS query returned an exception"
  )
  expect_null(s)
})

test_that("Bad query", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "wfs_inspire_cache")

  expect_snapshot(
    error = TRUE,
    s <- inspire_wfs_get(path = "INSPIRE/wfsBU.aspx", query = 20)
  )

  expect_snapshot(
    error = TRUE,
    s <- inspire_wfs_get(
      path = "INSPIRE/wfsBU.aspx",
      query = list(20, NA, NULL)
    )
  )

  local_mocked_bindings(download_url = function(
    url,
    name,
    cache_dir,
    subdir,
    ...
  ) {
    out <- file.path(cache_dir, subdir, name)
    dir.create(dirname(out), recursive = TRUE, showWarnings = FALSE)
    sfobj <- sf::st_sf(
      id = 1,
      geometry = sf::st_sfc(sf::st_point(c(742438, 4046840)), crs = 25829)
    )
    sf::st_write(sfobj, out, quiet = TRUE)
    out
  })

  expect_message(
    s <- inspire_wfs_get(
      path = "INSPIRE/wfsBU.aspx",
      query = list(
        request = "getfeature",
        STOREDQUERIE_ID = "GETOTHERBUILDINGBYPARCEL",
        NULL,
        refcat = "9398516VK3799G",
        NA,
        "another one bite the dust",
        srsname = "EPSG::25829"
      ),
      verbose = TRUE
    ),
    "Removed 3 empty or unnamed elements"
  )

  sfobj1 <- read_geo_file_sf(s)

  unlink(s)

  # What about my EPSG?
  sfobj2 <- inspire_wfs_get(
    path = "INSPIRE/wfsBU.aspx",
    query = list(
      request = "getfeature",
      STOREDQUERIE_ID = "GETOTHERBUILDINGBYPARCEL",
      refcat = "9398516VK3799G",
      srsname = 25829
    )
  ) |>
    read_geo_file_sf()

  sfobj1$gml_id <- NULL
  sfobj2$gml_id <- NULL
  expect_identical(sfobj1, sfobj2)
  expect_s3_class(sfobj1, "sf")
  expect_equal(sf::st_crs(sfobj1)$epsg, 25829)
})
