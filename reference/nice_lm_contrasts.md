# Easy planned contrasts using lm models

Easily compute planned contrast analyses (pairwise comparisons similar
to t-tests but more powerful when more than 2 groups), and format in
publication-ready format. In this particular case, the confidence
intervals are bootstraped on chosen effect size (default to Cohen's d).

## Usage

``` r
nice_lm_contrasts(
  model,
  group,
  data,
  p_adjust = "none",
  effect.type = "cohens.d",
  bootstraps = 2000,
  ...
)
```

## Arguments

- model:

  The model to be formatted.

- group:

  The group for the comparison.

- data:

  The data frame.

- p_adjust:

  Character: adjustment method (e.g., "bonferroni") – added to options

- effect.type:

  What effect size type to use. One of "cohens.d" (default),
  "akp.robust.d", "unstandardized", "hedges.g", "cohens.d.sigma", or
  "r".

- bootstraps:

  The number of bootstraps to use for the confidence interval

- ...:

  Arguments passed to
  [bootES::bootES](https://rdrr.io/pkg/bootES/man/bootES.html).

## Value

A dataframe, with the selected dependent variable(s), comparisons of
interest, degrees of freedom, t-values, p-values, Cohen's d, and the
lower and upper 95% confidence intervals of the effect size (i.e., dR).

## Details

Statistical power is lower with the standard *t* test compared than it
is with the planned contrast version for two reasons: a) the sample size
is smaller with the *t* test, because only the cases in the two groups
are selected; and b) in the planned contrast the error term is smaller
than it is with the standard *t* test because it is based on all the
cases
([source](https://web.pdx.edu/~newsomj/uvclass/ho_planned%20contrasts.pdf)).

The effect size and confidence interval are calculated via
[bootES::bootES](https://rdrr.io/pkg/bootES/man/bootES.html), and
correct for contrasts but not for covariates and other predictors.
Because this method uses bootstrapping, it is recommended to set a seed
before using for reproducibility reasons (e.g., `sed.seet(100)`).

Does not for the moment support nested comparisons for marginal means,
only a comparison of all groups. For nested comparisons, please use
[`emmeans::contrast()`](https://rvlenth.github.io/emmeans/reference/contrast.html)
directly, or for the *easystats* equivalent,
[`modelbased::estimate_contrasts()`](https://easystats.github.io/modelbased/reference/estimate_contrasts.html).

When using `nice_lm_contrasts()`, please use
[`as.factor()`](https://rdrr.io/r/base/factor.html) outside the
[`lm()`](https://rdrr.io/r/stats/lm.html) formula, or it will lead to an
error.

## See also

[`nice_contrasts`](https://rempsyc.remi-theriault.com/reference/nice_contrasts.md),
Tutorial: <https://rempsyc.remi-theriault.com/articles/contrasts>

## Examples

``` r
# Make and format model (group need to be a factor)
mtcars2 <- mtcars
mtcars2$cyl <- as.factor(mtcars2$cyl)
model <- lm(mpg ~ cyl + wt * hp, mtcars2)
set.seed(100)
nice_lm_contrasts(model, group = "cyl", data = mtcars, bootstraps = 500)
#>   Dependent Variable  Comparison df         t         p        d  CI_lower
#> 1                mpg cyl4 - cyl6 26 0.8452452 0.4056854 2.147244 1.2831781
#> 2                mpg cyl4 - cyl8 26 0.7047256 0.4872464 3.587739 2.7405544
#> 3                mpg cyl6 - cyl8 26 0.1302365 0.8973817 1.440495 0.7828333
#>   CI_upper
#> 1 2.985932
#> 2 4.582310
#> 3 1.978447

# Several models at once
mtcars2$gear <- as.factor(mtcars2$gear)
model2 <- lm(qsec ~ cyl, data = mtcars2)
my.models <- list(model, model2)
set.seed(100)
nice_lm_contrasts(my.models, group = "cyl", data = mtcars, bootstraps = 500)
#>   Dependent Variable  Comparison df         t            p         d   CI_lower
#> 1                mpg cyl4 - cyl6 26 0.8452452 0.4056854062 2.1472439  1.2831781
#> 2                mpg cyl4 - cyl8 26 0.7047256 0.4872463657 3.5877388  2.6849327
#> 3                mpg cyl6 - cyl8 26 0.1302365 0.8973817161 1.4404949  0.7982678
#> 4               qsec cyl4 - cyl6 29 1.6103903 0.1181454384 0.7786137 -0.3761605
#> 5               qsec cyl4 - cyl8 29 3.9396785 0.0004711519 1.5873417  0.8656254
#> 6               qsec cyl6 - cyl8 29 1.7470521 0.0912125385 0.8087280 -0.4254810
#>   CI_upper
#> 1 2.985932
#> 2 4.529380
#> 3 2.006210
#> 4 1.916876
#> 5 2.270826
#> 6 1.724369

# Now supports more than 3 levels
mtcars2$carb <- as.factor(mtcars2$carb)
model <- lm(mpg ~ carb + wt * hp, mtcars2)
set.seed(100)
nice_lm_contrasts(model, group = "carb", data = mtcars2, bootstraps = 500)
#> Warning: extreme order statistics used as endpoints
#>    Dependent Variable    Comparison df           t         p          d
#> 1                 mpg carb1 - carb2 23 -0.11167606 0.9120492  0.5999941
#> 2                 mpg carb1 - carb3 23 -0.11169714 0.9120326  1.8436713
#> 3                 mpg carb1 - carb4 23  0.60966169 0.5480622  1.9476509
#> 4                 mpg carb1 - carb6 23 -0.09074550 0.9284805  1.1504742
#> 5                 mpg carb1 - carb8 23 -0.43874537 0.6649399  2.1087173
#> 6                 mpg carb2 - carb3 23 -0.04660405 0.9632311  1.2436772
#> 7                 mpg carb2 - carb4 23  0.84056376 0.4092461  1.3476567
#> 8                 mpg carb2 - carb6 23 -0.04379931 0.9654424  0.5504801
#> 9                 mpg carb2 - carb8 23 -0.42623613 0.6738985  1.5087231
#> 10                mpg carb3 - carb4 23  0.73745888 0.4683007  0.1039796
#> 11                mpg carb3 - carb6 23 -0.01237567 0.9902326 -0.6931971
#> 12                mpg carb3 - carb8 23 -0.41044652 0.6852769  0.2650460
#> 13                mpg carb4 - carb6 23 -0.46023032 0.6496724 -0.7971767
#> 14                mpg carb4 - carb8 23 -0.81847254 0.4214869  0.1610664
#> 15                mpg carb6 - carb8 23 -0.35808238 0.7235472  0.9582431
#>       CI_lower   CI_upper
#> 1  -0.51694856  1.8254559
#> 2   1.02879860  2.7169111
#> 3   0.97780962  3.1942469
#> 4   0.39326638  2.2035687
#> 5   1.26010382  2.9683400
#> 6   0.46065533  1.9684140
#> 7   0.38715124  2.1885538
#> 8  -0.20539908  1.3147806
#> 9   0.67615602  2.1138626
#> 10 -0.45720063  0.5834472
#> 11 -0.89904526 -0.4788142
#> 12  0.04082518  0.4698009
#> 13 -1.34485228 -0.2904916
#> 14 -0.40209114  0.6084037
#> 15  0.80938200  1.1156342
```
