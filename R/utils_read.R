st_read_layers_encoding <- function(path, verbose) {
  # Layer management and errors
  layers <- tryCatch(sf::st_layers(path),
    warning = function(e) {
      return(NULL)
    },
    error = function(e) {
      return(NULL)
    }
  )

  # If NULL change to a new tempfile and retry
  # This may be an error on encoding
  if (is.null(layers)) {
    newlines <- readLines(path,
      encoding = "ISO-8859-1"
    )

    # Thanks @santiagomota #19
    newlines <- stringi::stri_trans_general(newlines, "latin-ascii")
    path <- tempfile(fileext = ".gml")
    writeLines(newlines, path)

    layers <- sf::st_layers(path)
  }

  df_layers <- tibble::tibble(
    layer = layers$name,
    geomtype = unlist(layers$geomtype)
  )

  if (nrow(df_layers) == 0 || !"geomtype" %in% names(df_layers)) {
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


  out <- try(sf::st_read(path,
    layer = df_layers$layer[1],
    quiet = !verbose
  ), silent = TRUE)

  # It may be an error, check
  if (inherits(out, "try-error")) {
    message("CatastRO: The result is an empty object")
    return(invisible(NULL))
  }

  return(out)
}
