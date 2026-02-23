# Helper
ovcurl <- function(x) {
  # nocov start
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
  # nocov end
}
