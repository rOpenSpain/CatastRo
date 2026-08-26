# download_url() returns NULL when offline

    Code
      fend <- download_url(url, cache_dir = cdir, subdir = "fixme", update_cache = FALSE,
        verbose = FALSE)
    Message
      x No internet connection detected.
      Returning "NULL" because the request cannot run.

# download_url() removes partial files after HTTP errors

    Code
      fend <- download_url(url, cache_dir = cdir, verbose = FALSE)
    Message
      x HTTP error 404 (Not Found): <https://example.com/http-error.txt>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      Returning "NULL" because the download failed.

# download_url() removes partial files after transport failures

    Code
      fend <- download_url(url, cache_dir = cdir, verbose = FALSE)
    Message
      x The download request could not be completed.
      ! Mock transport failure.
      Returning "NULL" because the download failed.

---

    Code
      fend <- download_url(url, cache_dir = cdir, verbose = FALSE)
    Message
      x The download request could not be completed.
      ! Mock transport failure.
      Returning "NULL" because the download failed.

# get_request_body() returns NULL when offline

    Code
      fend <- get_request_body(url, verbose = FALSE)
    Message
      x No internet connection detected.
      Returning "NULL" because the request cannot run.

# get_request_body() returns NULL after a simulated HTTP 404

    Code
      fend <- get_request_body(url, verbose = FALSE)
    Message
      x HTTP error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/ES.SDGC.AD.atom.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      Returning "NULL" because the request failed.

# get_request_body() returns NULL after transport failures

    Code
      fend <- get_request_body(url, verbose = FALSE)
    Message
      x The request could not be completed.
      ! Mock transport failure.
      Returning "NULL" because the request failed.

