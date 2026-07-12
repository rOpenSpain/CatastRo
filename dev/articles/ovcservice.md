# OVCCoordenadas service

**CatastRo** provides an R interface to the OVCCoordenadas service from
the [Sede electrónica del
Catastro](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx).

This service retrieves coordinates for a cadastral reference. The
cadastral reference is the only required value, although optional
province and municipality values can narrow the search.

The service can also retrieve cadastral references from longitude and
latitude. You can choose the spatial reference system (SRS, also known
as CRS) used to express the coordinates.

If no exact match is found, the distance query returns cadastral
references within 50 square meters of the requested coordinates.

See the [OVCCoordenadas service
documentation](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccoordenadas.asmx)
for endpoint details.

These functions use the `catr_ovc_get_*()` prefix and return tibbles
from the **tibble** package.

## CatastRo API

The OVCCoordenadas service is available through the following functions:

- [`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor.md).
- [`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor_distancia.md).
- [`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cpmrc.md).

## Reverse geocoding coordinates

[`catr_ovc_get_rccoor()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor.md)
takes the coordinates (`lat` and `lon`) and the spatial reference system
(`srs`) used to express them. It returns a tibble with the cadastral
reference of the property at that spatial point, including other
information such as the address (town, street and number).

``` r

library(CatastRo)

result <- catr_ovc_get_rccoor(
  lat = 38.6196566583596,
  lon = -3.45624183836806,
  srs = "4230"
)

knitr::kable(result)
```

| refcat | address | pc.pc1 | pc.pc2 | geo.xcen | geo.ycen | geo.srs | ldt |
|:---|:---|:---|:---|---:|---:|:---|:---|
| 13077A01800039 | DS DISEMINADO Polígono 18 Parcela 39 000100200VH67C EL TIRADERO. SANTA CRUZ DE MUDELA (CIUDAD REAL) | 13077A0 | 1800039 | -3.456242 | 38.61966 | EPSG:4230 | DS DISEMINADO Polígono 18 Parcela 39 000100200VH67C EL TIRADERO. SANTA CRUZ DE MUDELA (CIUDAD REAL) |

This function accepts the following values for the `srs` argument:

``` r

data(catr_srs_values)

# OVC valid codes.
library(dplyr)

catr_srs_values |>
  filter(ovc_service == TRUE) |>
  select(SRS, Description) |>
  knitr::kable()
```

|   SRS | Description            |
|------:|:-----------------------|
|  4230 | Geográficas en ED 50   |
|  4258 | Geográficas en ETRS89  |
|  4326 | Geográficas en WGS 80  |
| 23029 | UTM huso 29N en ED50   |
| 23030 | UTM huso 30N en ED50   |
| 23031 | UTM huso 31N en ED50   |
| 25829 | UTM huso 29N en ETRS89 |
| 25830 | UTM huso 30N en ETRS89 |
| 25831 | UTM huso 31N en ETRS89 |
| 32627 | UTM huso 27N en WGS 84 |
| 32628 | UTM huso 28N en WGS 84 |
| 32629 | UTM huso 29N en WGS 84 |
| 32630 | UTM huso 30N en WGS 84 |
| 32631 | UTM huso 31N en WGS 84 |

You can retrieve cadastral references within 50 square meters of `lat`
and `lon` with
[`catr_ovc_get_rccoor_distancia()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_rccoor_distancia.md).

``` r

catr_ovc_get_rccoor_distancia(
  lat = 40.96002,
  lon = -5.663408,
  srs = "4230"
) |>
  knitr::kable()
```

| geo.xcen | geo.ycen | geo.srs | refcat | address | cmun_ine | pc.pc1 | pc.pc2 | dt.loine.cp | dt.loine.cm | dt.lourb.dir.cv | dt.lourb.dir.pnp | ldt | dis |
|---:|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| -5.663408 | 40.96002 | EPSG:4230 | 5877501TL7357F | AV REYES DE ESPAÑA 1 SALAMANCA (SALAMANCA) | 37274 | 5877501 | TL7357F | 37 | 274 | 643 | 1 | AV REYES DE ESPAÑA 1 SALAMANCA (SALAMANCA) | 21.81 |
| -5.663408 | 40.96002 | EPSG:4230 | 5778706TL7357H | AV REYES DE ESPAÑA 2 N2-4 SALAMANCA (SALAMANCA) | 37274 | 5778706 | TL7357H | 37 | 274 | 643 | 2 | AV REYES DE ESPAÑA 2 N2-4 SALAMANCA (SALAMANCA) | 23.18 |

## Geocoding a cadastral reference

For the opposite query,
[`catr_ovc_get_cpmrc()`](https://ropenspain.github.io/CatastRo/dev/reference/catr_ovc_get_cpmrc.md)
accepts a cadastral reference (`rc`) and returns `xcoord` and `ycoord`
in the specified `srs`, together with the address. Optional `province`
and `municipality` values can narrow the search.

``` r

catr_ovc_get_cpmrc(
  rc = "13077A01800039",
  srs = "4230",
  province = "CIUDAD REAL",
  municipality = "SANTA CRUZ DE MUDELA"
) |>
  knitr::kable()
```

| xcoord | ycoord | refcat | address | pc.pc1 | pc.pc2 | geo.xcen | geo.ycen | geo.srs | ldt |
|---:|---:|:---|:---|:---|:---|:---|:---|:---|:---|
| -3.456242 | 38.61966 | 13077A01800039 | DS DISEMINADO Polígono 18 Parcela 39 000100200VH67C EL TIRADERO. SANTA CRUZ DE MUDELA (CIUDAD REAL) | 13077A0 | 1800039 | -3.45624183836806 | 38.6196566583596 | EPSG:4230 | DS DISEMINADO Polígono 18 Parcela 39 000100200VH67C EL TIRADERO. SANTA CRUZ DE MUDELA (CIUDAD REAL) |

The following query narrows the search with `municipality`:

``` r

catr_ovc_get_cpmrc(
  rc = "13077A01800039",
  municipality = "SANTA CRUZ DE MUDELA"
) |>
  knitr::kable()
#> ✖ OVC service error "11": LA PROVINCIA ES OBLIGATORIA
```

| refcat         | geo.srs   |
|:---------------|:----------|
| 13077A01800039 | EPSG:4326 |

You can also query with only `rc`:

``` r

# Get the result without a warning.
catr_ovc_get_cpmrc(rc = "13077A01800039") |>
  knitr::kable()
```

| xcoord | ycoord | refcat | address | pc.pc1 | pc.pc2 | geo.xcen | geo.ycen | geo.srs | ldt |
|---:|---:|:---|:---|:---|:---|:---|:---|:---|:---|
| -3.457532 | 38.61843 | 13077A01800039 | DS DISEMINADO Polígono 18 Parcela 39 000100200VH67C EL TIRADERO. SANTA CRUZ DE MUDELA (CIUDAD REAL) | 13077A0 | 1800039 | -3.45753233627867 | 38.6184314024661 | EPSG:4326 | DS DISEMINADO Polígono 18 Parcela 39 000100200VH67C EL TIRADERO. SANTA CRUZ DE MUDELA (CIUDAD REAL) |
