# Easy simple slopes

Easily compute simple slopes in moderation analysis, with effect sizes,
and format in publication-ready format.

## Usage

``` r
nice_slopes(
  data,
  response,
  predictor,
  moderator,
  moderator2 = NULL,
  covariates = NULL,
  b.label = "b",
  standardize = TRUE,
  mod.id = TRUE,
  ci.alternative = "two.sided",
  ...
)
```

## Arguments

- data:

  The data frame

- response:

  The dependent variable.

- predictor:

  The independent variable

- moderator:

  The moderating variable.

- moderator2:

  The second moderating variable, if applicable. At this time, the
  second moderator variable can only be a binary variable of the form
  `c(0, 1)`.

- covariates:

  The desired covariates in the model.

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

  Logical, whether to standardize the data before fitting the model. If
  TRUE, automatically sets `b.label = "B"`. Defaults to `TRUE`.

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
[`nice_mod`](https://rempsyc.remi-theriault.com/reference/nice_mod.md),
[`nice_lm`](https://rempsyc.remi-theriault.com/reference/nice_lm.md),
[`nice_lm_slopes`](https://rempsyc.remi-theriault.com/reference/nice_lm_slopes.md).
Tutorial: <https://rempsyc.remi-theriault.com/articles/moderation>

## Examples

``` r
# Make the basic table
nice_slopes(
  data = mtcars,
  response = "mpg",
  predictor = "gear",
  moderator = "wt"
)
#>   Dependent Variable Predictor (+/-1 SD) df           B          t          p
#> 1                mpg       gear (LOW-wt) 28  0.14841920  1.0767040 0.29080233
#> 2                mpg      gear (MEAN-wt) 28 -0.08718042 -0.7982999 0.43141565
#> 3                mpg      gear (HIGH-wt) 28 -0.32278004 -1.9035367 0.06729622
#>           sr2 CI_lower   CI_upper
#> 1 0.008741702        0 0.03886052
#> 2 0.004805465        0 0.02702141
#> 3 0.027322839        0 0.08179662

# Multiple dependent variables at once
nice_slopes(
  data = mtcars,
  response = c("mpg", "disp", "hp"),
  predictor = "gear",
  moderator = "wt"
)
#>   Model Number Dependent Variable Predictor (+/-1 SD) df           B          t
#> 1            1                mpg       gear (LOW-wt) 28  0.14841920  1.0767040
#> 2            1                mpg      gear (MEAN-wt) 28 -0.08718042 -0.7982999
#> 3            1                mpg      gear (HIGH-wt) 28 -0.32278004 -1.9035367
#> 4            2               disp       gear (LOW-wt) 28  0.01269680  0.0935897
#> 5            2               disp      gear (MEAN-wt) 28 -0.07488985 -0.6967831
#> 6            2               disp      gear (HIGH-wt) 28 -0.16247650 -0.9735823
#> 7            3                 hp       gear (LOW-wt) 28  0.26999235  1.3416927
#> 8            3                 hp      gear (MEAN-wt) 28  0.42308208  2.6537930
#> 9            3                 hp      gear (HIGH-wt) 28  0.57617180  2.3275656
#>            p          sr2     CI_lower    CI_upper
#> 1 0.29080233 8.741702e-03 0.0000000000 0.038860523
#> 2 0.43141565 4.805465e-03 0.0000000000 0.027021406
#> 3 0.06729622 2.732284e-02 0.0000000000 0.081796622
#> 4 0.92610159 6.397412e-05 0.0000000000 0.002570652
#> 5 0.49168336 3.546038e-03 0.0000000000 0.022301536
#> 6 0.33860037 6.922988e-03 0.0000000000 0.033253212
#> 7 0.19047626 2.892802e-02 0.0000000000 0.108167016
#> 8 0.01297126 1.131740e-01 0.0011317402 0.269289442
#> 9 0.02738736 8.705956e-02 0.0008705956 0.224382568

# Add covariates
nice_slopes(
  data = mtcars,
  response = "mpg",
  predictor = "gear",
  moderator = "wt",
  covariates = c("am", "vs")
)
#>   Dependent Variable Predictor (+/-1 SD) df          B          t          p
#> 1                mpg       gear (LOW-wt) 26  0.1404206  0.8866848 0.38337713
#> 2                mpg      gear (MEAN-wt) 26 -0.1106937 -0.8787865 0.38756663
#> 3                mpg      gear (HIGH-wt) 26 -0.3618080 -2.2493043 0.03318541
#>           sr2     CI_lower   CI_upper
#> 1 0.004540512 0.0000000000 0.02282331
#> 2 0.004459982 0.0000000000 0.02257663
#> 3 0.029218824 0.0002921882 0.07802035

# Three-way interaction (continuous moderator and binary
# second moderator required)
x <- nice_slopes(
  data = mtcars,
  response = "mpg",
  predictor = "gear",
  moderator = "wt",
  moderator2 = "am"
)
x
#>   Dependent Variable am Predictor (+/-1 SD) df           B          t
#> 1                mpg  0       gear (LOW-wt) 24  2.34802068  2.0297802
#> 2                mpg  0      gear (MEAN-wt) 24  0.54019914  2.7321453
#> 3                mpg  0      gear (HIGH-wt) 24 -1.26762239 -1.3171195
#> 4                mpg  1       gear (LOW-wt) 24 -0.25154857 -1.4054434
#> 5                mpg  1      gear (MEAN-wt) 24 -0.04783665 -0.1613202
#> 6                mpg  1      gear (HIGH-wt) 24  0.15587527  0.2795012
#>            p          sr2     CI_lower    CI_upper
#> 1 0.05360579 0.0203900917 0.0000000000 0.056598989
#> 2 0.01161625 0.0369427073 0.0003694271 0.087760631
#> 3 0.20023635 0.0085856163 0.0000000000 0.031309188
#> 4 0.17270299 0.0097757007 0.0000000000 0.034108645
#> 5 0.87319157 0.0001287948 0.0000000000 0.002840222
#> 6 0.78225488 0.0003866236 0.0000000000 0.005088286
# Get interpretations
cbind(x, Interpretation = effectsize::interpret_r2_semipartial(x$sr2))
#>   Dependent Variable am Predictor (+/-1 SD) df           B          t
#> 1                mpg  0       gear (LOW-wt) 24  2.34802068  2.0297802
#> 2                mpg  0      gear (MEAN-wt) 24  0.54019914  2.7321453
#> 3                mpg  0      gear (HIGH-wt) 24 -1.26762239 -1.3171195
#> 4                mpg  1       gear (LOW-wt) 24 -0.25154857 -1.4054434
#> 5                mpg  1      gear (MEAN-wt) 24 -0.04783665 -0.1613202
#> 6                mpg  1      gear (HIGH-wt) 24  0.15587527  0.2795012
#>            p          sr2     CI_lower    CI_upper Interpretation
#> 1 0.05360579 0.0203900917 0.0000000000 0.056598989          small
#> 2 0.01161625 0.0369427073 0.0003694271 0.087760631          small
#> 3 0.20023635 0.0085856163 0.0000000000 0.031309188     very small
#> 4 0.17270299 0.0097757007 0.0000000000 0.034108645     very small
#> 5 0.87319157 0.0001287948 0.0000000000 0.002840222     very small
#> 6 0.78225488 0.0003866236 0.0000000000 0.005088286     very small
```
