# Get group means and CIs (rcompanion::groupwiseMean)

Get group means and bootstrapped effect sizes from the
`rcompanion::groupwiseMean` function. The function had to be taken
separately from the package as the dependency is failing upon install of
the current package.

From the original documentation: "Calculates means and confidence
intervals for groups."

From: https://rcompanion.org/handbook/C_03.html

"For routine use, I recommend using bootstrapped confidence intervals,
particularly the BCa or percentile methods (but...) by default, the
function reports confidence intervals by the traditional method."

## Usage

``` r
rcompanion_groupwiseMean(
  formula = NULL,
  data = NULL,
  var = NULL,
  group = NULL,
  trim = 0,
  na.rm = FALSE,
  conf = 0.95,
  R = 5000,
  boot = FALSE,
  traditional = TRUE,
  normal = FALSE,
  basic = FALSE,
  percentile = FALSE,
  bca = FALSE,
  digits = 3,
  ...
)
```

## Arguments

- formula:

  A formula indicating the measurement variable and the grouping
  variables. e.g. y ~ x1 + x2.

- data:

  The data frame to use.

- var:

  The measurement variable to use. The name is in double quotes.

- group:

  The grouping variable to use. The name is in double quotes. Multiple
  names are listed as a vector. (See example.)

- trim:

  The proportion of observations trimmed from each end of the values
  before the mean is calculated. (As in
  [`mean()`](https://rdrr.io/r/base/mean.html))

- na.rm:

  If `TRUE`, `NA` values are removed during calculations. (As in
  [`mean()`](https://rdrr.io/r/base/mean.html))

- conf:

  The confidence interval to use.

- R:

  The number of bootstrap replicates to use for bootstrapped statistics.

- boot:

  If `TRUE`, includes the mean of the bootstrapped means. This can be
  used as an estimate of the mean for the group.

- traditional:

  If `TRUE`, includes the traditional confidence intervals for the group
  means, using the t-distribution. If `trim` is not 0, the traditional
  confidence interval will produce `NA`. Likewise, if there are `NA`
  values that are not removed, the traditional confidence interval will
  produce `NA`.

- normal:

  If `TRUE`, includes the normal confidence intervals for the group
  means by bootstrap. See `{boot::boot.ci}`.

- basic:

  If `TRUE`, includes the basic confidence intervals for the group means
  by bootstrap. See `{boot::boot.ci}`.

- percentile:

  If `TRUE`, includes the percentile confidence intervals for the group
  means by bootstrap. See `{boot::boot.ci}`.

- bca:

  If `TRUE`, includes the BCa confidence intervals for the group means
  by bootstrap. See `{boot::boot.ci}`.

- digits:

  The number of significant figures to use in output.

- ...:

  Other arguments passed to the `boot` function.

## Value

A data frame of requested statistics by group.

## Details

The input should include either `formula` and `data`; or `data`, `var`,
and `group`. (See examples).

         Results for ungrouped (one-sample) data can be obtained by either
         setting the right side of the formula to 1, e.g.  y ~ 1, or by
         setting \code{group=NULL} when using \code{var}.

## Note

The parsing of the formula is simplistic. The first variable on the left
side is used as the measurement variable. The variables on the right
side are used for the grouping variables.

         In general, it is advisable to handle \code{NA} values before
         using this function.
         With some options, the function may not handle missing values well,
         or in the manner desired by the user.
         In particular, if \code{bca=TRUE} and there are \code{NA} values,
         the function may fail.

         For a traditional method to calculate confidence intervals
         on trimmed means,
         see Rand Wilcox, Introduction to Robust Estimation and
         Hypothesis Testing.

## References

<https://rcompanion.org/handbook/C_03.html>

## Author

Salvatore Mangiafico, <mangiafico@njaes.rutgers.edu>

## Examples

``` r
# \donttest{
### Example with formula notation
data(mtcars)
rcompanion_groupwiseMean(mpg ~ factor(cyl),
  data         = mtcars,
  traditional  = FALSE,
  percentile   = TRUE
)
#>   cyl  n Mean Conf.level Percentile.lower Percentile.upper
#> 1   4 11 26.7       0.95             24.1             29.2
#> 2   6  7 19.7       0.95             18.7             20.7
#> 3   8 14 15.1       0.95             13.7             16.4

# Example with variable notation
data(mtcars)
rcompanion_groupwiseMean(
  data = mtcars,
  var = "mpg",
  group = c("cyl", "am"),
  traditional = FALSE,
  percentile = TRUE
)
#>   cyl am  n Mean Conf.level Percentile.lower Percentile.upper
#> 1   4  0  3 22.9       0.95             21.5             24.4
#> 2   4  1  8 28.1       0.95             25.0             30.9
#> 3   6  0  4 19.1       0.95             18.0             20.6
#> 4   6  1  3 20.6       0.95             19.7             21.0
#> 5   8  0 12 15.0       0.95             13.5             16.5
#> 6   8  1  2 15.4       0.95             15.0             15.8
# }
```
