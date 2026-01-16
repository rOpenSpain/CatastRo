st_read_layers_encoding <- function(path, verbose, layer = NULL) {
  newlines <- readLines(path, encoding = "ISO-8859-1")

  # Thanks @santiagomota #19
  newlines <- stringi::stri_trans_general(newlines, "latin-ascii")
  path <- tempfile(fileext = ".gml")
  writeLines(newlines, path)

  # If not provided then infer by name
  if (is.null(layer)) {
    layers <- sf::st_layers(path)

    df_layers <- tibble::tibble(
      layer = layers$name,
      geomtype = unlist(layers$geomtype)
    )

    if (any(nrow(df_layers) == 0, !"geomtype" %in% names(df_layers))) {
      message("No spatial layers found.")
      return(invisible(NULL))
    }

    df_layers <- df_layers[!is.na(df_layers$geomtype), ]

    # nocov start
    if (nrow(df_layers) == 0) {
      message("No spatial layers found.")
      return(invisible(NULL))
    }
    # nocov end

    layer <- as.character(df_layers$layer[1])
  }

  out <- try(
    sf::st_read(path, layer = layer, quiet = !verbose),
    silent = TRUE
  )

  # It may be an error, check
  if (inherits(out, "try-error")) {
    message("CatastRO: The result is an empty object")
    return(invisible(NULL))
  }

  out
}
