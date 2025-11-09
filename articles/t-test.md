# Publication-ready t-tests in R

## Getting started

This function makes it really easy to get all all your *t*-test results
in one simple, publication-ready table.

Let’s first load the demo data. This data set comes with base `R`
(meaning you have it too and can directly type this command into your
`R` console).

``` r
head(mtcars)
```

    ##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

Load the `rempsyc` package:

``` r
library(rempsyc)
```

> ***Note:*** If you haven’t installed this package yet, you will need
> to install it via the following command:
> `install.packages("rempsyc")`. Furthermore, you may be asked to
> install the following packages if you haven’t installed them already
> (you may decide to install them all now to avoid interrupting your
> workflow if you wish to follow this tutorial from beginning to end):

``` r
pkgs <- c("effectsize", "flextable", "broom", "report")
install_if_not_installed(pkgs)
```

------------------------------------------------------------------------

``` r
nice_t_test(
  data = mtcars,
  response = "mpg",
  group = "am",
  warning = FALSE
)
```

    ##   Dependent Variable         t       df           p         d  CI_lower
    ## 1                mpg -3.767123 18.33225 0.001373638 -1.477947 -2.265973
    ##     CI_upper
    ## 1 -0.6705684

> ***Note:*** This function relies on the base R `t.test` function,
> which uses the Welch t-test per default (see why here:
> <https://daniellakens.blogspot.com/2015/01/always-use-welchs-t-test-instead-of.html>).
> To use the Student t-test, simply add the following argument:
> `var.equal = TRUE`.

Now the best thing about this function is that you can put all your
dependent variables of interest in the function call and it will output
a sweet, pre-formatted table for your convenience.

``` r
t.test.results <- nice_t_test(
  data = mtcars,
  response = names(mtcars)[1:6],
  group = "am",
  warning = FALSE
)
t.test.results
```

    ##   Dependent Variable         t       df            p          d   CI_lower
    ## 1                mpg -3.767123 18.33225 1.373638e-03 -1.4779471 -2.2659732
    ## 2                cyl  3.354114 25.85363 2.464713e-03  1.2084550  0.4315895
    ## 3               disp  4.197727 29.25845 2.300413e-04  1.4452210  0.6417836
    ## 4                 hp  1.266189 18.71541 2.209796e-01  0.4943081 -0.2260463
    ## 5               drat -5.646088 27.19780 5.266742e-06 -2.0030843 -2.8592770
    ## 6                 wt  5.493905 29.23352 6.272020e-06  1.8924060  1.0300224
    ##     CI_upper
    ## 1 -0.6705684
    ## 2  1.9683142
    ## 3  2.2295594
    ## 4  1.2066995
    ## 5 -1.1245499
    ## 6  2.7329219

If we want it to look nice

``` r
my_table <- nice_table(t.test.results)
my_table
```

| Dependent Variable | t     | df    | p             | d     | 95% CI           |
|--------------------|-------|-------|---------------|-------|------------------|
| mpg                | -3.77 | 18.33 | .001\*\*      | -1.48 | \[-2.27, -0.67\] |
| cyl                | 3.35  | 25.85 | .002\*\*      | 1.21  | \[0.43, 1.97\]   |
| disp               | 4.20  | 29.26 | \< .001\*\*\* | 1.45  | \[0.64, 2.23\]   |
| hp                 | 1.27  | 18.72 | .221          | 0.49  | \[-0.23, 1.21\]  |
| drat               | -5.65 | 27.20 | \< .001\*\*\* | -2.00 | \[-2.86, -1.12\] |
| wt                 | 5.49  | 29.23 | \< .001\*\*\* | 1.89  | \[1.03, 2.73\]   |

> ***Note:*** The *d* is Cohen’s *d*, and the 95% CI is the confidence
> interval of the effect size (Cohen’s *d*). *p* is the *p*-value, *df*
> is degrees of freedom, and *t* is the *t*-value.

### Save table to Word

Let’s open (or save) it to word for use in a publication (optional).

``` r
# Open in Word
print(my_table, preview = "docx")

# Save in Word
flextable::save_as_docx(my_table, path = "t-tests.docx")
```

## Special cases

The function can be passed some of the regular arguments of the base
[`t.test()`](https://rdrr.io/r/stats/t.test.html) function. For example:

### Student t-test (instead of Welch)

``` r
nice_t_test(
  data = mtcars,
  response = "mpg",
  group = "am",
  var.equal = TRUE
) |>
  nice_table()
```

| Dependent Variable | t     | df  | p             | d     | 95% CI           |
|--------------------|-------|-----|---------------|-------|------------------|
| mpg                | -4.11 | 30  | \< .001\*\*\* | -1.48 | \[-2.27, -0.67\] |

### One-sided (instead of two-sided)

``` r
nice_t_test(
  data = mtcars,
  response = "mpg",
  group = "am",
  alternative = "less",
  warning = FALSE
) |>
  nice_table()
```

| Dependent Variable | t     | df    | p          | d     | 95% CI           |
|--------------------|-------|-------|------------|-------|------------------|
| mpg                | -3.77 | 18.33 | .001\*\*\* | -1.48 | \[-2.27, -0.67\] |

### One-sample (instead of two-sample)

``` r
nice_t_test(
  data = mtcars,
  response = "mpg",
  mu = 17,
  warning = FALSE
) |>
  nice_table()
```

| Dependent Variable | t    | df  | p        | d    | 95% CI         |
|--------------------|------|-----|----------|------|----------------|
| mpg                | 2.90 | 31  | .007\*\* | 0.51 | \[0.14, 0.88\] |

### Paired *t* test (instead of independent samples)

Note that for paired *t* tests, you need to use `paired = TRUE`, and you
also need data in “long” format rather than wide format (like for the
`ToothGrowth` data set). In this case, the `group` argument refers to
the participant ID for example, so the same group/participant is
measured several times, and thus has several rows.

``` r
nice_t_test(
  data = ToothGrowth,
  response = "len",
  group = "supp",
  paired = TRUE
) |>
  nice_table()
```

Note that R \>= 4.4.0 has stopped supporting the `paired` argument for
the formula method used internally in
[`nice_t_test()`](https://rempsyc.remi-theriault.com/reference/nice_t_test.md),
but since version `0.1.7.8`, we use a workaround for backward
compatibility.

### Multiple comparison corrections

It is also possible to correct for multiple comparisons. Note that only
a Bonferroni correction is supported at this time (which simply
multiplies the *p*-value by the number of tests). Bonferroni will
automatically correct for the number of tests.

``` r
nice_t_test(
  data = mtcars,
  response = names(mtcars)[1:6],
  group = "am",
  correction = "bonferroni",
  warning = FALSE
) |>
  nice_table()
```

| Dependent Variable | t     | df    | p             | d     | 95% CI           |
|--------------------|-------|-------|---------------|-------|------------------|
| mpg                | -3.77 | 18.33 | .008\*\*      | -1.48 | \[-2.27, -0.67\] |
| cyl                | 3.35  | 25.85 | .015\*        | 1.21  | \[0.43, 1.97\]   |
| disp               | 4.20  | 29.26 | .001\*\*      | 1.45  | \[0.64, 2.23\]   |
| hp                 | 1.27  | 18.72 | 1.326         | 0.49  | \[-0.23, 1.21\]  |
| drat               | -5.65 | 27.20 | \< .001\*\*\* | -2.00 | \[-2.86, -1.12\] |
| wt                 | 5.49  | 29.23 | \< .001\*\*\* | 1.89  | \[1.03, 2.73\]   |

## Integrations

There are other ways to do *t*-tests and format the results properly,
should you wish—for example through the `broom` and `report` packages.
Examples below.

``` r
model <- t.test(mpg ~ am, data = mtcars)
```

### `broom` table

``` r
library(broom)
(stats.table <- tidy(model, conf.int = TRUE))
```

    ## # A tibble: 1 × 10
    ##   estimate estimate1 estimate2 statistic p.value parameter conf.low conf.high
    ##      <dbl>     <dbl>     <dbl>     <dbl>   <dbl>     <dbl>    <dbl>     <dbl>
    ## 1    -7.24      17.1      24.4     -3.77 0.00137      18.3    -11.3     -3.21
    ## # ℹ 2 more variables: method <chr>, alternative <chr>

``` r
nice_table(stats.table, broom = "t.test")
```

| Method                  | Alternative | Mean 1 | Mean 2 | M1 - M2 | t     | df    | p        | 95% CI            |
|-------------------------|-------------|--------|--------|---------|-------|-------|----------|-------------------|
| Welch Two Sample t-test | two.sided   | 17.15  | 24.39  | -7.24   | -3.77 | 18.33 | .001\*\* | \[-11.28, -3.21\] |

### `report` table

``` r
library(report)
(stats.table <- as.data.frame(report(model)))
```

    ## Welch Two Sample t-test
    ## 
    ## Parameter | Group | Mean_Group1 | Mean_Group2 | Difference |          95% CI
    ## ----------------------------------------------------------------------------
    ## mpg       |    am |       17.15 |       24.39 |      -7.24 | [-11.28, -3.21]
    ## 
    ## Parameter | t(18.33) |     p |     d |          d  CI
    ## -----------------------------------------------------
    ## mpg       |    -3.77 | 0.001 | -1.76 | [-2.82, -0.67]
    ## 
    ## Alternative hypothesis: two.sided

``` r
nice_table(stats.table, report = "t.test")
```

| Parameter | Group | Mean_Group1 | Mean_Group2 | Difference | t     | 95% CI (t)        | df    | p        | Method                  | Alternative | d     | 95% CI (d)       |
|-----------|-------|-------------|-------------|------------|-------|-------------------|-------|----------|-------------------------|-------------|-------|------------------|
| mpg       | am    | 17.15       | 24.39       | -7.24      | -3.77 | \[-11.28, -3.21\] | 18.33 | .001\*\* | Welch Two Sample t-test | two.sided   | -1.76 | \[-2.82, -0.67\] |

The `report` package provides quite comprehensive tables, so one may
request an abbreviated table with the `short` argument.

``` r
nice_table(stats.table, report = "t.test", short = TRUE)
```

| Parameter | Group | t     | df    | p        | Method                  | Alternative | d     | 95% CI (d)       |
|-----------|-------|-------|-------|----------|-------------------------|-------------|-------|------------------|
| mpg       | am    | -3.77 | 18.33 | .001\*\* | Welch Two Sample t-test | two.sided   | -1.76 | \[-2.82, -0.67\] |

And there you go!

### Thanks for checking in

Make sure to check out this page again if you use the code after a time
or if you encounter errors, as I periodically update or improve the
code. Feel free to contact me for comments, questions, or requests to
improve this function at <https://github.com/rempsyc/rempsyc/issues>.
See all tutorials here: <https://remi-theriault.com/tutorials>.
