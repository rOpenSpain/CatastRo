
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CatastRo <a href="https://ropenspain.github.io/CatastRo/"><img src="man/figures/logo.png" align="right" height="139"/></a>

<!-- badges: start -->

[![rOS-badge](https://ropenspain.github.io/rostemplate/reference/figures/ropenspain-badge.svg)](https://ropenspain.es/)
[![CRAN-status](https://www.r-pkg.org/badges/version/CatastRo)](https://CRAN.R-project.org/package=CatastRo)
[![CRAN-results](https://badges.cranchecks.info/worst/CatastRo.svg)](https://cran.r-project.org/web/checks/check_results_CatastRo.html)
[![Downloads](https://cranlogs.r-pkg.org/badges/CatastRo)](https://CRAN.R-project.org/package=CatastRo)
[![r-universe](https://ropenspain.r-universe.dev/badges/CatastRo)](https://ropenspain.r-universe.dev/CatastRo)
[![R-CMD-check](https://github.com/rOpenSpain/CatastRo/actions/workflows/roscron-check-standard.yaml/badge.svg)](https://github.com/rOpenSpain/CatastRo/actions/workflows/roscron-check-standard.yaml)
[![R-hub](https://github.com/rOpenSpain/CatastRo/actions/workflows/rhub.yaml/badge.svg)](https://github.com/rOpenSpain/CatastRo/actions/workflows/rhub.yaml)
[![codecov](https://codecov.io/gh/rOpenSpain/CatastRo/graph/badge.svg?token=KPPwTkZjW6)](https://app.codecov.io/gh/rOpenSpain/CatastRo)
[![DOI](https://img.shields.io/badge/DOI-10.32614/CRAN.package.CatastRo-blue)](https://doi.org/10.32614/CRAN.package.CatastRo)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

<!-- badges: end -->

**CatastRo** is a package that provide access to different API services
of the [Spanish Cadastre](https://www.sedecatastro.gob.es/). With
**CatastRo** it is possible to download spatial objects (as buildings or
cadastral parcels), maps and geocode cadastral references.

## Installation

Install **CatastRo** from
[**CRAN**](https://CRAN.R-project.org/package=CatastRo):

``` r
install.packages("CatastRo")
```

You can install the developing version of **CatastRo** using the
[r-universe](https://ropenspain.r-universe.dev/CatastRo):

``` r
# Install CatastRo in R:
install.packages("CatastRo",
  repos = c(
    "https://ropenspain.r-universe.dev",
    "https://cloud.r-project.org"
  )
)
```

Alternatively, you can install the developing version of **CatastRo**
with:

``` r
remotes::install_github("rOpenSpain/CatastRo", dependencies = TRUE)
```

## Package API

The functions of **CatastRo** are organized by API endpoint. The package
naming convention is `catr_*api*_*description*`.

### OVCCoordenadas

These functions allow to geocode and reverse geocode cadastral
references using the
[OVCCoordenadas](https://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx)
service.

These functions are named `catr_ovc_get_*` and returns a tibble, as
provided by the package **tibble**. See
`vignette("ovcservice", package = "CatastRo")` where these functions are
described.

### INSPIRE

These functions return spatial object (on the formats provided by the
**sf** or **terra** using the [Catastro
INSPIRE](https://www.catastro.hacienda.gob.es/webinspire/index.html)
service.

Note that the coverage of this service is 95% of the Spanish territory,
<u>excluding Basque Country and Navarre</u>[^1] that have their own
independent cadastral offices.

There are three types of functions, each one querying a different
service:

#### ATOM service

The ATOM service allows to batch-download vector objects of different
cadastral elements for a specific municipality. The result is provided
as `sf` objects (See **sf** package).

These functions are named `catr_atom_get_xxx`.

#### WFS service

The WFS service allows to download vector objects of specific cadastral
elements. The result is provided as `sf` class objects (see
[**sf**](https://r-spatial.github.io/sf/) package). Note that there are
some limitations on the extension and number of elements to query. For
batch-downloading the ATOM service is preferred.

These functions are named `catr_wms_get_xxx`.

#### WMS service

This service allows to download georeferenced images of different
cadastral elements. The result is a raster on the format provides by
[**terra**](https://rspatial.github.io/terra/reference/terra-package.html).

There is a single function for querying this service:
`catr_wms_get_layer()`.

#### Terms and conditions of use

Please check the [downloading
provisions](https://www.catastro.hacienda.gob.es/webinspire/documentos/Licencia.pdf)
of the service.

## Examples

This script highlights some features of **CatastRo** :

### Geocode a cadastral reference

``` r
library(CatastRo)

catr_ovc_get_cpmrc(rc = "13077A01800039")
#> # A tibble: 1 × 10
#>   xcoord ycoord refcat     address pc.pc1 pc.pc2 geo.xcen geo.ycen geo.srs ldt  
#>    <dbl>  <dbl> <chr>      <chr>   <chr>  <chr>  <chr>    <chr>    <chr>   <chr>
#> 1  -3.46   38.6 13077A018… DS DIS… 13077… 18000… -3.4575… 38.6184… EPSG:4… DS D…
```

### Extract a cadastral reference from a given set of coordinates

``` r
catr_ovc_get_rccoor(
  lat = 38.6196566583596,
  lon = -3.45624183836806,
  srs = "4230"
)
#> # A tibble: 1 × 8
#>   refcat         address           pc.pc1 pc.pc2 geo.xcen geo.ycen geo.srs ldt  
#>   <chr>          <chr>             <chr>  <chr>     <dbl>    <dbl> <chr>   <chr>
#> 1 13077A01800039 DS DISEMINADO  P… 13077… 18000…    -3.46     38.6 EPSG:4… DS D…
```

### Extract geometries using the ATOM service

``` r
bu <- catr_atom_get_buildings("Nava de la Asuncion", to = "Segovia")


# Map
library(ggplot2)

ggplot(bu) +
  geom_sf(aes(fill = currentUse), col = NA) +
  coord_sf(
    xlim = c(374500, 375500),
    ylim = c(4556500, 4557500)
  ) +
  scale_fill_manual(values = hcl.colors(6, "Dark 3")) +
  theme_minimal() +
  ggtitle("Nava de la Asunción, Segovia")
```

<img src="man/figures/README-atom-1.png" width="100%" />

### Extract geometries using the WFS service

``` r
wfs_get_buildings <- catr_wfs_get_buildings_bbox(
  c(-5.569, 42.598, -5.564, 42.601),
  srs = 4326
)

# Map
ggplot(wfs_get_buildings) +
  geom_sf() +
  ggtitle("Leon Cathedral, Spain")
```

<img src="man/figures/README-wfs-1.png" width="100%" />

### Extract maps using the WMS service

``` r
# For tiles better project

wfs_get_buildings_pr <- sf::st_transform(wfs_get_buildings, 25830)

wms_bu <- catr_wms_get_layer(wfs_get_buildings_pr,
  srs = 25830,
  bbox_expand = 0.2
)

# Map
# Load tidyterra
library(tidyterra)
ggplot() +
  geom_spatraster_rgb(data = wms_bu) +
  geom_sf(data = wfs_get_buildings_pr, fill = "red", alpha = 0.6)
```

<img src="man/figures/README-wms-1.png" width="100%" />

## A note on caching

Some data sets and tiles may have a size larger than 50MB. You can use
**CatastRo** to create your own local repository at a given local
directory passing the following option:

``` r
catr_set_cache_dir("./path/to/location")
```

When this option is set, **CatastRo** would look for the cached file and
it will load it, speeding up the process.

## Citation

<p>
Delgado Panadero Á, Hernangómez D (2024). <em>CatastRo: Interface to the
API Sede Electrónica Del Catastro</em>.
<a href="https://doi.org/10.32614/CRAN.package.CatastRo">doi:10.32614/CRAN.package.CatastRo</a>,
<a href="https://ropenspain.github.io/CatastRo/">https://ropenspain.github.io/CatastRo/</a>.
</p>

A BibTeX entry for LaTeX users is:

    @Manual{R-CatastRo,
      title = {{CatastRo}: Interface to the {API} Sede Electrónica Del Catastro},
      author = {Ángel {Delgado Panadero} and Diego Hernangómez},
      doi = {10.32614/CRAN.package.CatastRo},
      year = {2024},
      version = {0.4.0},
      url = {https://ropenspain.github.io/CatastRo/},
      abstract = {Access public spatial data available under the INSPIRE directive. Tools for downloading references and addresses of properties, as well as map images.},
    }

## Contribute

Check the GitHub page for [source
code](https://github.com/ropenspain/CatastRo/).

[^1]: The package
    [**CatastRoNav**](https://ropenspain.github.io/CatastRoNav/)
    provides access to the Cadastre of Navarre, with similar
    functionalities than **CatastRo**.
