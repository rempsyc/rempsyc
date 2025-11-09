# Publication-ready APA tables: from R to Word in 2 min

## Basic idea

My previous workflow was pretty tedious, as after preparing tables in R
(data frames), I would export them to Excel, then copy from Excel into
Word, and finally format the table in Word. Whenever I would make minor
changes, it would take quite a bit of time to repeat these steps.

Fortunately, I found a package that suits my needs nicely, `flextable`.
However, I only really need my tables in APA style 7th edition (Times
New Roman size 12, only some horizontal lines, double-spaced, right
number of decimals, etc.), so I made a function just with the default
settings I like to simplify my life.

There are many existing options for APA tables. Most of them however
will prebuild tables for you only for specific analyses or contexts and
provide little flexibility (or yet won’t export to Word). If you need to
build your own tables and require more flexibility, read on!

### Getting started

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
pkgs <- c("flextable", "broom", "report", "effectsize")
install_if_not_installed(pkgs)
```

------------------------------------------------------------------------

The function can be used on almost any dataframe (though it does not
allow duplicate column names). Here’s a simple example using the
`mtcars` dataset, which comes with base `R` (meaning you can try this
example too without downloading anything).

``` r
nice_table(
  mtcars[1:3, ],
  title = c("Table 1", "Motor Trend Car Road Tests"),
  note = c(
    "The data was extracted from the 1974 Motor Trend US magazine.",
    "* p < .05, ** p < .01, *** p < .001"
  )
)
```

| Table 1                                                             |      |        |        |      |      |       |      |      |      |      |
|---------------------------------------------------------------------|------|--------|--------|------|------|-------|------|------|------|------|
| Motor Trend Car Road Tests                                          |      |        |        |      |      |       |      |      |      |      |
| mpg                                                                 | cyl  | disp   | hp     | drat | wt   | qsec  | vs   | am   | gear | carb |
| 21.00                                                               | 6.00 | 160.00 | 110.00 | 3.90 | 2.62 | 16.46 | 0.00 | 1.00 | 4.00 | 4.00 |
| 21.00                                                               | 6.00 | 160.00 | 110.00 | 3.90 | 2.88 | 17.02 | 0.00 | 1.00 | 4.00 | 4.00 |
| 22.80                                                               | 4.00 | 108.00 | 93.00  | 3.85 | 2.32 | 18.61 | 1.00 | 1.00 | 4.00 | 1.00 |
| Note. The data was extracted from the 1974 Motor Trend US magazine. |      |        |        |      |      |       |      |      |      |      |
| \* p \< .05, \*\* p \< .01, \*\*\* p \< .001                        |      |        |        |      |      |       |      |      |      |      |

## Publication-ready tables

Let’s setup a more ‘credible’ table with actual statistics for
demonstration. We would normally need a bit of complicated code to
extract some relevant statistical information and create a dataframe
that suits our needs.

### Custom table

``` r
# Standardize variables to get standardized coefficients
mtcars.std <- lapply(mtcars, scale)
# Create a simple linear model
model <- lm(mpg ~ cyl + wt * hp, mtcars.std)
# Gather summary statistics
stats.table <- as.data.frame(summary(model)$coefficients)
# Get the confidence interval (CI) of the regression coefficient
CI <- confint(model)
# Add a row to join the variables names and CI to the stats
stats.table <- cbind(row.names(stats.table), stats.table, CI)
# Rename the columns appropriately
names(stats.table) <- c("Term", "B", "SE", "t", "p", "CI_lower", "CI_upper")
```

The dataframe looks like this (notice the large number of decimals):

``` r
stats.table
```

    ##                    Term          B         SE          t            p
    ## (Intercept) (Intercept) -0.1835269 0.08532112 -2.1510135 4.058431e-02
    ## cyl                 cyl -0.1082286 0.15071576 -0.7180977 4.788652e-01
    ## wt                   wt -0.6230206 0.10927573 -5.7013627 4.663587e-06
    ## hp                   hp -0.2874898 0.11955935 -2.4045781 2.331865e-02
    ## wt:hp             wt:hp  0.2875867 0.08895462  3.2329593 3.221753e-03
    ##               CI_lower     CI_upper
    ## (Intercept) -0.3585914 -0.008462403
    ## cyl         -0.4174718  0.201014550
    ## wt          -0.8472358 -0.398805290
    ## hp          -0.5328053 -0.042174267
    ## wt:hp        0.1050669  0.470106453

Now we can apply our function!

``` r
nice_table(stats.table)
```

| Term        | b\*   | SE   | t     | p             | 95% CI           |
|-------------|-------|------|-------|---------------|------------------|
| (Intercept) | -0.18 | 0.09 | -2.15 | .041\*        | \[-0.36, -0.01\] |
| cyl         | -0.11 | 0.15 | -0.72 | .479          | \[-0.42, 0.20\]  |
| wt          | -0.62 | 0.11 | -5.70 | \< .001\*\*\* | \[-0.85, -0.40\] |
| hp          | -0.29 | 0.12 | -2.40 | .023\*        | \[-0.53, -0.04\] |
| wt × hp     | 0.29  | 0.09 | 3.23  | .003\*\*      | \[0.11, 0.47\]   |

Next, we can save the flextable as an object, which we can later further
edit, view, or export to another software (e.g., Microsoft Word).

``` r
my_table <- nice_table(stats.table)
```

> Breaking news! APA 7th edition actually advises against using beta (β)
> to represent standardized coefficients, but instead suggests to use a
> lowercase italic b followed by an asterisk: *b*\*. `rempsyc` will
> follow this APA recommendation with version `0.1.6.1` and going
> forward.

### Opening/Saving table to Word

One can easily open the table in Word for quick copy-pasting.

``` r
print(my_table, preview = "docx")
```

Alternatively, one can save the table to Word by specifying the object
name and desired path.

``` r
flextable::save_as_docx(my_table, path = "nice_tablehere.docx")
```

Simply change the path to where you would like to save it. If you
copy-paste your path name, remember to use “R” slashes (‘/’ rather than
‘\\). Also remember to specify the file name and its .docx extension.

That’s it! Simple eh?

------------------------------------------------------------------------

### Statistical formatting

Notice that if you provide the `CI_lower` and `CI_upper` column names,
it will automatically and properly format your confidence interval
column and remove the lower and upper bound columns.

You can also see that it automatically formats the df, b, t, and p
values to italic. It also correctly rounded each row, and formatted p
values as \< .001 and stripped the leading zeros (it will do the same
for correlations r, R2, sr2).

> Note: in order for this to work automatically, your columns must be
> named correctly. Currently the function will make the following
> conversions: p, t, SE, SD, M, W, N, n, z, F, b, r, and df to italic;
> R2 and sr2 to italic squared, dR to italic R subscript, np2 to italic
> η subscript-p squared, ges to italic η subscript-G squared, and B to
> *b*\* (and to β in version \<= 0.1.6). Not seeing a symbol that should
> be there? Contact me and I’ll add it!

Let’s test this by simply changing our dataframe names for the exercise.

``` r
test <- head(mtcars, 3)
names(test) <- c("dR", "N", "M", "SD", "W", "np2", "ges", "z", "r", "R2", "sr2")
test[, 10:11] <- test[, 10:11] / 10
nice_table(test)
```

| dR    | N   | M     | SD    | W    | ηp2  | ηG2   | z    | r   | R2  | sr2 |
|-------|-----|-------|-------|------|------|-------|------|-----|-----|-----|
| 21.00 | 6   | 160.0 | 110.0 | 3.90 | 2.62 | 16.46 | 0.00 | 1.0 | .40 | .40 |
| 21.00 | 6   | 160.0 | 110.0 | 3.90 | 2.88 | 17.02 | 0.00 | 1.0 | .40 | .40 |
| 22.80 | 4   | 108.0 | 93.0  | 3.85 | 2.32 | 18.61 | 1.00 | 1.0 | .40 | .10 |

### Highlighting

You can also add an argument to highlight significant results for better
visual discrimination, if you wish so.

``` r
nice_table(stats.table, highlight = TRUE)
```

| Term        | b\*   | SE   | t     | p             | 95% CI           |
|-------------|-------|------|-------|---------------|------------------|
| (Intercept) | -0.18 | 0.09 | -2.15 | .041\*        | \[-0.36, -0.01\] |
| cyl         | -0.11 | 0.15 | -0.72 | .479          | \[-0.42, 0.20\]  |
| wt          | -0.62 | 0.11 | -5.70 | \< .001\*\*\* | \[-0.85, -0.40\] |
| hp          | -0.29 | 0.12 | -2.40 | .023\*        | \[-0.53, -0.04\] |
| wt × hp     | 0.29  | 0.09 | 3.23  | .003\*\*      | \[0.11, 0.47\]   |

> **Pro tip**: You can instead provide the `highlight` argument with a
> numeric value to set whatever critical *p*-value check you want, like
> `highlight = .10`, for “marginally significant” results, or
> `highlight = .01` if you want to be more conservative.

``` r
nice_table(stats.table, highlight = .01)
```

| Term        | b\*   | SE   | t     | p             | 95% CI           |
|-------------|-------|------|-------|---------------|------------------|
| (Intercept) | -0.18 | 0.09 | -2.15 | .041\*        | \[-0.36, -0.01\] |
| cyl         | -0.11 | 0.15 | -0.72 | .479          | \[-0.42, 0.20\]  |
| wt          | -0.62 | 0.11 | -5.70 | \< .001\*\*\* | \[-0.85, -0.40\] |
| hp          | -0.29 | 0.12 | -2.40 | .023\*        | \[-0.53, -0.04\] |
| wt × hp     | 0.29  | 0.09 | 3.23  | .003\*\*      | \[0.11, 0.47\]   |

To remove the more traditional significance asterisks, you can set the
`stars` argument to `FALSE`.

``` r
nice_table(stats.table, stars = FALSE)
```

| Term        | b\*   | SE   | t     | p       | 95% CI           |
|-------------|-------|------|-------|---------|------------------|
| (Intercept) | -0.18 | 0.09 | -2.15 | .041    | \[-0.36, -0.01\] |
| cyl         | -0.11 | 0.15 | -0.72 | .479    | \[-0.42, 0.20\]  |
| wt          | -0.62 | 0.11 | -5.70 | \< .001 | \[-0.85, -0.40\] |
| hp          | -0.29 | 0.12 | -2.40 | .023    | \[-0.53, -0.04\] |
| wt × hp     | 0.29  | 0.09 | 3.23  | .003    | \[0.11, 0.47\]   |

## Integrations

Making your own table manually may be intimidating at first.
Fortunately, this function integrates nicely with the `broom` and
`report` packages. So we can also skip the complicated code if one is OK
with using the default `broom`/`report` output. This requires specifying
the type of model in the function’s `broom`/`report` argument (supported
options are `lm`, `t.test`, `cor.test` and `wilcox.test`). We go through
an example of each below.

### `broom` table

``` r
library(broom)
model <- lm(mpg ~ cyl + wt * hp, mtcars)
(stats.table <- tidy(model, conf.int = TRUE))
```

    ## # A tibble: 5 × 7
    ##   term        estimate std.error statistic  p.value  conf.low conf.high
    ##   <chr>          <dbl>     <dbl>     <dbl>    <dbl>     <dbl>     <dbl>
    ## 1 (Intercept)  49.5      3.66       13.5   1.58e-13  42.0       57.0   
    ## 2 cyl          -0.365    0.509      -0.718 4.79e- 1  -1.41       0.678 
    ## 3 wt           -7.63     1.52       -5.01  2.93e- 5 -10.7       -4.51  
    ## 4 hp           -0.108    0.0298     -3.64  1.14e- 3  -0.169     -0.0473
    ## 5 wt:hp         0.0258   0.00799     3.23  3.22e- 3   0.00944    0.0422

``` r
nice_table(stats.table, broom = "lm")
```

| Term        | b     | SE   | t     | p             | 95% CI            |
|-------------|-------|------|-------|---------------|-------------------|
| (Intercept) | 49.49 | 3.66 | 13.51 | \< .001\*\*\* | \[41.97, 57.01\]  |
| cyl         | -0.37 | 0.51 | -0.72 | .479          | \[-1.41, 0.68\]   |
| wt          | -7.63 | 1.52 | -5.01 | \< .001\*\*\* | \[-10.75, -4.51\] |
| hp          | -0.11 | 0.03 | -3.64 | .001\*\*      | \[-0.17, -0.05\]  |
| wt × hp     | 0.03  | 0.01 | 3.23  | .003\*\*      | \[0.01, 0.04\]    |

### `report` table

``` r
library(report)
model <- lm(mpg ~ cyl + wt * hp, mtcars)
(stats.table <- report_table(model))
```

    ## Parameter   | Coefficient |          95% CI | t(27) |      p | Std. Coef.
    ## -------------------------------------------------------------------------
    ## (Intercept) |       49.49 | [ 41.97, 57.01] | 13.51 | < .001 |      -0.18
    ## cyl         |       -0.37 | [ -1.41,  0.68] | -0.72 | 0.479  |      -0.11
    ## wt          |       -7.63 | [-10.75, -4.51] | -5.01 | < .001 |      -0.62
    ## hp          |       -0.11 | [ -0.17, -0.05] | -3.64 | 0.001  |      -0.29
    ## wt × hp     |        0.03 | [  0.01,  0.04] |  3.23 | 0.003  |       0.29
    ##             |             |                 |       |        |           
    ## AIC         |             |                 |       |        |           
    ## AICc        |             |                 |       |        |           
    ## BIC         |             |                 |       |        |           
    ## R2          |             |                 |       |        |           
    ## R2 (adj.)   |             |                 |       |        |           
    ## Sigma       |             |                 |       |        |           
    ## 
    ## Parameter   | Std. Coef. 95% CI |    Fit
    ## ----------------------------------------
    ## (Intercept) |    [-0.36, -0.01] |       
    ## cyl         |    [-0.42,  0.20] |       
    ## wt          |    [-0.85, -0.40] |       
    ## hp          |    [-0.53, -0.04] |       
    ## wt × hp     |    [ 0.11,  0.47] |       
    ##             |                   |       
    ## AIC         |                   | 147.01
    ## AICc        |                   | 150.37
    ## BIC         |                   | 155.80
    ## R2          |                   |   0.89
    ## R2 (adj.)   |                   |   0.87
    ## Sigma       |                   |   2.17

``` r
nice_table(stats.table, report = "lm")
```

| Parameter   | Fit    | b     | 95% CI (b)        | t     | df  | p             | b\*   | 95% CI (b\*)     |
|-------------|--------|-------|-------------------|-------|-----|---------------|-------|------------------|
| (Intercept) |        | 49.49 | \[41.97, 57.01\]  | 13.51 | 27  | \< .001\*\*\* | -0.18 | \[-0.36, -0.01\] |
| cyl         |        | -0.37 | \[-1.41, 0.68\]   | -0.72 | 27  | .479          | -0.11 | \[-0.42, 0.20\]  |
| wt          |        | -7.63 | \[-10.75, -4.51\] | -5.01 | 27  | \< .001\*\*\* | -0.62 | \[-0.85, -0.40\] |
| hp          |        | -0.11 | \[-0.17, -0.05\]  | -3.64 | 27  | .001\*\*      | -0.29 | \[-0.53, -0.04\] |
| wt × hp     |        | 0.03  | \[0.01, 0.04\]    | 3.23  | 27  | .003\*\*      | 0.29  | \[0.11, 0.47\]   |
|             |        |       |                   |       |     |               |       |                  |
| AIC         | 147.01 |       |                   |       |     |               |       |                  |
| AICc        | 150.37 |       |                   |       |     |               |       |                  |
| BIC         | 155.80 |       |                   |       |     |               |       |                  |
| R2          | 0.89   |       |                   |       |     |               |       |                  |
| R2 (adj.)   | 0.87   |       |                   |       |     |               |       |                  |
| Sigma       | 2.17   |       |                   |       |     |               |       |                  |

The `report` package provides quite comprehensive tables, so one may
request an abbreviated table with the `short` argument.

``` r
nice_table(stats.table, report = "lm", short = TRUE)
```

| Parameter   | b     | t     | df  | p             | b\*   | 95% CI (b\*)     |
|-------------|-------|-------|-----|---------------|-------|------------------|
| (Intercept) | 49.49 | 13.51 | 27  | \< .001\*\*\* | -0.18 | \[-0.36, -0.01\] |
| cyl         | -0.37 | -0.72 | 27  | .479          | -0.11 | \[-0.42, 0.20\]  |
| wt          | -7.63 | -5.01 | 27  | \< .001\*\*\* | -0.62 | \[-0.85, -0.40\] |
| hp          | -0.11 | -3.64 | 27  | .001\*\*      | -0.29 | \[-0.53, -0.04\] |
| wt × hp     | 0.03  | 3.23  | 27  | .003\*\*      | 0.29  | \[0.11, 0.47\]   |

### `rempsyc` table

`nice_table` also integrates nicely with other functions from the
`rempsyc` package:
[`nice_t_test`](https://rempsyc.remi-theriault.com/articles/t-test.md),
[`nice_mod`, `nice_slopes`, `nice_lm`, and
`nice_lm_slopes`](https://rempsyc.remi-theriault.com/articles/moderation.md),
because they provide good default formats that include effect sizes.
Let’s make a quick demo for some of them. The t-test function supports
making several t-tests at once by specifying the desired dependent
variables.

#### t-tests: [`nice_t_test`](https://rempsyc.remi-theriault.com/articles/t-test.md)

``` r
stats.table <- nice_t_test(
  data = mtcars,
  response = c("mpg", "disp", "drat"),
  group = "am",
  warning = FALSE
)
stats.table
```

    ##   Dependent Variable         t       df            p         d   CI_lower
    ## 1                mpg -3.767123 18.33225 1.373638e-03 -1.477947 -2.2659732
    ## 2               disp  4.197727 29.25845 2.300413e-04  1.445221  0.6417836
    ## 3               drat -5.646088 27.19780 5.266742e-06 -2.003084 -2.8592770
    ##     CI_upper
    ## 1 -0.6705684
    ## 2  2.2295594
    ## 3 -1.1245499

``` r
nice_table(stats.table)
```

| Dependent Variable | t     | df    | p             | d     | 95% CI           |
|--------------------|-------|-------|---------------|-------|------------------|
| mpg                | -3.77 | 18.33 | .001\*\*      | -1.48 | \[-2.27, -0.67\] |
| disp               | 4.20  | 29.26 | \< .001\*\*\* | 1.45  | \[0.64, 2.23\]   |
| drat               | -5.65 | 27.20 | \< .001\*\*\* | -2.00 | \[-2.86, -1.12\] |

#### Moderations: [`nice_mod`](https://rempsyc.remi-theriault.com/articles/moderation.md)

``` r
stats.table <- nice_mod(
  data = mtcars,
  response = "mpg",
  predictor = "gear",
  moderator = "wt"
)
stats.table
```

    ##   Dependent Variable Predictor df           B          t            p
    ## 1                mpg      gear 28 -0.08718042 -0.7982999 4.314156e-01
    ## 2                mpg        wt 28 -0.94959988 -8.6037724 2.383144e-09
    ## 3                mpg   gear:wt 28 -0.23559962 -2.1551077 3.989970e-02
    ##           sr2     CI_lower   CI_upper
    ## 1 0.004805465 0.0000000000 0.02702141
    ## 2 0.558188818 0.3142326391 0.80214500
    ## 3 0.035022025 0.0003502202 0.09723370

``` r
nice_table(stats.table)
```

| Dependent Variable | Predictor | df  | b\*   | t     | p             | sr2 | 95% CI         |
|--------------------|-----------|-----|-------|-------|---------------|-----|----------------|
| mpg                | gear      | 28  | -0.09 | -0.80 | .431          | .00 | \[0.00, 0.03\] |
|                    | wt        | 28  | -0.95 | -8.60 | \< .001\*\*\* | .56 | \[0.31, 0.80\] |
|                    | gear × wt | 28  | -0.24 | -2.16 | .040\*        | .04 | \[0.00, 0.10\] |

## Custom cell formatting

In some cases, one may want to define specific formatting for specific
columns. For example, one may be building a table full of *p*-values and
may want them formatted as such (or just the appropriate columns).

### *p*-values

``` r
nice_table(test[8:11], col.format.p = 1:4)
```

| z             | r    | R2   | sr2  |
|---------------|------|------|------|
| \< .001\*\*\* | 1.00 | .400 | .400 |
| \< .001\*\*\* | 1.00 | .400 | .400 |
| 1.00          | 1.00 | .400 | .100 |

### *r*-values

The same goes for *r*-values. As you see below, you can also overwrite
automatic default formatting.

``` r
nice_table(test[8:11], col.format.r = 1:4)
```

| z   | r   | R2  | sr2 |
|-----|-----|-----|-----|
| .00 | 1.0 | .40 | .40 |
| .00 | 1.0 | .40 | .40 |
| 1.0 | 1.0 | .40 | .10 |

### Custom functions

And one can even provide a custom function:

``` r
fun <- function(x) {
  x + 11.1
}

nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
```

| z    | r    | R2   | sr2  |
|------|------|------|------|
| 0.00 | 12.1 | 11.5 | 11.5 |
| 0.00 | 12.1 | 11.5 | 11.5 |
| 1.00 | 12.1 | 11.5 | 11.2 |

``` r
fun <- function(x) {
  paste("×", x)
}

nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
```

| z    | r   | R2    | sr2   |
|------|-----|-------|-------|
| 0.00 | × 1 | × 0.4 | × 0.4 |
| 0.00 | × 1 | × 0.4 | × 0.4 |
| 1.00 | × 1 | × 0.4 | × 0.1 |

``` r
fun <- function(x) {
  formatC(x, format = "f", digits = 0)
}

nice_table(test[3:6], col.format.custom = 1:4, format.custom = "fun")
```

| M   | SD  | W   | ηp2 |
|-----|-----|-----|-----|
| 160 | 110 | 4   | 3   |
| 160 | 110 | 4   | 3   |
| 108 | 93  | 4   | 2   |

``` r
fun <- function(x) {
  formatC(x, format = "f", digits = 5)
}

nice_table(test[3:6], col.format.custom = 1:4, format.custom = "fun")
```

| M         | SD        | W       | ηp2     |
|-----------|-----------|---------|---------|
| 160.00000 | 110.00000 | 3.90000 | 2.62000 |
| 160.00000 | 110.00000 | 3.90000 | 2.87500 |
| 108.00000 | 93.00000  | 3.85000 | 2.32000 |

------------------------------------------------------------------------

## Further editing

Often, one will need to tweak a table for a particular situation. Have
no fear. This function outputs a `flextable` object, which can be
‘easily’ edited via the regular `flextable` functions. For an intro to
`flextable` functions, see: <https://davidgohel.github.io/flextable/>.

Here is the basic formatting example provided by the `flextable`
package:

``` r
library(dplyr)
library(flextable)
my_table %>%
  italic(j = 1, part = "body") %>%
  bg(bg = "gray", part = "header") %>%
  color(color = "blue", part = "header") %>%
  color(~ t > -3.5, ~ t + SE, color = "red") %>%
  bold(~ t > -3.5, ~ t + p, bold = TRUE) %>%
  set_header_labels(
    Term = "Model Term",
    B = "Standardized Beta",
    p = "p-value"
  )
```

| Model Term  | Standardized Beta | SE   | t     | p-value       | 95% CI           |
|-------------|-------------------|------|-------|---------------|------------------|
| (Intercept) | -0.18             | 0.09 | -2.15 | .041\*        | \[-0.36, -0.01\] |
| cyl         | -0.11             | 0.15 | -0.72 | .479          | \[-0.42, 0.20\]  |
| wt          | -0.62             | 0.11 | -5.70 | \< .001\*\*\* | \[-0.85, -0.40\] |
| hp          | -0.29             | 0.12 | -2.40 | .023\*        | \[-0.53, -0.04\] |
| wt × hp     | 0.29              | 0.09 | 3.23  | .003\*\*      | \[0.11, 0.47\]   |

## Special situation: multilevel headers

Some people have asked how to make multilevel descriptive level tables
with `nice_table`. There are several other ways than using this package.
It is not straightforward, but here’s my attempt for multiple time
measurements, multiple groups, and multiple dependent variables.

So assuming we have a study with several time measurements, we will make
a copy of the iris data set and pretend this is the “Time 2”. Species
will be our grouping variable. Before we can apply our simple function,
however, we have to (painstakingly) reshape the data to the proper
format.

``` r
# Setup example dataset
data <- cbind(iris[c(5, 1:3)], iris[1:3] + 1)
names(data)[-1] <- c(
  paste0("T1.", names(data[2:4])),
  paste0("T2.", names(data[2:4]))
)

# Get descriptive statistics
library(dplyr)
descriptive.data <- data %>%
  group_by(Species) %>%
  summarize(across(T1.Sepal.Length:T2.Petal.Length,
    list(m = mean, sd = sd),
    .names = "{.col}.{.fn}"
  ))

# Rename the columns so we can merge them later
names(descriptive.data) <- c(
  "Species", rep(c("T1.M", "T1.SD"), 3),
  rep(c("T2.M", "T2.SD"), 3)
)

# Extract the data by variable and measurement time
T1.disp <- cbind(
  descriptive.data[1, 2:3],
  descriptive.data[2, 2:3],
  descriptive.data[3, 2:3]
)
T1.hp <- cbind(
  descriptive.data[1, 4:5],
  descriptive.data[2, 4:5],
  descriptive.data[3, 4:5]
)
T1.drat <- cbind(
  descriptive.data[1, 6:7],
  descriptive.data[2, 6:7],
  descriptive.data[3, 6:7]
)
T2.disp <- cbind(
  descriptive.data[1, 8:9],
  descriptive.data[2, 8:9],
  descriptive.data[3, 8:9]
)
T2.hp <- cbind(
  descriptive.data[1, 10:11],
  descriptive.data[2, 10:11],
  descriptive.data[3, 10:11]
)
T2.drat <- cbind(
  descriptive.data[1, 12:13],
  descriptive.data[2, 12:13],
  descriptive.data[3, 12:13]
)

# Combine Time 1 with Time 2
T1 <- rbind(T1.disp, T1.hp, T1.drat)
T2 <- rbind(T2.disp, T2.hp, T2.drat)
wide.data <- cbind(Variable = names(iris[1:3]), T1, T2)

# Rename variables to avoid duplicate names not allowed
names(wide.data)[-1] <- paste0(
  rep(c("T1.", "T2."), each = 6),
  rep(descriptive.data$Species, times = 2, each = 2),
  paste0(c(".M", ".SD"))
)

# Make preliminary nice_table
nice_table(wide.data)
```

| Variable     | T1.setosa.M | T1.setosa.SD | T1.versicolor.M | T1.versicolor.SD | T1.virginica.M | T1.virginica.SD | T2.setosa.M | T2.setosa.SD | T2.versicolor.M | T2.versicolor.SD | T2.virginica.M | T2.virginica.SD |
|--------------|-------------|--------------|-----------------|------------------|----------------|-----------------|-------------|--------------|-----------------|------------------|----------------|-----------------|
| Sepal.Length | 5.01        | 0.35         | 5.94            | 0.52             | 6.59           | 0.64            | 6.01        | 0.35         | 6.94            | 0.52             | 7.59           | 0.64            |
| Sepal.Width  | 3.43        | 0.38         | 2.77            | 0.31             | 2.97           | 0.32            | 4.43        | 0.38         | 3.77            | 0.31             | 3.97           | 0.32            |
| Petal.Length | 1.46        | 0.17         | 4.26            | 0.47             | 5.55           | 0.55            | 2.46        | 0.17         | 5.26            | 0.47             | 6.55           | 0.55            |

So far so good; we’ve managed to transform the data in a suitable format
for the next step. Once the data is in the right shape (header
components separated by dots), we can apply our magic:

``` r
nice_table(wide.data, separate.header = TRUE, italics = seq(wide.data))
```

| Variable     | T1     |     |            |     |           |     | T2     |     |            |     |           |     |
|--------------|--------|-----|------------|-----|-----------|-----|--------|-----|------------|-----|-----------|-----|
|              | setosa |     | versicolor |     | virginica |     | setosa |     | versicolor |     | virginica |     |
|              | M      | SD  | M          | SD  | M         | SD  | M      | SD  | M          | SD  | M         | SD  |
| Sepal.Length | 5.0    | 0.4 | 5.9        | 0.5 | 6.6       | 0.6 | 6.0    | 0.4 | 6.9        | 0.5 | 7.6       | 0.6 |
| Sepal.Width  | 3.4    | 0.4 | 2.8        | 0.3 | 3.0       | 0.3 | 4.4    | 0.4 | 3.8        | 0.3 | 4.0       | 0.3 |
| Petal.Length | 1.5    | 0.2 | 4.3        | 0.5 | 5.6       | 0.6 | 2.5    | 0.2 | 5.3        | 0.5 | 6.6       | 0.6 |

If you find a more efficient way to do this (the data wrangling part),
please let me know. Nice result though!

### Multilevel heading, with formatting

Another colleague asked, whether it was possible to use the multilevel
headings, while still benefiting from the regular automatic formatting
of the p-values, confidence intervals, etc. That was a challenging task
to implement, but I think I’ve got something that should *mostly* work.
Demo:

``` r
T1.mpg <- nice_t_test(data = mtcars, response = "mpg", group = "am")
T2.mpg <- nice_t_test(data = mtcars, response = "mpg", group = "vs")
T1.disp <- nice_t_test(data = mtcars, response = "disp", group = "am")
T2.disp <- nice_t_test(data = mtcars, response = "disp", group = "vs")
names(T1.mpg)[-1] <- paste0("T1.", names(T1.mpg)[-1])
names(T2.mpg) <- paste0("T2.", names(T2.mpg))
names(T1.disp)[-1] <- paste0("T1.", names(T1.disp)[-1])
names(T2.disp) <- paste0("T2.", names(T2.disp))
T1 <- rbind(T1.mpg, T1.disp)
T2 <- rbind(T2.mpg, T2.disp)
wide.data <- cbind(T1, T2[-(1)])
nice_table(wide.data)
```

| Dependent Variable | T1.t  | T1.df | T1.p | T1.d  | T1.CI_lower | T1.CI_upper | T2.t  | T2.df | T2.p | T2.d  | T2.CI_lower | T2.CI_upper |
|--------------------|-------|-------|------|-------|-------------|-------------|-------|-------|------|-------|-------------|-------------|
| mpg                | -3.77 | 18.33 | 0.00 | -1.48 | -2.27       | -0.67       | -4.67 | 22.72 | 0.00 | -1.73 | -2.55       | -0.90       |
| disp               | 4.20  | 29.26 | 0.00 | 1.45  | 0.64        | 2.23        | 5.94  | 26.98 | 0.00 | 1.97  | 1.10        | 2.82        |

``` r
nice_table(wide.data, separate.header = TRUE, stars = FALSE)
```

| Dependent Variable | T1    |       |         |       |                  | T2    |       |         |       |                  |
|--------------------|-------|-------|---------|-------|------------------|-------|-------|---------|-------|------------------|
|                    | t     | df    | p       | d     | 95% CI           | t     | df    | p       | d     | 95% CI           |
| mpg                | -3.77 | 18.33 | .001    | -1.48 | \[-2.27, -0.67\] | -4.67 | 22.72 | \< .001 | -1.73 | \[-2.55, -0.90\] |
| disp               | 4.20  | 29.26 | \< .001 | 1.45  | \[0.64, 2.23\]   | 5.94  | 26.98 | \< .001 | 1.97  | \[1.10, 2.82\]   |

Let’s test adding another level of heading for testing.

``` r
names(wide.data)[-1] <- paste0(
  rep(c("Early.", "Late."), each = 6),
  names(wide.data)[-1]
)
nice_table(wide.data)
```

| Dependent Variable | Early.T1.t | Early.T1.df | Early.T1.p | Early.T1.d | Early.T1.CI_lower | Early.T1.CI_upper | Late.T2.t | Late.T2.df | Late.T2.p | Late.T2.d | Late.T2.CI_lower | Late.T2.CI_upper |
|--------------------|------------|-------------|------------|------------|-------------------|-------------------|-----------|------------|-----------|-----------|------------------|------------------|
| mpg                | -3.77      | 18.33       | 0.00       | -1.48      | -2.27             | -0.67             | -4.67     | 22.72      | 0.00      | -1.73     | -2.55            | -0.90            |
| disp               | 4.20       | 29.26       | 0.00       | 1.45       | 0.64              | 2.23              | 5.94      | 26.98      | 0.00      | 1.97      | 1.10             | 2.82             |

``` r
nice_table(wide.data, separate.header = TRUE, stars = FALSE)
```

| Dependent Variable | Early |       |         |       |                  | Late  |       |         |       |                  |
|--------------------|-------|-------|---------|-------|------------------|-------|-------|---------|-------|------------------|
|                    | T1    |       |         |       |                  | T2    |       |         |       |                  |
|                    | t     | df    | p       | d     | 95% CI           | t     | df    | p       | d     | 95% CI           |
| mpg                | -3.77 | 18.33 | .001    | -1.48 | \[-2.27, -0.67\] | -4.67 | 22.72 | \< .001 | -1.73 | \[-2.55, -0.90\] |
| disp               | 4.20  | 29.26 | \< .001 | 1.45  | \[0.64, 2.23\]   | 5.94  | 26.98 | \< .001 | 1.97  | \[1.10, 2.82\]   |

### Thanks for checking in

Make sure to check out this page again if you use the code after a time
or if you encounter errors, as I periodically update or improve the
code. Feel free to contact me for comments, questions, or requests to
improve this function at <https://github.com/rempsyc/rempsyc/issues>.
See all tutorials here: <https://remi-theriault.com/tutorials>.
