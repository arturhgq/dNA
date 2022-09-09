
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dNA

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/dNA)](https://CRAN.R-project.org/package=dNA)
[![Codecov test
coverage](https://codecov.io/gh/arturhgq/dNA/branch/master/graph/badge.svg)](https://app.codecov.io/gh/arturhgq/dNA?branch=master)
[![R-CMD-check](https://github.com/arturhgq/dNA/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/arturhgq/dNA/actions/workflows/R-CMD-check.yaml)
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

tibble::tibble(
  var1 = c(1,2,3,4, NA),
  var2 = c(NA, NA, NaN, 2, 3),
  group = c(2010,2010,2012,2012, 2012)
) -> data

count_na(data)
#> # A tibble: 3 × 2
#>   variable     n
#>   <chr>    <int>
#> 1 var2         3
#> 2 var1         1
#> 3 group        0
count_group_na(data, .group = group)
#> # A tibble: 6 × 3
#>   variable     n group
#>   <chr>    <int> <chr>
#> 1 var2         2 2010 
#> 2 var1         0 2010 
#> 3 group        0 2010 
#> 4 var1         1 2012 
#> 5 var2         1 2012 
#> 6 group        0 2012
```

## Replace NA

``` r
replace_na(data)
#> # A tibble: 5 × 3
#>    var1  var2 group
#>   <dbl> <dbl> <dbl>
#> 1     1     0  2010
#> 2     2     0  2010
#> 3     3     0  2012
#> 4     4     2  2012
#> 5     0     3  2012
```
