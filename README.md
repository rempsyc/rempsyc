
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rempsyc <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/RemPsyc/rempsyc/workflows/R-CMD-check/badge.svg)](https://github.com/RemPsyc/rempsyc/actions)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![packageversion](https://img.shields.io/badge/Package%20version-0.0.1.3-orange.svg?style=flat-square)](https://github.com/RemPsyc/rempsyc/commits/main)
[![Last-changedate](https://img.shields.io/badge/last%20change-2022--03--02-yellowgreen.svg)](https://github.com/RemPsyc/rempsyc/commits/main)
[![Last-commit](https://img.shields.io/github/last-commit/rempsyc/rempsyc)](https://github.com/RemPsyc/rempsyc/commits/main)
[![license](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
![size](https://img.shields.io/github/repo-size/rempsyc/rempsyc)
[![sponsors](https://img.shields.io/github/sponsors/rempsyc)](https://paypal.me/rempsyc)
[![followers](https://img.shields.io/github/followers/rempsyc?style=social)](https://github.com/RemPsyc?tab=followers)
[![forks](https://img.shields.io/github/forks/rempsyc/rempsyc?style=social)](https://github.com/RemPsyc/rempsyc/network/members)
![stars](https://img.shields.io/github/stars/rempsyc/rempsyc?style=social)
<!-- badges: end -->

Convenience functions to make your workflow faster and easier. Easily
customizable plots (via `ggplot2`), nice APA tables exportable to Word
(via `flextable`), easily run statistical tests or check assumptions,
and automatize various other tasks. Mostly geared at researchers in the
psychological sciences.

## Installation

You can install the development version (the only version currently
available) of the `rempsyc` package from GitHub with:

``` r
# If devtools isn't already installed, install it with install.packages("devtools")
library(devtools)
install_github("rempsyc/rempsyc")
```

You can load the package and open the help file, and click “Index” at
the bottom. You will see all the available functions listed.

``` r
library(rempsyc)
?rempsyc
```

## Example functions/outputs

``` r
library(rempsyc)

# Moderations
nice_mod(response = "mpg",
         predictor = "gear",
         moderator = "wt",
         data = mtcars) -> moderations
moderations
#>   Dependent Variable Predictor df         b          t          p         sr2
#> 1                mpg      gear 28  5.615951  1.9437108 0.06204275 0.028488305
#> 2                mpg        wt 28  1.403861  0.4301493 0.67037970 0.001395217
#> 3                mpg   gear:wt 28 -1.966931 -2.1551077 0.03989970 0.035022025

# Format results in nice table
my_table <- nice_table(moderations, highlight = TRUE)
my_table
```

<img src="man/figures/nicetable.png" width="100%" />

``` r
# Save to word
save_as_docx(my_table, path = "D:/R treasures/moderations.docx")

# Violin plot
nice_violin(data = ToothGrowth,
            group = "dose",
            response = "len",
            xlabels = c("Low", "Medium", "High"))
```

<img src="man/figures/README-example2-1.png" width="60%" />

``` r
# Scatter plot
nice_scatter(data = mtcars,
             predictor = wt,
             response = mpg)
```

<img src="man/figures/README-example2-2.png" width="60%" />

``` r
# Save plot
ggsave('niceplot.pdf', width = 7, height = 7, unit = 'in', 
       dpi = 300, path = "D:/R treasures/")
```

See tutorials here:

<https://remi-theriault.com/blog_violin.html>

<https://remi-theriault.com/blog_scatter.html>

<https://remi-theriault.com/blog_randomize.html>

<https://remi-theriault.com/blog_circles.html>

<https://remi-theriault.com/blog_table.html>

<https://remi-theriault.com/blog_assumptions>

<https://remi-theriault.com/blog_t-test>

<https://remi-theriault.com/blog_moderation>

Visit my website here: <https://remi-theriault.com>

Support me and my work here: <https://remi-theriault.com/donate/>
