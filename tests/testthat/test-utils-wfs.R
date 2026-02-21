test_that("wfs_get_bbox", {
  expect_snapshot(error = TRUE, wfs_get_bbox(c(1, 2)))
  expect_snapshot(error = TRUE, wfs_get_bbox(c(1, 2, 3, 4)))
  expect_silent(ok <- wfs_get_bbox(c(1, 1, 1, 1), srs = 4326))
  expect_s3_class(ok, "bbox")

  expect_equal(sf::st_crs(ok)$epsg, 3857)

  expect_true(is.numeric(as.vector(ok)))
  expect_length(ok, 4)
  expect_identical(ok, wfs_get_bbox(sf::st_as_sfc(ok)))

  # Trigger limit
  buf <- c(0, 0, 10000, 10000)
  class(buf) <- "bbox"
  buf <- sf::st_as_sfc(buf)
  buf <- sf::st_set_crs(buf, 3857)
  expect_snapshot(wfs_get_bbox(buf, limit_km2 = 1))
})
test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- file.path(tempdir(), "wfs_inspire_cache")
  unlink(cdir, recursive = TRUE)
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
  expect_length(
    list.files(cdir, recursive = TRUE),
    0
  )
  unlink(cdir, recursive = TRUE, force = TRUE)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Test 404", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "wfs_inspire_cache")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

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
    "Error "
  )
  expect_null(s)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })

  # Otherwise work
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
  expect_true(is.character(s))
  expect_true(file.exists(s))
  expect_silent(tosf <- sf::read_sf(s))
  expect_s3_class(tosf, "sf")

  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
})

test_that("Error on call", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "wfs_inspire_cache")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

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
    "didn't provide results:"
  )
  expect_null(s)

  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
})

test_that("Bad query", {
  skip_on_cran()
  skip_if_offline()

  cdir <- file.path(tempdir(), "wfs_inspire_cache")
  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }

  expect_snapshot(
    error = TRUE,
    s <- inspire_wfs_get(
      path = "INSPIRE/wfsBU.aspx",
      query = 20
    )
  )

  expect_snapshot(
    error = TRUE,
    s <- inspire_wfs_get(
      path = "INSPIRE/wfsBU.aspx",
      query = list(20, NA, NULL)
    )
  )

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
    "Removing 3 empty and/or unnamed elements in"
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

  expect_identical(sfobj1, sfobj2)
  expect_s3_class(sfobj1, "sf")
  expect_equal(sf::st_crs(sfobj1)$epsg, 25829)

  if (dir.exists(cdir)) {
    unlink(cdir, recursive = TRUE, force = TRUE)
  }
})
