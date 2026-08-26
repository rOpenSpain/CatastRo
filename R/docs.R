# Documentation helpers.
atom_db_details <- function(resource) {
  all <- paste0("catr_atom_get_", resource, "_db_all")
  territorial_office <- paste0("catr_atom_get_", resource, "_db_to")

  paste(
    paste0("[", all, "()] provides a summary table with all"),
    "territorial offices, except the Basque Country and Navarre and the",
    paste0(
      "municipalities included in each office. [",
      territorial_office,
      "()]"
    ),
    "provides a table for one territorial office and its municipalities.",
    sep = "\n"
  )
}

ovc_coordinate_details <- function(include_ine = FALSE) {
  columns <- c(
    "- `geo.xcen`, `geo.ycen`, `geo.srs`: Input arguments of the query.",
    "- `refcat`: Cadastral reference.",
    "- `address`: Address as recorded in the Spanish Cadastre."
  )

  if (include_ine) {
    columns <- c(
      columns,
      paste(
        "- `cmun_ine`: Municipality code as registered by the INE",
        "  (National Statistics Institute).",
        sep = "\n"
      )
    )
  }

  columns <- c(columns, "- Remaining fields: See the API documentation.")

  paste(
    "If the API returns no results, this function returns a",
    "[tibble][dplyr::tbl_df] containing only query information.",
    "",
    paste(
      "On a successful query, this function returns a",
      "[tibble][dplyr::tbl_df] with",
      sep = "\n"
    ),
    "one row per cadastral reference, including the following columns:",
    paste(columns, collapse = "\n"),
    sep = "\n"
  )
}

ovcurl <- function(x) {
  base <- "https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc"

  app <- switch(x,
    "CPMRC" = "ovccoordenadas.asmx?op=Consulta_CPMRC",
    "mun" = "ovccallejerocodigos.asmx?op=ConsultaMunicipioCodigos",
    "prov" = "ovccallejerocodigos.asmx?op=ConsultaProvincia",
    "RCCOORD" = "ovccoordenadas.asmx?op=Consulta_RCCOOR_Distancia",
    "RCCOOR" = "ovccoordenadas.asmx?op=Consulta_RCCOOR",
    NULL
  )

  paste0(c(base, app), collapse = "/")
}
