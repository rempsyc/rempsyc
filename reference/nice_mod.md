# Easy moderations

Easily compute moderation analyses, with effect sizes, and format in
publication-ready format.

## Usage

``` r
nice_mod(
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

  The independent variable.

- moderator:

  The moderating variable.

- moderator2:

  The second moderating variable, if applicable.

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
  `TRUE`, automatically sets `b.label = "B"`. Defaults to `TRUE`.

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
[`nice_slopes`](https://rempsyc.remi-theriault.com/reference/nice_slopes.md),
[`nice_lm`](https://rempsyc.remi-theriault.com/reference/nice_lm.md),
[`nice_lm_slopes`](https://rempsyc.remi-theriault.com/reference/nice_lm_slopes.md).
Tutorial: <https://rempsyc.remi-theriault.com/articles/moderation>

## Examples

``` r
# Make the basic table
nice_mod(
  data = mtcars,
  response = "mpg",
  predictor = "gear",
  moderator = "wt"
)
#>   Dependent Variable Predictor df           B          t            p
#> 1                mpg      gear 28 -0.08718042 -0.7982999 4.314156e-01
#> 2                mpg        wt 28 -0.94959988 -8.6037724 2.383144e-09
#> 3                mpg   gear:wt 28 -0.23559962 -2.1551077 3.989970e-02
#>           sr2     CI_lower   CI_upper
#> 1 0.004805465 0.0000000000 0.02702141
#> 2 0.558188818 0.3142326391 0.80214500
#> 3 0.035022025 0.0003502202 0.09723370

# Multiple dependent variables at once
nice_mod(
  data = mtcars,
  response = c("mpg", "disp", "hp"),
  predictor = "gear",
  moderator = "wt"
)
#>   Model Number Dependent Variable Predictor df           B          t
#> 1            1                mpg      gear 28 -0.08718042 -0.7982999
#> 2            1                mpg        wt 28 -0.94959988 -8.6037724
#> 3            1                mpg   gear:wt 28 -0.23559962 -2.1551077
#> 4            2               disp      gear 28 -0.07488985 -0.6967831
#> 5            2               disp        wt 28  0.83273987  7.6662883
#> 6            2               disp   gear:wt 28 -0.08758665 -0.8140664
#> 7            3                 hp      gear 28  0.42308208  2.6537930
#> 8            3                 hp        wt 28  0.92572761  5.7454866
#> 9            3                 hp   gear:wt 28  0.15308972  0.9592587
#>              p         sr2     CI_lower   CI_upper
#> 1 4.314156e-01 0.004805465 0.0000000000 0.02702141
#> 2 2.383144e-09 0.558188818 0.3142326391 0.80214500
#> 3 3.989970e-02 0.035022025 0.0003502202 0.09723370
#> 4 4.916834e-01 0.003546038 0.0000000000 0.02230154
#> 5 2.373171e-08 0.429258143 0.1916386492 0.66687764
#> 6 4.224765e-01 0.004840251 0.0000000000 0.02679265
#> 7 1.297126e-02 0.113174016 0.0011317402 0.26928944
#> 8 3.637782e-06 0.530476631 0.2928664478 0.76808681
#> 9 3.456390e-01 0.014787139 0.0000000000 0.07139000

# Add covariates
nice_mod(
  data = mtcars,
  response = "mpg",
  predictor = "gear",
  moderator = "wt",
  covariates = c("am", "vs")
)
#>   Dependent Variable Predictor df          B          t            p
#> 1                mpg      gear 26 -0.1106937 -0.8787865 3.875666e-01
#> 2                mpg        wt 26 -0.6977072 -5.0686874 2.803684e-05
#> 3                mpg        am 26  0.1306864  0.8569286 3.993141e-01
#> 4                mpg        vs 26  0.3192472  3.2441426 3.228614e-03
#> 5                mpg   gear:wt 26 -0.2511143 -2.5615471 1.656773e-02
#>           sr2     CI_lower   CI_upper
#> 1 0.004459982 0.0000000000 0.02257663
#> 2 0.148373834 0.0198201790 0.27692749
#> 3 0.004240876 0.0000000000 0.02189819
#> 4 0.060780767 0.0006078077 0.13504910
#> 5 0.037894048 0.0003789405 0.09436130

# Three-way interaction
x <- nice_mod(
  data = mtcars,
  response = "mpg",
  predictor = "gear",
  moderator = "wt",
  moderator2 = "am"
)
x
#>   Dependent Variable  Predictor df          B         t           p         sr2
#> 1                mpg       gear 24  0.3013096  1.791291 0.085867454 0.015880099
#> 2                mpg         wt 24 -1.9824141 -3.296782 0.003035645 0.053790002
#> 3                mpg         am 24 -0.3381137 -1.431537 0.165170887 0.010142070
#> 4                mpg    gear:wt 24 -0.9906361 -1.567980 0.129977525 0.012167517
#> 5                mpg    gear:am 24 -0.2934245 -1.649909 0.111990122 0.013472278
#> 6                mpg      wt:am 24  0.2636573  0.499489 0.621983258 0.001234733
#> 7                mpg gear:wt:am 24  1.0037369  1.854357 0.076016767 0.017017980
#>    CI_lower    CI_upper
#> 1 0.0000000 0.047441438
#> 2 0.0005379 0.117448925
#> 3 0.0000000 0.034953502
#> 4 0.0000000 0.039504439
#> 5 0.0000000 0.042345492
#> 6 0.0000000 0.009659682
#> 7 0.0000000 0.049794162
# Get interpretations
cbind(x, Interpretation = effectsize::interpret_r2_semipartial(x$sr2))
#>   Dependent Variable  Predictor df          B         t           p         sr2
#> 1                mpg       gear 24  0.3013096  1.791291 0.085867454 0.015880099
#> 2                mpg         wt 24 -1.9824141 -3.296782 0.003035645 0.053790002
#> 3                mpg         am 24 -0.3381137 -1.431537 0.165170887 0.010142070
#> 4                mpg    gear:wt 24 -0.9906361 -1.567980 0.129977525 0.012167517
#> 5                mpg    gear:am 24 -0.2934245 -1.649909 0.111990122 0.013472278
#> 6                mpg      wt:am 24  0.2636573  0.499489 0.621983258 0.001234733
#> 7                mpg gear:wt:am 24  1.0037369  1.854357 0.076016767 0.017017980
#>    CI_lower    CI_upper Interpretation
#> 1 0.0000000 0.047441438          small
#> 2 0.0005379 0.117448925          small
#> 3 0.0000000 0.034953502          small
#> 4 0.0000000 0.039504439          small
#> 5 0.0000000 0.042345492          small
#> 6 0.0000000 0.009659682     very small
#> 7 0.0000000 0.049794162          small
```
