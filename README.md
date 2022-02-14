
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CatastRo

<!-- badges: start -->

[![rOS-badge](https://ropenspain.github.io/rostemplate/reference/figures/ropenspain-badge.svg)](https://ropenspain.es/)
<!-- [![CRAN-status](https://www.r-pkg.org/badges/version/CatastRo)](https://CRAN.R-project.org/package=CatastRo) -->
<!-- [![CRAN-results](https://cranchecks.info/badges/worst/CatastRo)](https://cran.r-project.org/web/checks/check_results_CatastRo.html) -->
<!-- [![Downloads](https://cranlogs.r-pkg.org/badges/CatastRo)](https://CRAN.R-project.org/package=CatastRo) -->
[![r-universe](https://ropenspain.r-universe.dev/badges/CatastRo)](https://ropenspain.r-universe.dev/)
[![R-CMD-check](https://github.com/rOpenSpain/CatastRo/workflows/R-CMD-check/badge.svg)](https://github.com/rOpenSpain/CatastRo/actions?query=workflow%3AR-CMD-check)
[![codecov](https://codecov.io/gh/rOpenSpain/CatastRo/branch/master/graph/badge.svg?token=6L01BKLL85)](https://app.codecov.io/gh/rOpenSpain/CatastRo)
[![DOI](https://img.shields.io/badge/DOI-10.5281/zenodo.6044091-blue)](https://doi.org/10.5281/zenodo.6044091)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

R package to query [Sede Electrónica del
Catastro](http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx)
API. The API is documented
[here](https://www.catastro.meh.es/ayuda/lang/castellano/servicios_web.htm).

## Installation

You can install the developing version of **CatastRo** using the
[r-universe](https://ropenspain.r-universe.dev/ui#builds):

``` r
# Enable this universe
options(repos = c(
  ropenspain = "https://ropenspain.r-universe.dev",
  CRAN = "https://cloud.r-project.org"
))
install.packages("CatastRo")
```

Alternatively, you can install the developing version of **CatastRo**
with:

``` r
library(remotes)
install_github("rOpenSpain/CatastRo", dependencies = TRUE)
```

## Query a coordinate

The function `get_rc()` receives the coordinates (lat,lon) and the
spatial reference used. The return is the cadastral reference of the
property in that spatial point, as well as the direction (town street
and number).

``` r
library(CatastRo)

reference <- get_rc(lat, lon, SRS)
print(reference)
```

It can be requested to get all the cadastral references in a square of
50-meters side centered in the coordinates (lat,lon) through the
function `near_rc()`.

``` r
references <- near_rc(lat, lon, SRS)
print(references)
```

## Query CPMRC

It is possible, as well, the opposite. Given to the function
`get_coor()` a cadastral reference, `get_coor()` returns its coordinates
(lat,lon) in a particular SRS moreover the direction (town, street and
number).

``` r
direction <- get_coor(Cadastral_Reference, SRS, Province, Municipality)

# The argument SRS could be missed, in that case, `get_coor()` returns the coordinates in the SRS used by Google Maps.

print(direction)
```

## Citation

To cite ‘CatastRo’ in publications use:

Delgado Panadero Á, Hernangómez D (2022). *CatastRo: Interface to the
API Sede Electrónica Del Catastro*. doi: 10.5281/zenodo.6044091 (URL:
<https://doi.org/10.5281/zenodo.6044091>), \<URL:
<https://ropenspain.github.io/CatastRo/>\>.

A BibTeX entry for LaTeX users is:

    @Manual{,
      title = {{CatastRo}: Interface to the {API} Sede Electrónica Del Catastro},
      author = {Ángel {Delgado Panadero} and Diego Hernangómez},
      year = {2022},
      version = {0.1.0.9000},
      url = {https://ropenspain.github.io/CatastRo/},
      doi = {10.5281/zenodo.6044091},
      abstract = {Tools for downloading cadastral references and addresses of properties. Access public spatial data available under the 'INSPIRE' directive.},
    }

## Contribute

Check the GitHub page for [source
code](https://github.com/ropenspain/CatastRo/).
