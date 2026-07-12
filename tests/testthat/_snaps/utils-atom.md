# ATOM readers handle mocked failures and ambiguous matches

    Code
      result <- catr_atom_read_db_to("No match", all_fn = function(...) all)
    Message
      ! No territorial office matched pattern "No match".

---

    Code
      result <- catr_atom_select_munic(all = mock_atom_all(), munic = "40", to = "Segovia",
      db_all_call = "catr_atom_get_address_db_all", verbose = TRUE)
    Message
      i Found 2 municipalities matching "40".
      v Using closest match "40112-MELQUE DE CERCOS".
      i Other matches:
        "40138-NAVA DE LA ASUNCION"
      i Retrieving information for "40112-MELQUE DE CERCOS".

