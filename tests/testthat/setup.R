# Testing only

withr::local_options(
  catastro_ssl_verify = 0,
  .local_envir = teardown_env()
)
