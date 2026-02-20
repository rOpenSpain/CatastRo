# ATOM Addresses

    Code
      catr_atom_get_address("xyxghx", cache_dir = cdir)
    Message
      ! No municipality found with pattern "xyxghx".
      i Check available municipalities with `CatastRo::catr_atom_get_address_db_all()`.
    Output
      NULL

---

    Code
      s <- catr_atom_get_address("Melque", to = "Segovia", cache = FALSE, cache_dir = cdir)
    Condition
      Warning:
      The `cache` argument of `catr_atom_get_address()` is deprecated as of CatastRo 1.0.0.
      i Results are always cached.
      Warning:
      The `cache` argument of `catr_atom_get_address_db_to()` is deprecated as of CatastRo 1.0.0.
      i Results are always cached.

