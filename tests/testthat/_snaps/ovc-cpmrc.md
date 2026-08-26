# catr_ovc_get_cpmrc() returns NULL when offline

    Code
      fend <- catr_ovc_get_cpmrc("9872023VH5797S")
    Message
      x No internet connection detected.
      Returning "NULL" because the request cannot run.

# catr_ovc_get_cpmrc() returns NULL after an HTTP 404

    Code
      fend <- catr_ovc_get_cpmrc("9872023VH5797S")
    Message
      x HTTP error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC?RC=9872023VH5797S&SRS=EPSG%3A4326&Provincia=&Municipio=>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      Returning "NULL" because the request failed.

# catr_ovc_get_cpmrc() rejects an unsupported SRS

    Code
      df <- catr_ovc_get_cpmrc(rc = "s", srs = "abcd")
    Condition
      Error in `ovc_validate_srs()`:
      ! `srs` must be one of "4230", "4258", "4326", "23029", "23030", "23031", "25829", "25830", "25831", "32627", "32628", "32629", "32630" or "32631", not "abcd".

# catr_ovc_get_cpmrc() accepts only a reference

    Code
      df <- catr_ovc_get_cpmrc("9872023VH5797S", verbose = TRUE)
    Message
      i Requesting <http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC?RC=9872023VH5797S&SRS=EPSG%3A4326&Provincia=&Municipio=>.
      v Request succeeded.

# catr_ovc_get_cpmrc() requires a province and municipality

    Code
      nnn <- catr_ovc_get_cpmrc(rc = "13077A01800039", srs = "4230", municipality = "SANTA CRUZ DE MUDELA")
    Message
      x OVC service error 11: LA PROVINCIA ES OBLIGATORIA

