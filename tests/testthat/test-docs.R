test_that("atom_db_details() documents both ATOM database functions", {
  details <- atom_db_details("address")

  expect_match(details, "[catr_atom_get_address_db_all()]", fixed = TRUE)
  expect_match(details, "[catr_atom_get_address_db_to()]", fixed = TRUE)
  expect_match(details, "Basque Country and Navarre", fixed = TRUE)
})

test_that("ovc_coordinate_details() documents optional INE fields", {
  without_ine <- ovc_coordinate_details()
  with_ine <- ovc_coordinate_details(include_ine = TRUE)

  expect_match(without_ine, "`geo.xcen`, `geo.ycen`, `geo.srs`", fixed = TRUE)
  expect_no_match(without_ine, "`cmun_ine`", fixed = TRUE)
  expect_match(with_ine, "`cmun_ine`", fixed = TRUE)
  expect_match(with_ine, "National Statistics Institute", fixed = TRUE)
})

test_that("ovcurl() maps service identifiers to stable URLs", {
  base <- "https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc"

  expect_identical(ovcurl("another"), base)
  expect_identical(
    ovcurl("CPMRC"),
    paste0(base, "/ovccoordenadas.asmx?op=Consulta_CPMRC")
  )
  expect_identical(
    ovcurl("mun"),
    paste0(
      base,
      "/ovccallejerocodigos.asmx?op=ConsultaMunicipioCodigos"
    )
  )
  expect_identical(
    ovcurl("prov"),
    paste0(base, "/ovccallejerocodigos.asmx?op=ConsultaProvincia")
  )
  expect_identical(
    ovcurl("RCCOORD"),
    paste0(base, "/ovccoordenadas.asmx?op=Consulta_RCCOOR_Distancia")
  )
  expect_identical(
    ovcurl("RCCOOR"),
    paste0(base, "/ovccoordenadas.asmx?op=Consulta_RCCOOR")
  )
})
