# Nice formatting of simple slopes for lm models

Extracts simple slopes from [`lm()`](https://rdrr.io/r/stats/lm.html)
model object and format for a publication-ready format.

## Usage

``` r
nice_lm_slopes(
  model,
  predictor,
  moderator,
  b.label = "b",
  standardize = FALSE,
  mod.id = TRUE,
  ci.alternative = "two.sided",
  ...
)
```

## Arguments

- model:

  The model to be formatted.

- predictor:

  The independent variable.

- moderator:

  The moderating variable.

- b.label:

  What to rename the default "b" column (e.g., to capital B if using
  standardized data for it to be converted to the Greek beta symbol in
  the
  [`nice_table()`](https://rempsyc.remi-theriault.com/reference/nice_table.md)
  function). Now attempts to automatically detect whether the variables
  were standardized, and if so, sets `b.label = "B"` automatically.
  Factor variables or dummy variables (only two numeric values) are
  ignored when checking for standardization. *This argument is now
  deprecated, please use argument `standardize` directly instead.*

- standardize:

  Logical, whether to standardize the data before refitting the model.
  If `TRUE`, automatically sets `b.label = "B"`. Defaults to `FALSE`.
  Note that if you have factor variables, these will be pseudo-betas, so
  these coefficients could be interpreted more like Cohen's *d*.

- mod.id:

  Logical. Whether to display the model number, when there is more than
  one model.

- ci.alternative:

  Alternative for the confidence interval of the sr2. It can be either
  "two.sided (the default in this package), "greater", or "less".

- ...:

  Further arguments to be passed to the
  [`lm()`](https://rdrr.io/r/stats/lm.html) function for the models.

## Value

A formatted dataframe of the simple slopes of the specified lm model,
with DV, levels of IV, degrees of freedom, regression coefficient,
t-value, p-value, and the effect size, the semi-partial correlation
squared, and its confidence interval.

## Details

The effect size, sr2 (semi-partial correlation squared, also known as
delta R2), is computed through
[effectsize::r2_semipartial](https://easystats.github.io/effectsize/reference/r2_semipartial.html).
Please read the documentation for that function, especially regarding
the interpretation of the confidence interval. In `rempsyc`, instead of
using the default one-sided alternative ("greater"), we use the
two-sided alternative.

To interpret the sr2, use
[`effectsize::interpret_r2_semipartial()`](https://easystats.github.io/effectsize/reference/interpret_omega_squared.html).

For the *easystats* equivalent, use
[`report::report()`](https://easystats.github.io/report/reference/report.html)
on the [`lm()`](https://rdrr.io/r/stats/lm.html) model object.

## See also

Checking for moderation before checking simple slopes:
[`nice_lm`](https://rempsyc.remi-theriault.com/reference/nice_lm.md),
[`nice_mod`](https://rempsyc.remi-theriault.com/reference/nice_mod.md),
[`nice_slopes`](https://rempsyc.remi-theriault.com/reference/nice_slopes.md).
Tutorial: <https://rempsyc.remi-theriault.com/articles/moderation>

## Examples

``` r
# Make and format model
model <- lm(mpg ~ gear * wt, mtcars)
nice_lm_slopes(model, predictor = "gear", moderator = "wt")
#>   Dependent Variable Predictor (+/-1 SD) df        b        t          p
#> 1                mpg       gear (LOW-wt) 28 7.540509 2.010656 0.05408136
#> 2                mpg      gear (MEAN-wt) 28 5.615951 1.943711 0.06204275
#> 3                mpg      gear (HIGH-wt) 28 3.691393 1.795568 0.08336403
#>          sr2 CI_lower   CI_upper
#> 1 0.03048448        0 0.08823243
#> 2 0.02848830        0 0.08418650
#> 3 0.02431123        0 0.07551496

# Make and format multiple models
model2 <- lm(qsec ~ gear * wt, mtcars)
my.models <- list(model, model2)
x <- nice_lm_slopes(my.models, predictor = "gear", moderator = "wt")
x
#>   Model Number Dependent Variable Predictor (+/-1 SD) df         b          t
#> 1            1                mpg       gear (LOW-wt) 28  7.540509  2.0106560
#> 2            1                mpg      gear (MEAN-wt) 28  5.615951  1.9437108
#> 3            1                mpg      gear (HIGH-wt) 28  3.691393  1.7955678
#> 4            2               qsec       gear (LOW-wt) 28 -1.933515 -0.8847558
#> 5            2               qsec      gear (MEAN-wt) 28 -1.742853 -1.0351610
#> 6            2               qsec      gear (HIGH-wt) 28 -1.552191 -1.2956736
#>            p        sr2 CI_lower   CI_upper
#> 1 0.05408136 0.03048448        0 0.08823243
#> 2 0.06204275 0.02848830        0 0.08418650
#> 3 0.08336403 0.02431123        0 0.07551496
#> 4 0.38382325 0.02280057        0 0.11642689
#> 5 0.30945179 0.03121151        0 0.14035904
#> 6 0.20566798 0.04889790        0 0.18442862
# Get interpretations
cbind(x, Interpretation = effectsize::interpret_r2_semipartial(x$sr2))
#>   Model Number Dependent Variable Predictor (+/-1 SD) df         b          t
#> 1            1                mpg       gear (LOW-wt) 28  7.540509  2.0106560
#> 2            1                mpg      gear (MEAN-wt) 28  5.615951  1.9437108
#> 3            1                mpg      gear (HIGH-wt) 28  3.691393  1.7955678
#> 4            2               qsec       gear (LOW-wt) 28 -1.933515 -0.8847558
#> 5            2               qsec      gear (MEAN-wt) 28 -1.742853 -1.0351610
#> 6            2               qsec      gear (HIGH-wt) 28 -1.552191 -1.2956736
#>            p        sr2 CI_lower   CI_upper Interpretation
#> 1 0.05408136 0.03048448        0 0.08823243          small
#> 2 0.06204275 0.02848830        0 0.08418650          small
#> 3 0.08336403 0.02431123        0 0.07551496          small
#> 4 0.38382325 0.02280057        0 0.11642689          small
#> 5 0.30945179 0.03121151        0 0.14035904          small
#> 6 0.20566798 0.04889790        0 0.18442862          small
```
