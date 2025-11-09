# Easy t-tests

Easily compute t-test analyses, with effect sizes, and format in
publication-ready format. The 95% confidence interval is for the effect
size, Cohen's d, both provided by the `effectsize` package.

## Usage

``` r
nice_t_test(
  data,
  response,
  group = NULL,
  correction = "none",
  paired = FALSE,
  verbose = TRUE,
  ...
)
```

## Arguments

- data:

  The data frame.

- response:

  The dependent variable.

- group:

  The group for the comparison.

- correction:

  What correction for multiple comparison to apply, if any. Default is
  "none" and the only other option (for now) is "bonferroni".

- paired:

  Whether to use a paired t-test.

- verbose:

  Whether to display the Welch test warning or not.

- ...:

  Further arguments to be passed to the
  [`t.test()`](https://rdrr.io/r/stats/t.test.html) function (e.g., to
  use Student instead of Welch test, to change from two-tail to
  one-tail, or to do a paired-sample t-test instead of independent
  samples).

## Value

A formatted dataframe of the specified model, with DV, degrees of
freedom, t-value, p-value, the effect size, Cohen's d, and its 95%
confidence interval lower and upper bounds.

## Details

This function relies on the base R
[`t.test()`](https://rdrr.io/r/stats/t.test.html) function, which uses
the Welch t-test per default (see why here:
<https://daniellakens.blogspot.com/2015/01/always-use-welchs-t-test-instead-of.html>).
To use the Student t-test, simply add the following argument:
`var.equal = TRUE`.

Note that for paired *t* tests, you need to use `paired = TRUE`, and you
also need data in "long" format rather than wide format (like for the
`ToothGrowth` data set). In this case, the `group` argument refers to
the participant ID for example, so the same group/participant is
measured several times, and thus has several rows. Note also that R \>=
4.4.0 has stopped supporting the `paired` argument for the formula
method used internally here.

For the *easystats* equivalent, use:
[`report::report()`](https://easystats.github.io/report/reference/report.html)
on the [`t.test()`](https://rdrr.io/r/stats/t.test.html) object.

## See also

Tutorial: <https://rempsyc.remi-theriault.com/articles/t-test>

## Examples

``` r
# Make the basic table
nice_t_test(
  data = mtcars,
  response = "mpg",
  group = "am"
)
#> Using independent samples t-test. 
#>  
#> Using Welch t-test (base R's default; cf. https://doi.org/10.5334/irsp.82).
#> For the Student t-test, use `var.equal = TRUE`. 
#>  
#>   Dependent Variable         t       df           p         d  CI_lower
#> 1                mpg -3.767123 18.33225 0.001373638 -1.477947 -2.265973
#>     CI_upper
#> 1 -0.6705684

# Multiple dependent variables at once
nice_t_test(
  data = mtcars,
  response = names(mtcars)[1:7],
  group = "am"
)
#> Using independent samples t-test. 
#>  
#> Using Welch t-test (base R's default; cf. https://doi.org/10.5334/irsp.82).
#> For the Student t-test, use `var.equal = TRUE`. 
#>  
#>   Dependent Variable         t       df            p          d   CI_lower
#> 1                mpg -3.767123 18.33225 1.373638e-03 -1.4779471 -2.2659732
#> 2                cyl  3.354114 25.85363 2.464713e-03  1.2084550  0.4315895
#> 3               disp  4.197727 29.25845 2.300413e-04  1.4452210  0.6417836
#> 4                 hp  1.266189 18.71541 2.209796e-01  0.4943081 -0.2260463
#> 5               drat -5.646088 27.19780 5.266742e-06 -2.0030843 -2.8592770
#> 6                 wt  5.493905 29.23352 6.272020e-06  1.8924060  1.0300224
#> 7               qsec  1.287845 25.53421 2.093498e-01  0.4656285 -0.2532864
#>     CI_upper
#> 1 -0.6705684
#> 2  1.9683142
#> 3  2.2295594
#> 4  1.2066995
#> 5 -1.1245499
#> 6  2.7329219
#> 7  1.1770177

# Can be passed some of the regular arguments
# of base [t.test()]

# Student t-test (instead of Welch)
nice_t_test(
  data = mtcars,
  response = "mpg",
  group = "am",
  var.equal = TRUE
)
#> Using Student t-test. 
#>  
#> Using independent samples t-test. 
#>  
#>   Dependent Variable         t df            p         d  CI_lower   CI_upper
#> 1                mpg -4.106127 30 0.0002850207 -1.477947 -2.265973 -0.6705684

# One-sided instead of two-sided
nice_t_test(
  data = mtcars,
  response = "mpg",
  group = "am",
  alternative = "less"
)
#> Using independent samples t-test. 
#>  
#> Using Welch t-test (base R's default; cf. https://doi.org/10.5334/irsp.82).
#> For the Student t-test, use `var.equal = TRUE`. 
#>  
#>   Dependent Variable         t       df            p         d  CI_lower
#> 1                mpg -3.767123 18.33225 0.0006868192 -1.477947 -2.265973
#>     CI_upper
#> 1 -0.6705684

# One-sample t-test
nice_t_test(
  data = mtcars,
  response = "mpg",
  mu = 10
)
#> Using independent samples t-test. 
#>  
#> Using Welch t-test (base R's default; cf. https://doi.org/10.5334/irsp.82).
#> For the Student t-test, use `var.equal = TRUE`. 
#>  
#> Using one-sample t-test. 
#>  
#>   Dependent Variable        t df            p        d CI_lower CI_upper
#> 1                mpg 9.470995 31 1.154598e-10 1.674251  1.12797 2.208995

# Make sure cases appear in the same order for
# both levels of the grouping factor
```
