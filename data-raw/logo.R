library(CatastRo)
library(sf)
library(dplyr)

# Use Segovia

# Coord Plaza del Azoguejo: To Point

top <- st_point(c(-4.118115, 40.9478688)) %>%
  st_sfc(crs = 4326) %>%
  st_transform(st_crs(25830))

# Create spatial hexagon
hex <- function(x, center, size) {
  angle_deg <- 60 * x - 30
  angle_rad <- pi / 180 * angle_deg
  x <- center[1, 1] + size * cos(angle_rad)
  y <- center[1, 2] + size * sin(angle_rad)

  return(c(x, y))
}
hex_pol <- lapply(1:7,
  hex,
  center = st_coordinates(top), # Center coords
  size = 500 # Side lenght (meters)
) %>%
  # Convert to spatial polygon
  unlist() %>%
  matrix(ncol = 2, byrow = TRUE) %>%
  list() %>%
  st_polygon() %>%
  st_sfc() %>%
  st_set_crs(st_crs(top))

# Get Segovia
segovia <- catr_atom_bu("40900")


finalpols <- st_intersection(segovia, hex_pol)
plot(finalpols$geometry)


library(ggplot2)


p <- ggplot(finalpols) +
  geom_sf(aes(fill = currentUse),
    col = "white",
    size = 0.01,
    show.legend = FALSE
  ) +
  scale_fill_manual(
    values = hcl.colors(7, "Mint", alpha = 0.7),
    na.value = hcl.colors(7, "Mint", alpha = 0.7)[1]
  ) +
  theme_void()



p


library(hexSticker)

cols <- hcl.colors(7, "Mint")
text <- colorspace::darken(cols[1], 0.8)


sysfonts::font_add("noto",
  regular = "data-raw/NotoSerif-Regular.ttf",
  bold = "data-raw/NotoSerif-Bold.ttf"
)

showtext::showtext_auto()

sticker(p,
  package = "CatastRo",
  p_family = "noto",
  p_fontface = "bold",
  s_width = 2.1,
  s_height = 2.1,
  s_x = 1,
  s_y = 0.95,
  p_color = text,
  p_size = 28,
  p_y = 1,
  h_fill = "white",
  h_color = text,
  filename = "data-raw/logo.png",
)
