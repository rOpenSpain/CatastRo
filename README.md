# CatastRo

[![Build Status](https://travis-ci.org/rOpenSpain/CatastRo.svg?branch=master)](https://travis-ci.org/rOpenSpain/CatastRo)

R package to query [Sede electrónica del Catastro](http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx) API. 
The API is documented [here](http://www.catastro.meh.es/ayuda/lang/castellano/servicios_web.htm).

## Installation

```
library(devtools)
install_github("rOpenSpain/CatastRo")
```

## Query a coordinate

The function `get_rc` receives the coordinates (lat,lon) and the spatial reference used. The return is the casdastral reference of the property in that spatial point, as well as the direction (town street and number).


```
reference <- get_rc(lat, lon, SRS)
print(reference)
``` 

It can be requested to get all the cadastral references in a square of 50 meters side centered in the coordinates (lat,lon) throught the function `near_rc`.

```
references <- near_rc(lat, lon, SRS)
print(references)
``` 

## Query CPMRC 

It is possible, as well, the opposite. Given to the function `get_coor` a cadastral reference, `get_coor` returns its coordinates (lat,lon) in a particular SRS moreover the direction (town, street and number).

```
direction <- get_coor(Cadastral_Reference, SRS,  Province, Municipality)

# The argument SRS could be missed, in that case, `get_coor` returns the coordinates with which the catastral referenced was registered.

print(direction)
```
