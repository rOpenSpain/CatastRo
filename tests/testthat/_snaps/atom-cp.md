# Test offline

    Code
      fend <- catr_atom_get_parcels("LABAJOS", cache_dir = cdir)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Test 404 all

    Code
      fend <- catr_atom_get_parcels("MELQUE", to = "Segovia", cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/CadastralParcels/ES.SDGC.CP.atom.xml>.
      ! If this looks like a package bug, please open an issue at <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL" because the download failed.

# ATOM parcels

    Code
      catr_atom_get_parcels("xyxghx", cache_dir = cdir)
    Message
      ! No municipality matched pattern "xyxghx".
      i Check available municipalities with `CatastRo::catr_atom_get_parcels_db_all()`.
    Output
      NULL

---

    Code
      s <- catr_atom_get_parcels("Melque", to = "Segovia", cache = FALSE, cache_dir = cdir)
    Condition
      Warning:
      The `cache` argument of `catr_atom_get_parcels()` is deprecated as of CatastRo 1.0.0.
      i Results are always cached.

# Test 404 single

    Code
      fend <- catr_atom_get_parcels("Melque", to = "Segovia", cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <https://www.catastro.hacienda.gob.es/INSPIRE/CadastralParcels/40/40146-MELQUE%20DE%20CERCOS/A.ES.SDGC.CP.40146.zip>.
      ! If this looks like a package bug, please open an issue at <https://github.com/ropenspain/CatastRo/issues>
      > Returning "NULL" because the download failed.

