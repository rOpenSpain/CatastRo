mock_atom_all <- function(...) {
  data.frame(
    territorial_office = c("Segovia", "Segovia", "Madrid"),
    url = c(
      "https://example.test/segovia.xml",
      "https://example.test/segovia.xml",
      "https://example.test/madrid.xml"
    ),
    munic = c(
      "40112-MELQUE DE CERCOS",
      "40138-NAVA DE LA ASUNCION",
      "28079-MADRID"
    ),
    date = as.POSIXct("2024-01-01", tz = "UTC")
  )
}

mock_atom_to <- function(...) {
  data.frame(
    munic = c("40112-MELQUE DE CERCOS", "40138-NAVA DE LA ASUNCION"),
    url = c("https://example.test/melque.zip", "https://example.test/nava.zip"),
    date = as.POSIXct("2024-01-01", tz = "UTC")
  )
}

mock_atom_download <- function(...) {
  "mock-atom.zip"
}

mock_atom_download_null <- function(...) {
  NULL
}

mock_atom_read_geo <- function(file, hint, layer_hint = NULL, ...) {
  if (identical(layer_hint, "Thorough")) {
    return(data.frame(
      gml_id = "ES.SDGC.TN.40112.a.b",
      text = "Main street"
    ))
  }

  if (identical(layer_hint, "Address")) {
    return(data.frame(
      gml_id = "ES.SDGC.AD.40112.a.b",
      file = file,
      hint = hint
    ))
  }

  data.frame(
    file = file,
    hint = hint
  )
}
