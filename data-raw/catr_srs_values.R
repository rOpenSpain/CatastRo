## code to prepare `catr_srs_values` dataset goes here
library(tibble)
library(dplyr)

usethis::use_r("data")

catr_srs_values <- tribble(
  ~SRS, ~Description,
  4230, "Geográficas en ED 50",
  4326, "Geográficas en WGS 80",
  4258, "Geográficas en ETRS89",
  32627, "UTM huso 27N en WGS 84",
  32628, "UTM huso 28N en WGS 84",
  32629, "UTM huso 29N en WGS 84",
  32630, "UTM huso 30N en WGS 84",
  32631, "UTM huso 31N en WGS 84",
  25829, "UTM huso 29N en ETRS89",
  25830, "UTM huso 30N en ETRS89",
  25831, "UTM huso 31N en ETRS89",
  23029, "UTM huso 29N en ED50",
  23030, "UTM huso 30N en ED50",
  23031, "UTM huso 31N en ED50",
  3785, "Web Mercator",
  3857, "Web Mercator"
)

catr_srs_values <- catr_srs_values %>% arrange((SRS))

# Add column for OVC services

ovc_codes <- c(
  4230, 4326, 4258, 32627, 32628, 32629, 32630,
  32631, 25829, 25830, 25831, 23029, 23030, 23031
)

catr_srs_values <- catr_srs_values %>%
  mutate(ovc_service = if_else(SRS %in% ovc_codes, TRUE, FALSE))

# Add column for WFS services
wfs_codes <- c(
  4326, 4258, 25829, 25830, 25831,
  3785, 3857
)

catr_srs_values <- catr_srs_values %>%
  mutate(wfs_service = if_else(SRS %in% wfs_codes, TRUE, FALSE))

catr_srs_values
usethis::use_data(catr_srs_values, overwrite = TRUE)
