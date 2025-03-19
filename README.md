
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

<img src="man/figures/README-atom-1.png" alt="Extracting buildings in Nava de la Asuncion with the ATOM service" width="100%" />

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

<img src="man/figures/README-wfs-1.png" alt="Extract Leon Cathedral with the WFS service" width="100%" />

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
Delgado Panadero Á, Hernangómez D (2025). <em>CatastRo: Interface to the
API Sede Electrónica Del Catastro</em>.
<a href="https://doi.org/10.32614/CRAN.package.CatastRo">doi:10.32614/CRAN.package.CatastRo</a>,
<a href="https://ropenspain.github.io/CatastRo/">https://ropenspain.github.io/CatastRo/</a>.
</p>

A BibTeX entry for LaTeX users is:

    @Manual{R-CatastRo,
      title = {{CatastRo}: Interface to the {API} Sede Electrónica Del Catastro},
      author = {Ángel {Delgado Panadero} and Diego Hernangómez},
      doi = {10.32614/CRAN.package.CatastRo},
      year = {2025},
      version = {0.4.0},
      url = {https://ropenspain.github.io/CatastRo/},
      abstract = {Access public spatial data available under the INSPIRE directive. Tools for downloading references and addresses of properties, as well as map images.},
    }

## Contribute

Check the GitHub page for [source
code](https://github.com/ropenspain/CatastRo/).

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

All contributions to this project are gratefully acknowledged using the
[`allcontributors` package](https://github.com/ropensci/allcontributors)
following the [allcontributors](https://allcontributors.org)
specification. Contributions of any kind are welcome!

### Code

<table class="table allctb-table">
<tr>
<td align="center">
<a href="https://github.com/DelgadoPanadero">
<img src="https://avatars.githubusercontent.com/u/20685256?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenSpain/CatastRo/commits?author=DelgadoPanadero">DelgadoPanadero</a>
</td>
<td align="center">
<a href="https://github.com/dieghernan">
<img src="https://avatars.githubusercontent.com/u/25656809?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenSpain/CatastRo/commits?author=dieghernan">dieghernan</a>
</td>
<td align="center">
<a href="https://github.com/Enchufa2">
<img src="https://avatars.githubusercontent.com/u/4542928?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenSpain/CatastRo/commits?author=Enchufa2">Enchufa2</a>
</td>
</tr>
</table>

### Issues

<table class="table allctb-table">
<tr>
<td align="center">
<a href="https://github.com/davidsl83">
<img src="https://avatars.githubusercontent.com/u/8825826?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenSpain/CatastRo/issues?q=is%3Aissue+author%3Adavidsl83">davidsl83</a>
</td>
<td align="center">
<a href="https://github.com/hdnh2006">
<img src="https://avatars.githubusercontent.com/u/17271049?u=e49249efc3b6ecf11f9120b5e2b7f92c03797fb0&v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenSpain/CatastRo/issues?q=is%3Aissue+author%3Ahdnh2006">hdnh2006</a>
</td>
<td align="center">
<a href="https://github.com/cjgb">
<img src="https://avatars.githubusercontent.com/u/1321567?u=f0ce1208c79befa4e61b7dd98c52bf5143fe92a5&v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenSpain/CatastRo/issues?q=is%3Aissue+author%3Acjgb">cjgb</a>
</td>
<td align="center">
<a href="https://github.com/calejero">
<img src="https://avatars.githubusercontent.com/u/58038280?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenSpain/CatastRo/issues?q=is%3Aissue+author%3Acalejero">calejero</a>
</td>
<td align="center">
<a href="https://github.com/fjribal">
<img src="https://avatars.githubusercontent.com/u/8107607?u=42ec5d15592963a1ea1ab524ae76c101a75849c0&v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenSpain/CatastRo/issues?q=is%3Aissue+author%3Afjribal">fjribal</a>
</td>
<td align="center">
<a href="https://github.com/jesbrz">
<img src="https://avatars.githubusercontent.com/u/19475313?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenSpain/CatastRo/issues?q=is%3Aissue+author%3Ajesbrz">jesbrz</a>
</td>
<td align="center">
<a href="https://github.com/jaimecabota">
<img src="https://avatars.githubusercontent.com/u/50590456?v=4" width="100px;" class="allctb-avatar" alt=""/>
</a><br>
<a href="https://github.com/rOpenSpain/CatastRo/issues?q=is%3Aissue+author%3Ajaimecabota">jaimecabota</a>
</td>
</tr>
</table>
<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

[^1]: The package
    [**CatastRoNav**](https://ropenspain.github.io/CatastRoNav/)
    provides access to the Cadastre of Navarre, with similar
    functionalities than **CatastRo**.
