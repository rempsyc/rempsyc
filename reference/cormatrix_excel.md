# Easy export of correlation matrix to Excel

Easily output a correlation matrix and export it to Microsoft Excel,
with the first row and column frozen, and correlation coefficients
colour-coded based on effect size (0.0-0.2: small (no colour); 0.2-0.4:
medium (pink/light blue); 0.4-1.0: large (red/dark blue)), following
Cohen's suggestions for small (.10), medium (.30), and large (.50)
correlation sizes.

Based on the `correlation` and `openxlsx2` packages.

## Usage

``` r
cormatrix_excel(
  data,
  filename,
  overwrite = TRUE,
  p_adjust = "none",
  print.mat = TRUE,
  ...
)
```

## Arguments

- data:

  The data frame

- filename:

  Desired filename (path can be added before hand but no need to specify
  extension).

- overwrite:

  Whether to allow overwriting previous file.

- p_adjust:

  Default p-value adjustment method (default is "none", although
  [`correlation::correlation()`](https://easystats.github.io/correlation/reference/correlation.html)'s
  default is "holm")

- print.mat:

  Logical, whether to also print the correlation matrix to console.

- ...:

  Parameters to be passed to the `correlation` package (see
  [`correlation::correlation()`](https://easystats.github.io/correlation/reference/correlation.html))

## Value

A Microsoft Excel document, containing the colour-coded correlation
matrix with significance stars, on the first sheet, and the colour-coded
p-values on the second sheet.

## Details

For the *easystats* equivalent, see:
[`correlation::cormatrix_to_excel()`](https://easystats.github.io/correlation/reference/cormatrix_to_excel.html).

## Author

Adapted from @JanMarvin (JanMarvin/openxlsx2#286) and the original
cormatrix_excel (now imported from
[correlation::cormatrix_to_excel](https://easystats.github.io/correlation/reference/cormatrix_to_excel.html)).

## Examples

``` r
# Basic example
cormatrix_excel(mtcars, select = c("mpg", "cyl", "disp", "hp", "carb"), filename = "cormatrix1")
#> # Correlation Matrix (pearson-method)
#> 
#> Parameter |      mpg |      cyl |     disp |       hp |    carb
#> ---------------------------------------------------------------
#> mpg       |          | -0.85*** | -0.85*** | -0.78*** | -0.55**
#> cyl       | -0.85*** |          |  0.90*** |  0.83*** |  0.53**
#> disp      | -0.85*** |  0.90*** |          |  0.79*** |   0.39*
#> hp        | -0.78*** |  0.83*** |  0.79*** |          | 0.75***
#> carb      |  -0.55** |   0.53** |    0.39* |  0.75*** |        
#> 
#> p-value adjustment method: none
#> 
#> 
#>  [Correlation matrix 'cormatrix1.xlsx' has been saved to working directory (or where specified).]
#> Warning: will not open file when not interactive
#> NULL
cormatrix_excel(iris, p_adjust = "none", filename = "cormatrix2")
#> # Correlation Matrix (pearson-method)
#> 
#> Parameter    | Sepal.Length | Sepal.Width | Petal.Length | Petal.Width
#> ----------------------------------------------------------------------
#> Sepal.Length |              |       -0.12 |      0.87*** |     0.82***
#> Sepal.Width  |        -0.12 |             |     -0.43*** |    -0.37***
#> Petal.Length |      0.87*** |    -0.43*** |              |     0.96***
#> Petal.Width  |      0.82*** |    -0.37*** |      0.96*** |            
#> 
#> p-value adjustment method: none
#> 
#> 
#>  [Correlation matrix 'cormatrix2.xlsx' has been saved to working directory (or where specified).]
#> Warning: will not open file when not interactive
#> NULL
cormatrix_excel(airquality, method = "spearman", filename = "cormatrix3")
#> # Correlation Matrix (spearman-method)
#> 
#> Parameter |    Ozone | Solar.R |     Wind |     Temp |   Month |   Day
#> ----------------------------------------------------------------------
#> Ozone     |          | 0.35*** | -0.59*** |  0.77*** |    0.14 | -0.06
#> Solar.R   |  0.35*** |         |     0.00 |    0.21* |   -0.13 | -0.15
#> Wind      | -0.59*** |    0.00 |          | -0.45*** |   -0.16 |  0.04
#> Temp      |  0.77*** |   0.21* | -0.45*** |          | 0.37*** | -0.16
#> Month     |     0.14 |   -0.13 |    -0.16 |  0.37*** |         | -0.01
#> Day       |    -0.06 |   -0.15 |     0.04 |    -0.16 |   -0.01 |      
#> 
#> p-value adjustment method: none
#> 
#> 
#>  [Correlation matrix 'cormatrix3.xlsx' has been saved to working directory (or where specified).]
#> Warning: will not open file when not interactive
#> NULL
```
