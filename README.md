
<!-- README.md is generated from README.Rmd. Please edit that file -->

# NA

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/dNA)](https://CRAN.R-project.org/package=dNA)
[![Codecov test
coverage](https://codecov.io/gh/arturhgq/dNA/branch/master/graph/badge.svg)](https://app.codecov.io/gh/arturhgq/dNA?branch=master)
<!-- badges: end -->

The goal of NA is to provide useful tools for handling Missing Data.

## Installation

You can install the development version of dNA like so:

``` r
remotes::install_github("arturhgq/dNA")
```

## Count NA

``` r
library(dNA)
count_na(mtcars)
#> # A tibble: 11 × 2
#>    variable     n
#>    <chr>    <int>
#>  1 mpg          0
#>  2 cyl          0
#>  3 disp         0
#>  4 hp           0
#>  5 drat         0
#>  6 wt           0
#>  7 qsec         0
#>  8 vs           0
#>  9 am           0
#> 10 gear         0
#> 11 carb         0
```
