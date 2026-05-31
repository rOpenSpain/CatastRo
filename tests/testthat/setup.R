# Testing only

withr::local_options(
  list(catastro_ssl_verify = 0, catastro_timeout = 600),
  .local_envir = testthat::teardown_env()
)
