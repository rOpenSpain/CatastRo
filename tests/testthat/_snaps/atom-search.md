# municipality ATOM search handles mocked misses

    Code
      result <- catr_atom_search_munic("No match")
    Message
      ! No municipality matched pattern "No match".

---

    Code
      result <- catr_atom_search_munic("Melque", to = "No office", verbose = TRUE)
    Message
      ! Ignoring `to` because no territorial office matched "No office".

---

    Code
      result <- catr_atom_search_munic("Madrid", to = "Segovia")
    Message
      ! No municipality matched pattern "Madrid" in "Segovia".

# Test offline

    Code
      fend <- catr_atom_search_munic("LABAJOS", cache_dir = cdir)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Test 404 all

    Code
      fend <- catr_atom_search_munic("MELQUE", to = "Segovia", cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/ES.SDGC.AD.atom.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      > Returning "NULL" because the download failed.

# Test search

    Code
      c <- catr_atom_search_munic("XXX", cache_dir = cdir)
    Message
      ! No municipality matched pattern "XXX".

---

    Code
      d <- catr_atom_search_munic("Melque", to = "XXX", verbose = TRUE, cache_dir = cdir)
    Message
      ! Ignoring `to` because no territorial office matched "XXX".

---

    Code
      ff <- catr_atom_search_munic("Melilla", to = "Burgos", cache_dir = cdir)
    Message
      ! No municipality matched pattern "Melilla" in "Burgos".

# Deprecations

    Code
      a <- catr_atom_search_munic("Mad", cache_dir = cdir, cache = TRUE)
    Condition
      Warning:
      The `cache` argument of `catr_atom_search_munic()` is deprecated as of CatastRo 1.0.0.
      i Results are always cached.

