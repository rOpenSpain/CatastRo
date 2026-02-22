# Test offline db_all

    Code
      fend <- catr_atom_get_buildings_db_all(cache_dir = cdir)
    Message
      x Offline
      > Returning "NULL"

# Test offline db_to

    Code
      fend <- catr_atom_get_buildings_db_to("Madrid", cache_dir = cdir)
    Message
      x Offline
      > Returning "NULL"

# Test 404 all

    Code
      fend <- catr_atom_get_buildings_db_all(cache_dir = cdir)
    Message
      x Error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/buildings/ES.SDGC.BU.atom.xml>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

# Test atom bu

    Code
      no_res <- catr_atom_get_buildings_db_to(to = "aaaana", cache_dir = tempdir())
    Message
      ! No Territorial Office found with pattern "aaaana".

---

    Code
      several <- catr_atom_get_buildings_db_to(to = "lencia", cache_dir = tempdir())
    Message
      i Found 2 Territorial offices with pattern "lencia".
      v Selecting "Territorial office 34 Palencia".
      x Discarding:
        "Territorial office 46 Valencia"

# Deprecations

    Code
      fend <- catr_atom_get_buildings_db_to(to = "Madrid", cache = FALSE, cache_dir = cdir)
    Condition
      Warning:
      The `cache` argument of `catr_atom_get_buildings_db_to()` is deprecated as of CatastRo 1.0.0.
      i Results are always cached.

---

    Code
      fend <- catr_atom_get_buildings_db_all(cache_dir = cdir, cache = FALSE)
    Condition
      Warning:
      The `cache` argument of `catr_atom_get_buildings_db_all()` is deprecated as of CatastRo 1.0.0.
      i Results are always cached.

# Test 404 to bis

    Code
      fend <- catr_atom_get_buildings_db_to("Madrid", cache_dir = cdir)
    Message
      x Error 404 (Not Found): <http://www.catastro.hacienda.gob.es/INSPIRE/buildings/28/ES.SDGC.bu.atom_28.xml>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

