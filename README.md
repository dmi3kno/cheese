
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cheese

The goal of `cheese` is to facilitiate appreciation of the culinary
culture of cheesemaking through data analysis of the largest collection
of cheeses from www.cheese.com

## Installation

You can install the development version of `cheese` from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("dmi3kno/cheese")
#> Using github PAT from envvar GITHUB_PAT
#> Downloading GitHub repo dmi3kno/cheese@master
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(cheese)
cheese
#> # A tibble: 1,830 x 21
#>    name  title description href  alternative_spe~ aroma calcium_content
#>    <chr> <chr> <chr>       <chr> <chr>            <chr> <chr>          
#>  1 Abba~ Abba~ "Abbaye de~ http~ <NA>             lano~ <NA>           
#>  2 Abba~ Abba~ "This chee~ http~ <NA>             arom~ <NA>           
#>  3 Abba~ Abba~ "The Abbay~ http~ <NA>             barn~ <NA>           
#>  4 Abba~ Abba~ Being dire~ http~ <NA>             <NA>  <NA>           
#>  5 Abba~ Abba~ The Abbaye~ http~ <NA>             flor~ <NA>           
#>  6 Abbo~ Abbo~ Abbot's Go~ http~ <NA>             arom~ <NA>           
#>  7 Aber~ Aber~ Abertam is~ http~ <NA>             <NA>  <NA>           
#>  8 Abon~ Abon~ "Tomme d'A~ http~ Tomme d'Abondan~ nutty <NA>           
#>  9 Acap~ Acap~ "Acapella ~ http~ <NA>             fres~ <NA>           
#> 10 Acca~ Acca~ Accasciato~ http~ <NA>             arom~ <NA>           
#> # ... with 1,820 more rows, and 14 more variables: colour <chr>,
#> #   country_of_origin <chr>, family <chr>, fat_content <chr>,
#> #   fat_content_in_dry_matter_ <chr>, flavour <chr>, made_from <chr>,
#> #   producers <chr>, region <chr>, rind <chr>, synonyms <chr>,
#> #   texture <chr>, type <chr>, vegetarian <chr>
```

Note that because it is a data package, it is documented with
`devtools::document()` and not with `roxygen2::roxygenize()`
