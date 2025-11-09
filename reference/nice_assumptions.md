# Easy assumptions checks

Test linear regression assumptions easily with a nice summary table.

## Usage

``` r
nice_assumptions(model)
```

## Arguments

- model:

  The [`lm()`](https://rdrr.io/r/stats/lm.html) object to be passed to
  the function.

## Value

A dataframe, with p-value results for the Shapiro-Wilk, Breusch-Pagan,
and Durbin-Watson tests, as well as a diagnostic column reporting how
many assumptions are not respected for a given model. Shapiro-Wilk is
set to NA if n \< 3 or n \> 5000.

## Details

Interpretation: (p) values \< .05 imply assumptions are not respected.
Diagnostic is how many assumptions are not respected for a given model
or variable.

## See also

Other functions useful in assumption testing:
[`nice_density`](https://rempsyc.remi-theriault.com/reference/nice_density.md),
[`nice_normality`](https://rempsyc.remi-theriault.com/reference/nice_normality.md),
[`nice_qq`](https://rempsyc.remi-theriault.com/reference/nice_qq.md),
[`nice_varplot`](https://rempsyc.remi-theriault.com/reference/nice_varplot.md),
[`nice_var`](https://rempsyc.remi-theriault.com/reference/nice_var.md).
Tutorial: <https://rempsyc.remi-theriault.com/articles/assumptions>

## Examples

``` r
# Create a regression model (using data available in R by default)
model <- lm(mpg ~ wt * cyl + gear, data = mtcars)
nice_assumptions(model)
#>                   Model Normality (Shapiro-Wilk)
#> 1 mpg ~ wt * cyl + gear                    0.615
#>   Homoscedasticity (Breusch-Pagan) Autocorrelation of residuals (Durbin-Watson)
#> 1                            0.054                                        0.525
#>   Diagnostic
#> 1          0

# Multiple dependent variables at once
model2 <- lm(qsec ~ disp + drat * carb, mtcars)
my.models <- list(model, model2)
nice_assumptions(my.models)
#>                       Model Normality (Shapiro-Wilk)
#> 1     mpg ~ wt * cyl + gear                    0.615
#> 2 qsec ~ disp + drat * carb                    0.013
#>   Homoscedasticity (Breusch-Pagan) Autocorrelation of residuals (Durbin-Watson)
#> 1                            0.054                                        0.525
#> 2                            0.947                                        0.003
#>   Diagnostic
#> 1          0
#> 2          2
```
