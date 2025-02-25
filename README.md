
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ICRhelpR

<!-- badges: start -->
<!-- badges: end -->

ICRhelpR is an R package to help make the preparation of data for
intercoder reliability (ICR) easier. It includes functions for
calculating ICR sample sizes and for the construction of ICR datasets
including overlapping observations and random assignment.

## Installation

You can install the development version of ICRhelpR from
[GitHub](https://github.com/) with:

``` r
install.packages("pak")
#> Installing package into 'C:/Users/npjes/AppData/Local/Temp/RtmpUvmBz5/temp_libpath780c4a426825'
#> (as 'lib' is unspecified)
#> package 'pak' successfully unpacked and MD5 sums checked
#> 
#> The downloaded binary packages are in
#>  C:\Users\npjes\AppData\Local\Temp\Rtmpgndl8m\downloaded_packages
pak::pak("npjeschke/ICRhelpR")
#> 
#> → Will update 1 package.
#> → Will download 1 package with unknown size.
#> + ICRhelpR 0.1.0 → 0.1.0 [bld][cmp][dl] (GitHub: 09d89d3)
#> ℹ Getting 1 pkg with unknown size
#> ✔ Cached copy of ICRhelpR 0.1.0 (source) is the latest build
#> ✔ Installed ICRhelpR 0.1.0 (github::npjeschke/ICRhelpR@09d89d3) (72ms)
#> ✔ 1 pkg: upd 1 [2.8s]
```

## Calculating Sample Sizes

The function lacy_riffle_calc is an implementation of the formula for
calculating intercoder reliability sample sizes developed by Lacy and
Riffe (1996). It requires the user to input the total number of content
units being studied (x), then provide their desired degree of confidence
(ci, default is a 95% confidence interval (p=0.05)). It requires an
estimate of the level of agreement in coding all study units. This is
either estimated from a minimal acceptable level of agreement
(min.agree, default is .85) or another estimate of P, such as from prior
ICR work is provided explicitly using the argument P. The function
calculates the result based on the formula provided and provides a
sample size (rounded to the nearest whole number) that will “permit a
known degree of confidence that the agreement in a sample of test units
is representative of the pattern that would occur if all study units
were coded by all coders.”

Lacy, S., & Riffe, D. (1996). Sampling Error and Selecting Intercoder
Reliability Samples for Nominal Content Categories. Journalism & Mass
Communication Quarterly, 73(4), 963-973.
<https://doi.org/10.1177/107769909607300414>

``` r
library(ICRhelpR)
#calculates sample size given the default 95% CI and 85% minimal acceptable level of agreement
result <- lacy_riffe_calc(100)

#calculates sample size given a 99% CI and 90% minimal acceptable level of agreement
result_custom <- lacy_riffe_calc(100, ci = 0.99, min.agree = 0.9)

#calculates sample size given given the default 95% CI and 90% estimated level of agreement across all coding units
result_with_P <- lacy_riffe_calc(100, P = .90)
```

The lacy_riffe_sample function takes a dataframe of all coding units,
calculates the appropriate sample size given desired confidence and
minimal acceptable agreement and then draws a random sample of documents
equal to that number.

``` r

#example dataset
df <- data.frame(a = 1:10, b = letters[1:10])
#with default 95% CI and 85% minimal acceptable level of agreement
sampled_data <- lacy_riffe_sample(df)


#with 99% CI and 90% minimal acceptable level of agreement
sampled_data_custom <- lacy_riffe_sample(df, ci = 0.99, min.agree = 0.9)
```

## Constructing ICR Datasets

The icr_random_draw function simply randomly selects observations from a
dataframe to subset a given number for ICR analysis.

``` r
#creates a dataframe with 50 randomly drawn observations from the given dataframe
data_icr_sample <- icr_random_draw(df, sample = 5)
```

The icr_overlap function creates a new dataframe assigning coders to
observations with a given level of overlap between coders. It randomly
selects a given number of rows, and assigns them to all coders.It
attempts to evenly distribute the remaining observations across all
coders. It can accept with a given number to overlap with the argument
sample = ““, or a percentage of observations to overlap with the
argument percent =”“.

``` r
#creates a dataframe with 50 overlapping observations between 3 coders
data_overlap <- icr_overlap(df, sample = 5, coders = 3)

#creates a dataframe with 25% overlapping observations between 2 coders
data_overlap <- icr_overlap(df, percent = .25, coders = 2)
```
