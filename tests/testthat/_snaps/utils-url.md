# Test offline

    Code
      fend <- download_url(url, cache_dir = cdir, subdir = "fixme", update_cache = FALSE,
        verbose = FALSE)
    Message
      x Offline
      > Returning "NULL"

# No connection body

    Code
      fend <- get_request_body(url, verbose = FALSE)
    Message
      x Offline
      > Returning "NULL"

# Error body

    Code
      fend <- get_request_body(url, verbose = FALSE)
    Message
      x Error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/ES.SDGC.AD.atom.xml>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

