# CatastRo

[![Build Status](https://travis-ci.org/DelgadoPanadero/CatastRo.svg?branch=master)](https://travis-ci.org/DelgadoPanadero/CatastRo)

R package to query [Sede electrónica del Catastro](http://ovc.catastro.meh.es/ovcservweb/OVCSWLocalizacionRC/OVCCoordenadas.asmx) API. 
The API is documented [here](http://www.catastro.meh.es/ayuda/lang/castellano/servicios_web.htm).

## Installation

```
library(devtools)
install_github("DelgadoPanadero/CatastRo")
```

## Query a coordinate

The function `getRC` recives the coordinates (lat,lon) and the spatial reference used. The return is the casdastral reference of the property in that point, as well as the direction (town street and number).


```
reference <- getRC(lat,lon,SRS = EPSG:4230)
print(reference)
``` 

It is also possible to get all the cadastral references in a square of 50 meters side centered in the coordinates (lat,lon) throught the function `getRC_distance`.

```
references <- getRC_distance(lat,lon,SRS = EPSG:4230)
print(references)
``` 

## Query CPMRC 

It is possible, as well, the opposite. Given to the function `getCOOR` a cadastral reference, `getCOOR` returns its coordinates (X,Y) in a particular SRS moreover the direction (town, street and number).

```
direction <- getCOOR(CadastralReference, SRS,  Province, Municipality)

# The argument SRS could be missed, in that case, getCOOR() returns the coordinates with which was stored

print(direction)
```
