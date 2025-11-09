# Easily make nice APA tables

Make nice APA tables easily through a wrapper around the `flextable`
package with sensical defaults and automatic formatting features.

## Usage

``` r
nice_table(
  data,
  highlight = FALSE,
  stars = TRUE,
  italics,
  col.format.p,
  col.format.r,
  col.format.ci,
  format.custom,
  col.format.custom,
  width = NULL,
  spacing = 2,
  broom = NULL,
  report = NULL,
  short = FALSE,
  title,
  note,
  separate.header
)
```

## Arguments

- data:

  The data frame, to be converted to a flextable. The data frame cannot
  have duplicate column names.

- highlight:

  Highlight rows with statistically significant results? Requires a
  column named "p" containing p-values. Can either accept logical
  (TRUE/FALSE) OR a numeric value for a custom critical p-value
  threshold (e.g., 0.10 or 0.001).

- stars:

  Logical. Whether to add asterisks for significant p values.

- italics:

  Which columns headers should be italic? Useful for column names that
  should be italic but that are not picked up automatically by the
  function. Select with numerical range, e.g., 1:3.

- col.format.p:

  Applies p-value formatting to columns that cannot be named "p" (for
  example for a data frame full of p-values, also because it is not
  possible to have more than one column named "p"). Select with
  numerical range, e.g., 1:3.

- col.format.r:

  Applies r-value formatting to columns that cannot be named "r" (for
  example for a data frame full of r-values, also because it is not
  possible to have more than one column named "r"). Select with
  numerical range, e.g., 1:3.

- col.format.ci:

  Applies 95% confidence interval formatting to selected columns (e.g.,
  when reporting more than one interval).

- format.custom:

  Applies custom formatting to columns selected via the
  `col.format.custom` argument. This is useful if one wants custom
  formatting other than for p- or r-values. It can also be used to
  transform (e.g., multiply) certain values or print a specific symbol
  along the values for instance.

- col.format.custom:

  Which columns to apply the custom function to. Select with numerical
  range, e.g., 1:3.

- width:

  Width of the table, in percentage of the total width, when exported
  e.g., to Word. For full width, use `width = 1`.

- spacing:

  Spacing of the rows (1 = single space, 2 = double space)

- broom:

  If providing a tidy table produced with the `broom` package, which
  model type to use if one wants automatic formatting (options are
  "t.test", "lm", "cor.test", and "wilcox.test").

- report:

  If providing an object produced with the `report` package, which model
  type to use if one wants automatic formatting (options are "t.test",
  "lm", and "cor.test").

- short:

  Logical. Whether to return an abbreviated version of the tables made
  by the `report` package.

- title:

  Optional, to add a table header, if desired.

- note:

  Optional, to add one or more table footnote (APA note), if desired.

- separate.header:

  Logical, whether to separate headers based on name delimiters (i.e.,
  periods ".").

## Value

An APA-formatted table of class "flextable"

## Details

The resulting `flextable` objects can be opened in Word with
`print(table, preview ="docx")`, or saved to Word with the
[`flextable::save_as_docx()`](https://davidgohel.github.io/flextable/reference/save_as_docx.html)
function.

## See also

Tutorial: <https://rempsyc.remi-theriault.com/articles/table>

## Examples

``` r
# Make the basic table
my_table <- nice_table(
  mtcars[1:3, ],
  title = c("Table 1", "Motor Trend Car Road Tests"),
  note = c(
    "The data was extracted from the 1974 Motor Trend US magazine.",
    "* p < .05, ** p < .01, *** p < .001"
  )
)
my_table


.cl-a78b5564{table-layout:auto;}.cl-a7844a44{font-family:'Times New Roman';font-size:12pt;font-weight:bold;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-a7844a4e{font-family:'Times New Roman';font-size:12pt;font-weight:normal;font-style:italic;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-a7844a58{font-family:'Times New Roman';font-size:12pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-a7873ee8{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 2;background-color:transparent;}.cl-a7873ef2{margin:0;text-align:center;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 2;background-color:transparent;}.cl-a7873ef3{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-a7875d06{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-a7875d10{background-color:transparent;vertical-align: middle;border-bottom: 0.5pt solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-a7875d11{background-color:transparent;vertical-align: middle;border-bottom: 0.5pt solid rgba(0, 0, 0, 1.00);border-top: 0.5pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-a7875d12{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-a7875d1a{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-a7875d24{background-color:transparent;vertical-align: middle;border-bottom: 0.5pt solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-a7875d2e{background-color:transparent;vertical-align: middle;border-bottom: 0.5pt solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-a7875d2f{background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(255, 255, 255, 0.00);border-top: 0 solid rgba(255, 255, 255, 0.00);border-left: 0 solid rgba(255, 255, 255, 0.00);border-right: 0 solid rgba(255, 255, 255, 0.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}


Table 1
```

Motor Trend Car Road Tests

mpg

cyl

disp

hp

drat

wt

qsec

vs

am

gear

carb

21.00

6.00

160.00

110.00

3.90

2.62

16.46

0.00

1.00

4.00

4.00

21.00

6.00

160.00

110.00

3.90

2.88

17.02

0.00

1.00

4.00

4.00

22.80

4.00

108.00

93.00

3.85

2.32

18.61

1.00

1.00

4.00

1.00

Note. The data was extracted from the 1974 Motor Trend US magazine.

\* p \< .05, \*\* p \< .01, \*\*\* p \< .001

\# \donttest{ \# Save table to word mypath \<-
[tempfile](https://rdrr.io/r/base/tempfile.html)(fileext = ".docx")
flextable::[save_as_docx](https://davidgohel.github.io/flextable/reference/save_as_docx.html)(my_table,
path = mypath) \# } \# Publication-ready tables mtcars.std \<-
[lapply](https://rdrr.io/r/base/lapply.html)(mtcars, scale) model \<-
[lm](https://rdrr.io/r/stats/lm.html)(mpg ~ cyl + wt \* hp, mtcars.std)
stats.table \<-
[as.data.frame](https://rdrr.io/r/base/as.data.frame.html)([summary](https://rdrr.io/r/base/summary.html)(model)\$coefficients)
CI \<- [confint](https://rdrr.io/r/stats/confint.html)(model)
stats.table \<- [cbind](https://rdrr.io/r/base/cbind.html)(
[row.names](https://rdrr.io/r/base/row.names.html)(stats.table),
stats.table, CI )
[names](https://rdrr.io/r/base/names.html)(stats.table) \<-
[c](https://rdrr.io/r/base/c.html)( "Term", "B", "SE", "t", "p",
"CI_lower", "CI_upper" ) nice_table(stats.table, highlight = TRUE)

| Term        | b\*   | SE   | t     | p             | 95% CI           |
|-------------|-------|------|-------|---------------|------------------|
| (Intercept) | -0.18 | 0.09 | -2.15 | .041\*        | \[-0.36, -0.01\] |
| cyl         | -0.11 | 0.15 | -0.72 | .479          | \[-0.42, 0.20\]  |
| wt          | -0.62 | 0.11 | -5.70 | \< .001\*\*\* | \[-0.85, -0.40\] |
| hp          | -0.29 | 0.12 | -2.40 | .023\*        | \[-0.53, -0.04\] |
| wt × hp     | 0.29  | 0.09 | 3.23  | .003\*\*      | \[0.11, 0.47\]   |

\# Test different column names test \<-
[head](https://rdrr.io/r/utils/head.html)(mtcars)
[names](https://rdrr.io/r/base/names.html)(test) \<-
[c](https://rdrr.io/r/base/c.html)( "dR", "N", "M", "SD", "b", "np2",
"ges", "p", "r", "R2", "sr2" ) test\[, 10:11\] \<- test\[, 10:11\] / 10
nice_table(test)

| dR    | N   | M     | SD    | b    | ηp2  | ηG2   | p             | r   | R2  | sr2 |
|-------|-----|-------|-------|------|------|-------|---------------|-----|-----|-----|
| 21.00 | 6   | 160.0 | 110.0 | 3.90 | 2.62 | 16.46 | \< .001\*\*\* | 1.0 | .40 | .40 |
| 21.00 | 6   | 160.0 | 110.0 | 3.90 | 2.88 | 17.02 | \< .001\*\*\* | 1.0 | .40 | .40 |
| 22.80 | 4   | 108.0 | 93.0  | 3.85 | 2.32 | 18.61 | 1.00          | 1.0 | .40 | .10 |
| 21.40 | 6   | 258.0 | 110.0 | 3.08 | 3.21 | 19.44 | 1.00          | .00 | .30 | .10 |
| 18.70 | 8   | 360.0 | 175.0 | 3.15 | 3.44 | 17.02 | \< .001\*\*\* | .00 | .30 | .20 |
| 18.10 | 6   | 225.0 | 105.0 | 2.76 | 3.46 | 20.22 | 1.00          | .00 | .30 | .10 |

\# Custom cell formatting (such as p or r) nice_table(test\[8:11\],
col.format.p = 2:4, highlight = .001)

| p             | r             | R2   | sr2  |
|---------------|---------------|------|------|
| \< .001\*\*\* | 1.00          | .400 | .400 |
| \< .001\*\*\* | 1.00          | .400 | .400 |
| 1.00          | 1.00          | .400 | .100 |
| 1.00          | \< .001\*\*\* | .300 | .100 |
| \< .001\*\*\* | \< .001\*\*\* | .300 | .200 |
| 1.00          | \< .001\*\*\* | .300 | .100 |

nice_table(test\[8:11\], col.format.r = 1:4)

| p   | r   | R2  | sr2 |
|-----|-----|-----|-----|
| .00 | 1.0 | .40 | .40 |
| .00 | 1.0 | .40 | .40 |
| 1.0 | 1.0 | .40 | .10 |
| 1.0 | .00 | .30 | .10 |
| .00 | .00 | .30 | .20 |
| 1.0 | .00 | .30 | .10 |

\# Apply custom functions to cells fun \<- function(x) { x + 11.1 }
nice_table(test\[8:11\], col.format.custom = 2:4, format.custom = "fun")
\#\> Error: object 'fun' not found fun \<- function(x) {
[paste](https://rdrr.io/r/base/paste.html)("x", x) }
nice_table(test\[8:11\], col.format.custom = 2:4, format.custom = "fun")
\#\> Error: object 'fun' not found \# Separate headers based on periods
header.data \<- [structure](https://rdrr.io/r/base/structure.html)(
[list](https://rdrr.io/r/base/list.html)( Variable =
[c](https://rdrr.io/r/base/c.html)( "Sepal.Length", "Sepal.Width",
"Petal.Length" ), setosa.M = [c](https://rdrr.io/r/base/c.html)( 5.01,
3.43, 1.46 ), setosa.SD = [c](https://rdrr.io/r/base/c.html)(0.35, 0.38,
0.17), versicolor.M = [c](https://rdrr.io/r/base/c.html)(5.94, 2.77,
4.26), versicolor.SD = [c](https://rdrr.io/r/base/c.html)(0.52, 0.31,
0.47) ), row.names = [c](https://rdrr.io/r/base/c.html)(NA, -3L), class
= "data.frame" ) nice_table(header.data, separate.header = TRUE, italics
= 2:4 )

| Variable     | setosa |     | versicolor |     |
|--------------|--------|-----|------------|-----|
|              | M      | SD  | M          | SD  |
| Sepal.Length | 5.0    | 0.3 | 5.9        | 0.5 |
| Sepal.Width  | 3.4    | 0.4 | 2.8        | 0.3 |
| Petal.Length | 1.5    | 0.2 | 4.3        | 0.5 |
