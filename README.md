# footstan <img src="man/figures/logo.png" align="right" width="60" height="50" />

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

*Note:* This project has no pre-release yet! If you're interested in a 100% working and full-featured package, you will have to wait.

## Description

`footstan` is an `R`-package for fitting Bayesian goal models. Currently it supports the common 
Poisson goal model with no fancy options and a prototype of Poisson taking time into account, dubbed "decreasing variance".  

The sampling is done in [STAN](mc-stan.org/).

## Installation
Do it with `devtools`.

```r
devtools::install_github("JonasMoss/footstan")
```

## Example usage

The package includes the data set `eliteserien`, which contains the football games of the Norwegian top flight from 2009 to about halfway into 2018. Here's how to fit the two supported models to this data set.

```r
# Ordinary Poisson goal model with Eliteserien after 2016.
gm(data = dplyr::filter(eliteserien, Season > 2016), 
   family = "poisson")

# Decreasing variance Poisson goal model with Eliteserien after 2016.
gm(data = dplyr::filter(eliteserien, Season > 2016),
   family = "poisson",
   time = "dv",
   chains = 1)
```
