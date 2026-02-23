# Test offline

    Code
      fend <- catr_atom_get_buildings("LABAJOS", cache_dir = cdir)
    Message
      x Offline
      > Returning "NULL"

# Test 404 all

    Code
      fend <- catr_atom_get_buildings("MELQUE", to = "Segovia", cache_dir = cdir)
    Message
      x Error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/buildings/ES.SDGC.BU.atom.xml>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

# ATOM Buildings

    Code
      catr_atom_get_buildings("xyxghx", cache_dir = cdir)
    Message
      ! No municipality found with pattern "xyxghx".
      i Check available municipalities with `CatastRo::catr_atom_get_address_db_all()`.
    Output
      NULL

---

    Code
      s <- catr_atom_get_buildings("Melque", to = "Segovia", cache = FALSE,
        cache_dir = cdir)
    Condition
      Warning:
      The `cache` argument of `catr_atom_get_buildings()` is deprecated as of CatastRo 1.0.0.
      i Results are always cached.
      Warning:
      The `cache` argument of `catr_atom_get_buildings_db_to()` is deprecated as of CatastRo 1.0.0.
      i Results are always cached.

# Test 404 single

    Code
      fend <- catr_atom_get_buildings("Melque", to = "Segovia", cache_dir = cdir)
    Message
      x Error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/Buildings/40/40146-MELQUE%20DE%20CERCOS/A.ES.SDGC.BU.40146.zip>.
      ! If you think this is a bug please consider opening an issue on <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL"

