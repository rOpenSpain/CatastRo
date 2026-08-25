# building database listing returns NULL when offline

    Code
      fend <- catr_atom_get_buildings_db_all(cache_dir = cdir)
    Message
      x No internet connection detected.
      Returning "NULL" because the request cannot run.

# building database office lookup returns NULL when offline

    Code
      fend <- catr_atom_get_buildings_db_to("Madrid", cache_dir = cdir)
    Message
      x No internet connection detected.
      Returning "NULL" because the request cannot run.

# building database listing returns NULL after an HTTP 404

    Code
      fend <- catr_atom_get_buildings_db_all(cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/buildings/ES.SDGC.BU.atom.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      Returning "NULL" because the download failed.

# building database lookups match and rank territorial offices

    Code
      no_res <- catr_atom_get_buildings_db_to(to = "aaaana", cache_dir = cdir)
    Message
      ! No territorial office matched pattern "aaaana".

---

    Code
      several <- catr_atom_get_buildings_db_to(to = "lencia", cache_dir = cdir)
    Message
      i Found 2 territorial offices matching "lencia".
      v Using closest match "Territorial office 34 Palencia".
      i Other matches:
        "Territorial office 46 Valencia"

# deprecated building database cache arguments emit warnings

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

# building database office lookup handles a failed cached request

    Code
      fend <- catr_atom_get_buildings_db_to("Madrid", cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <http://www.catastro.hacienda.gob.es/INSPIRE/buildings/28/ES.SDGC.bu.atom_28.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      Returning "NULL" because the download failed.

