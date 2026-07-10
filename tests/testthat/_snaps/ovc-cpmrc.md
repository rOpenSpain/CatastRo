# Test offline

    Code
      fend <- catr_ovc_get_cpmrc("9872023VH5797S")
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Test 404 all

    Code
      fend <- catr_ovc_get_cpmrc("9872023VH5797S")
    Message
      x HTTP error 404 (Not Found): <http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC?RC=9872023VH5797S&SRS=EPSG%3A4326&Provincia=&Municipio=>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRo/issues>.
      > Returning "NULL" because the request failed.

# Expect error on bad SRS

    Code
      df <- catr_ovc_get_cpmrc(rc = "s", srs = "abcd")
    Condition
      Error:
      ! `srs` must be one of "4230", "4258", "4326", "23029", "23030", "23031", "25829", "25830", "25831", "32627", "32628", "32629", "32630" or "32631", not "abcd".

# giving only the cadastral reference

    Code
      df <- catr_ovc_get_cpmrc("9872023VH5797S", verbose = TRUE)
    Message
      i Requesting <http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx/Consulta_CPMRC?RC=9872023VH5797S&SRS=EPSG%3A4326&Provincia=&Municipio=>.
      v Request succeeded.

# given Municipio, Provincia is needed

    Code
      nnn <- catr_ovc_get_cpmrc(rc = "13077A01800039", srs = "4230", municipality = "SANTA CRUZ DE MUDELA")
    Message
      x OVC service error "11": LA PROVINCIA ES OBLIGATORIA

