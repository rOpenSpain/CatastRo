# Decide whether an example should run

Determine whether an example should run based on the current platform
and network availability.

## Usage

``` r
run_example()
```

## Value

Logical. `TRUE` if examples should run, `FALSE` otherwise.

## Details

Returns `FALSE` on CRAN, macOS, or when offline.

## Examples

``` r
run_example()
#> [1] TRUE
```
