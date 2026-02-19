# Set Global Options for Mac

if ("mac" %in% tolower(Sys.info()[["sysname"]])) {
  # CatastRo < 1.0.0
  options(download.file.method = "curl", download.file.extra = "-k -L")

  # CatastRo >= 1.0.0
  options("catastro_ssl_verify" = FALSE)
}
