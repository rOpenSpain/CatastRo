# Test offline db_all

    Code
      fend <- catr_atom_get_address_db_all(cache_dir = cdir)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Test offline db_to

    Code
      fend <- catr_atom_get_address_db_to("Madrid", cache_dir = cdir)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Test 404 all

    Code
      fend <- catr_atom_get_address_db_all(cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/Addresses/ES.SDGC.AD.atom.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      > Returning "NULL" because the download failed.

# Test atom ad

    Code
      no_res <- catr_atom_get_address_db_to(to = "aaaana", cache_dir = cdir)
    Message
      ! No territorial office matched pattern "aaaana".

---

    Code
      several <- catr_atom_get_address_db_to(to = "lencia", cache_dir = cdir)
    Message
      i Found 2 territorial offices matching "lencia".
      v Using closest match "Territorial office 34 Palencia".
      i Other matches:
        "Territorial office 46 Valencia"

# Deprecations

    Code
      fend <- catr_atom_get_address_db_to(to = "Madrid", cache = FALSE, cache_dir = cdir)
    Condition
      Warning:
      The `cache` argument of `catr_atom_get_address_db_to()` is deprecated as of CatastRo 1.0.0.
      i Results are always cached.

---

    Code
      fend <- catr_atom_get_address_db_all(cache_dir = cdir, cache = FALSE)
    Condition
      Warning:
      The `cache` argument of `catr_atom_get_address_db_all()` is deprecated as of CatastRo 1.0.0.
      i Results are always cached.

# Test 404 to bis

    Code
      fend <- catr_atom_get_address_db_to("Madrid", cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <http://www.catastro.hacienda.gob.es/INSPIRE/addresses/28/ES.SDGC.ad.atom_28.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      > Returning "NULL" because the download failed.

