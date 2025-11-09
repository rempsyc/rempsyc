# Easy planned contrasts

Easily compute planned contrast analyses (pairwise comparisons similar
to t-tests but more powerful when more than 2 groups), and format in
publication-ready format. In this particular case, the confidence
intervals are bootstraped on chosen effect size (default to Cohen's d).

## Usage

``` r
nice_contrasts(
  response,
  group,
  covariates = NULL,
  data,
  effect.type = "cohens.d",
  bootstraps = 2000,
  ...
)
```

## Arguments

- response:

  The dependent variable.

- group:

  The group for the comparison.

- covariates:

  The desired covariates in the model.

- data:

  The data frame.

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

When using
[`nice_lm_contrasts()`](https://rempsyc.remi-theriault.com/reference/nice_lm_contrasts.md),
please use [`as.factor()`](https://rdrr.io/r/base/factor.html) outside
the [`lm()`](https://rdrr.io/r/stats/lm.html) formula, or it will lead
to an error.

## See also

[`nice_lm_contrasts`](https://rempsyc.remi-theriault.com/reference/nice_lm_contrasts.md),
Tutorial: <https://rempsyc.remi-theriault.com/articles/contrasts>

## Examples

``` r
# Basic example
set.seed(100)
nice_contrasts(
  data = mtcars,
  response = "mpg",
  group = "cyl",
  bootstraps = 200
)
#> Warning: extreme order statistics used as endpoints
#> Warning: extreme order statistics used as endpoints
#>   Dependent Variable  Comparison df        t            p        d  CI_lower
#> 1                mpg cyl4 - cyl6 29 4.441099 1.194696e-04 2.147244 1.4350410
#> 2                mpg cyl4 - cyl8 29 8.904534 8.568209e-10 3.587739 2.7592293
#> 3                mpg cyl6 - cyl8 29 3.111825 4.152209e-03 1.440495 0.7548555
#>   CI_upper
#> 1 3.111226
#> 2 4.585134
#> 3 1.965225
# \donttest{
set.seed(100)
nice_contrasts(
  data = mtcars,
  response = "disp",
  group = "gear"
)
#> Warning: extreme order statistics used as endpoints
#>   Dependent Variable    Comparison df         t            p          d
#> 1               disp gear3 - gear4 29  6.385087 5.569503e-07  2.4729335
#> 2               disp gear3 - gear5 29  2.916870 6.759287e-03  1.5062653
#> 3               disp gear4 - gear5 29 -1.816053 7.971420e-02 -0.9666682
#>      CI_lower  CI_upper
#> 1  1.28321568 3.2388008
#> 2 -0.02637868 3.0140308
#> 3 -2.36542748 0.1651726

# Multiple dependent variables
set.seed(100)
nice_contrasts(
  data = mtcars,
  response = c("mpg", "disp", "hp"),
  group = "cyl"
)
#>   Dependent Variable  Comparison df          t            p         d
#> 1                mpg cyl4 - cyl6 29   4.441099 1.194696e-04  2.147244
#> 2                mpg cyl4 - cyl8 29   8.904534 8.568209e-10  3.587739
#> 3                mpg cyl6 - cyl8 29   3.111825 4.152209e-03  1.440495
#> 4               disp cyl4 - cyl6 29  -3.131986 3.945539e-03 -1.514296
#> 5               disp cyl4 - cyl8 29 -11.920787 1.064054e-12 -4.803022
#> 6               disp cyl6 - cyl8 29  -7.104461 8.117219e-08 -3.288726
#> 7                 hp cyl4 - cyl6 29  -2.162695 3.894886e-02 -1.045650
#> 8                 hp cyl4 - cyl8 29  -8.285112 3.915144e-09 -3.338167
#> 9                 hp cyl6 - cyl8 29  -4.952403 2.895434e-05 -2.292517
#>     CI_lower   CI_upper
#> 1  1.3531871  3.1223071
#> 2  2.7031569  4.5420741
#> 3  0.8485919  1.9643088
#> 4 -2.2636521 -0.8826532
#> 5 -5.7975938 -3.8538264
#> 6 -4.3208965 -2.2293026
#> 7 -1.7374299 -0.4355318
#> 8 -4.3451476 -2.3268987
#> 9 -3.1628173 -1.2854720

# Adding covariates
set.seed(100)
nice_contrasts(
  data = mtcars,
  response = "mpg",
  group = "cyl",
  covariates = c("disp", "hp")
)
#>   Dependent Variable  Comparison df          t          p        d  CI_lower
#> 1                mpg cyl4 - cyl6 27  2.3955766 0.02379338 2.147244 1.3531871
#> 2                mpg cyl4 - cyl8 27  0.7506447 0.45935889 3.587739 2.6274380
#> 3                mpg cyl6 - cyl8 27 -0.6550186 0.51799786 1.440495 0.8271079
#>   CI_upper
#> 1 3.122307
#> 2 4.464881
#> 3 1.969248

# Now supports more than 3 levels
mtcars2 <- mtcars
mtcars2$carb <- as.factor(mtcars2$carb)
set.seed(100)
nice_contrasts(
  data = mtcars,
  response = "mpg",
  group = "carb",
  bootstraps = 200
)
#> Warning: extreme order statistics used as endpoints
#> Warning: extreme order statistics used as endpoints
#> Warning: extreme order statistics used as endpoints
#> Warning: extreme order statistics used as endpoints
#>    Dependent Variable    Comparison df          t            p          d
#> 1                 mpg carb1 - carb2 26  1.2175073 0.2343463275  0.5999941
#> 2                 mpg carb1 - carb3 26  2.6717336 0.0128499280  1.8436713
#> 3                 mpg carb1 - carb4 26  3.9521705 0.0005295477  1.9476509
#> 4                 mpg carb1 - carb6 26  1.0761701 0.2917362452  1.1504742
#> 5                 mpg carb1 - carb8 26  1.9725244 0.0592726906  2.1087173
#> 6                 mpg carb2 - carb3 26  1.8892812 0.0700557269  1.2436772
#> 7                 mpg carb2 - carb4 26  3.0134521 0.0056962070  1.3476567
#> 8                 mpg carb2 - carb6 26  0.5248621 0.6041261067  0.5504801
#> 9                 mpg carb2 - carb8 26  1.4385111 0.1622188105  1.5087231
#> 10                mpg carb3 - carb4 26  0.1579563 0.8757116294  0.1039796
#> 11                mpg carb3 - carb6 26 -0.6003263 0.5534859747 -0.6931971
#> 12                mpg carb3 - carb8 26  0.2295365 0.8202480949  0.2650460
#> 13                mpg carb4 - carb6 26 -0.7600781 0.4540454635 -0.7971767
#> 14                mpg carb4 - carb8 26  0.1535708 0.8791339283  0.1610664
#> 15                mpg carb6 - carb8 26  0.6775802 0.5040233386  0.9582431
#>       CI_lower   CI_upper
#> 1  -0.58753635  1.8832370
#> 2   0.91323442  2.5895929
#> 3   1.17473694  3.1782768
#> 4   0.46551758  2.0441176
#> 5   1.37871803  2.9378103
#> 6   0.53074348  1.9087905
#> 7   0.24747918  1.9406856
#> 8  -0.29651218  1.2234544
#> 9   0.78319092  2.2808378
#> 10 -0.39581626  0.6764844
#> 11 -0.88770641 -0.4704188
#> 12  0.03915433  0.4548119
#> 13 -1.33713781 -0.2526394
#> 14 -0.35723602  0.6891545
#> 15  0.81322595  1.1278374
# }
```
