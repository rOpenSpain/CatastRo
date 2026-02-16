# OVCCallejero: Extract the code of a municipality

Implementation of the OVCCallejero service
[ConsultaMunicipioCodigos](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaMunicipioCodigos).

Return the names and codes of a municipality. Returns both the codes as
per the Cadastre and as per the INE (National Statistics Institute).

## Usage

``` r
catr_ovc_get_cod_munic(cpro, cmun = NULL, cmun_ine = NULL, verbose = FALSE)
```

## Arguments

- cpro:

  The code of a province, as provided by
  [`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md).

- cmun:

  Code of a municipality, as recorded on the Spanish Cadastre.

- cmun_ine:

  Code of a municipality, as recorded on National Statistics Institute.
  See [INE: List of
  municipalities](https://www.ine.es/daco/daco42/codmun/codmun00i.htm)

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html). See
**Details**

## Details

Parameter `cpro` is mandatory. Either `cmun` or `cmun_ine` should be
provided.

On a successful query, the function returns a
[`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with one
row including the following columns:

- `munic`: Name of the municipality as per the Cadastre.

- `catr_to`: Cadastral territorial office code.

- `catr_munic`: Municipality code as recorded on the Cadastre.

- `catrcode`: Full Cadastral code for the municipality.

- `cpro`: Province code as per the INE.

- `catr_munic`: Municipality code as per the INE.

- `catrcode`: Full INE code for the municipality.

- Rest of fields: Check the API Docs.

## References

[ConsultaMunicipioCodigos](https://ovc.catastro.meh.es/ovcservweb/ovcswlocalizacionrc/ovccallejerocodigos.asmx?op=ConsultaMunicipioCodigos).

## See also

[`mapSpain::esp_get_munic()`](https://ropenspain.github.io/mapSpain/reference/esp_get_munic.html)
to get shapes of municipalities, including the INE code.

OVCCoordenadas API:
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)

Other search:
[`catr_atom_search_munic()`](https://ropenspain.github.io/CatastRo/reference/catr_atom_search_munic.md),
[`catr_get_code_from_coords()`](https://ropenspain.github.io/CatastRo/reference/catr_get_code_from_coords.md),
[`catr_ovc_get_cod_provinces()`](https://ropenspain.github.io/CatastRo/reference/catr_ovc_get_cod_provinces.md)

## Examples

``` r
if (FALSE) { # tolower(Sys.info()[["sysname"]]) != "linux"
# \donttest{
# Get municipality by cadastal code
ab <- catr_ovc_get_cod_munic(2, 900)

ab

# Same query using the INE code

ab2 <- catr_ovc_get_cod_munic(2, cmun_ine = 3)

ab2
# }
}
```
