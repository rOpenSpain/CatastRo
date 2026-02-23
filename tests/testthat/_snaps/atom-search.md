# Test offline

    Code
      fend <- catr_atom_search_munic("LABAJOS", cache_dir = cdir)
    Message
      x Offline
      > Returning "NULL"

# Test 404 all

    Code
      fend <- catr_atom_search_munic("MELQUE", to = "Segovia", cache_dir = cdir)
    Message
      x Error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/ES.SDGC.AD.atom.xml>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

# Test search

    Code
      c <- catr_atom_search_munic("XXX", cache_dir = cdir)
    Message
      ! No municipality found with pattern "XXX" in .

---

    Code
      ff <- catr_atom_search_munic("Melilla", to = "Burgos", cache_dir = cdir)
    Message
      ! No municipality found with pattern "Melilla" in "Burgos".

# Deprecations

    Code
      a <- catr_atom_search_munic("Mad", cache_dir = cdir, cache = TRUE)
    Condition
      Warning:
      The `cache` argument of `catr_atom_search_munic()` is deprecated as of CatastRo 1.0.0.
      i Results are always cached.

