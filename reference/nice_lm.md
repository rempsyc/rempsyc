# Nice formatting of lm models

Formats output of [`lm()`](https://rdrr.io/r/stats/lm.html) model object
for a publication-ready format.

## Usage

``` r
nice_lm(
  model,
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

- b.label:

  What to rename the default "b" column (e.g., to capital B if using
  standardized data for it to be converted to the Greek beta symbol in
  the
  [nice_table](https://rempsyc.remi-theriault.com/reference/nice_table.md)
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
  [effectsize::r2_semipartial](https://easystats.github.io/effectsize/reference/r2_semipartial.html)
  function for the effect size.

## Value

A formatted dataframe of the specified lm model, with DV, IV, degrees of
freedom, regression coefficient, t-value, p-value, and the effect size,
the semi-partial correlation squared, and its confidence interval.

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

Checking simple slopes after testing for moderation:
[`nice_lm_slopes`](https://rempsyc.remi-theriault.com/reference/nice_lm_slopes.md),
[`nice_mod`](https://rempsyc.remi-theriault.com/reference/nice_mod.md),
[`nice_slopes`](https://rempsyc.remi-theriault.com/reference/nice_slopes.md).
Tutorial: <https://rempsyc.remi-theriault.com/articles/moderation>

## Examples

``` r
# Make and format model
model <- lm(mpg ~ cyl + wt * hp, mtcars)
nice_lm(model)
#>   Dependent Variable Predictor df           b          t            p
#> 1                mpg       cyl 27 -0.36523909 -0.7180977 4.788652e-01
#> 2                mpg        wt 27 -7.62748929 -5.0146028 2.928375e-05
#> 3                mpg        hp 27 -0.10839427 -3.6404181 1.136403e-03
#> 4                mpg     wt:hp 27  0.02583659  3.2329593 3.221753e-03
#>           sr2     CI_lower   CI_upper
#> 1 0.002159615 0.0000000000 0.01306786
#> 2 0.105313085 0.0089876445 0.20163853
#> 3 0.055502405 0.0005550240 0.11934768
#> 4 0.043773344 0.0004377334 0.09898662

# Make and format multiple models
model2 <- lm(qsec ~ disp + drat * carb, mtcars)
my.models <- list(model, model2)
x <- nice_lm(my.models)
x
#>   Model Number Dependent Variable Predictor df            b          t
#> 1            1                mpg       cyl 27 -0.365239089 -0.7180977
#> 2            1                mpg        wt 27 -7.627489287 -5.0146028
#> 3            1                mpg        hp 27 -0.108394273 -3.6404181
#> 4            1                mpg     wt:hp 27  0.025836594  3.2329593
#> 5            2               qsec      disp 27 -0.006222635 -1.9746464
#> 6            2               qsec      drat 27  0.227692395  0.1968842
#> 7            2               qsec      carb 27  1.154106215  0.7179431
#> 8            2               qsec drat:carb 27 -0.477539959 -1.0825727
#>              p          sr2     CI_lower   CI_upper
#> 1 4.788652e-01 0.0021596150 0.0000000000 0.01306786
#> 2 2.928375e-05 0.1053130854 0.0089876445 0.20163853
#> 3 1.136403e-03 0.0555024045 0.0005550240 0.11934768
#> 4 3.221753e-03 0.0437733438 0.0004377334 0.09898662
#> 5 5.861684e-02 0.0702566891 0.0000000000 0.19796621
#> 6 8.453927e-01 0.0006984424 0.0000000000 0.01347203
#> 7 4.789590e-01 0.0092872897 0.0000000000 0.05587351
#> 8 2.885720e-01 0.0211165564 0.0000000000 0.09136014
# Get interpretations
cbind(x, Interpretation = effectsize::interpret_r2_semipartial(x$sr2))
#>   Model Number Dependent Variable Predictor df            b          t
#> 1            1                mpg       cyl 27 -0.365239089 -0.7180977
#> 2            1                mpg        wt 27 -7.627489287 -5.0146028
#> 3            1                mpg        hp 27 -0.108394273 -3.6404181
#> 4            1                mpg     wt:hp 27  0.025836594  3.2329593
#> 5            2               qsec      disp 27 -0.006222635 -1.9746464
#> 6            2               qsec      drat 27  0.227692395  0.1968842
#> 7            2               qsec      carb 27  1.154106215  0.7179431
#> 8            2               qsec drat:carb 27 -0.477539959 -1.0825727
#>              p          sr2     CI_lower   CI_upper Interpretation
#> 1 4.788652e-01 0.0021596150 0.0000000000 0.01306786     very small
#> 2 2.928375e-05 0.1053130854 0.0089876445 0.20163853         medium
#> 3 1.136403e-03 0.0555024045 0.0005550240 0.11934768          small
#> 4 3.221753e-03 0.0437733438 0.0004377334 0.09898662          small
#> 5 5.861684e-02 0.0702566891 0.0000000000 0.19796621         medium
#> 6 8.453927e-01 0.0006984424 0.0000000000 0.01347203     very small
#> 7 4.789590e-01 0.0092872897 0.0000000000 0.05587351     very small
#> 8 2.885720e-01 0.0211165564 0.0000000000 0.09136014          small
```
