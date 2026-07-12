# Test offline

    Code
      fend <- download_url(url, cache_dir = cdir, subdir = "fixme", update_cache = FALSE,
        verbose = FALSE)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# download_url handles HEAD transport failures

    Code
      fend <- download_url(url, cache_dir = cdir, verbose = FALSE)
    Message
      x The download request could not be completed.
      ! Connection reset by peer
      > Returning "NULL" because the download failed.

# download_url handles download transport failures

    Code
      fend <- download_url(url, cache_dir = cdir, verbose = FALSE)
    Message
      x The download request could not be completed.
      ! Connection reset by peer
      > Returning "NULL" because the download failed.

# No connection body

    Code
      fend <- get_request_body(url, verbose = FALSE)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Error body

    Code
      fend <- get_request_body(url, verbose = FALSE)
    Message
      x HTTP error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/ES.SDGC.AD.atom.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      > Returning "NULL" because the request failed.

# get_request_body handles transport failures

    Code
      fend <- get_request_body("https://example.test/body.xml", verbose = FALSE)
    Message
      x The request could not be completed.
      ! Connection reset by peer
      > Returning "NULL" because the request failed.

