# catr_atom_select_munic() reports literal braces in matches

    Code
      out <- catr_atom_select_munic(all, munic = "Town", db_all_call = "catr_atom_get_address_db_all",
        verbose = TRUE)
    Message
      i Found 2 municipalities matching "Town".
      v Using the closest match "Town {one}".
      i Other matches:
        "Town {two}"
      i Retrieving information for "Town {one}".

# catr_atom_read_db_to() reports literal braces in office names

    Code
      out <- catr_atom_read_db_to("Office", all_fn, verbose = TRUE)
    Message
      i Found 2 territorial offices matching "Office".
      v Using the closest match "Office {one}".
      i Other matches:
        "Office {two}"
      i Retrieving information for "Office {one}".

