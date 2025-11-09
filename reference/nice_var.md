# Obtain variance per group

Obtain variance per group as well as check for the rule of thumb of one
group having variance four times bigger than any of the other groups.
Variance ratio is calculated as Max / Min.

## Usage

``` r
nice_var(data, variable, group, criteria = 4)
```

## Arguments

- data:

  The data frame

- variable:

  The dependent variable to be plotted.

- group:

  The group by which to plot the variable.

- criteria:

  Desired threshold if one wants something different than four times the
  variance.

## Value

A dataframe, with the values of the selected variables for each group,
their max variance ratio (maximum variance divided by the minimum
variance), the selected decision criterion, and whether the data are
considered heteroscedastic according to the decision criterion.

## See also

Other functions useful in assumption testing:
[`nice_assumptions`](https://rempsyc.remi-theriault.com/reference/nice_assumptions.md),
[`nice_density`](https://rempsyc.remi-theriault.com/reference/nice_density.md),
[`nice_normality`](https://rempsyc.remi-theriault.com/reference/nice_normality.md),
[`nice_qq`](https://rempsyc.remi-theriault.com/reference/nice_qq.md),
[`nice_varplot`](https://rempsyc.remi-theriault.com/reference/nice_varplot.md).
Tutorial: <https://rempsyc.remi-theriault.com/articles/assumptions>

## Examples

``` r
# Make the basic table
nice_var(
  data = iris,
  variable = "Sepal.Length",
  group = "Species"
)
#>        Species Setosa Versicolor Virginica Variance.ratio Criteria
#> 1 Sepal.Length  0.124      0.266     0.404            3.3        4
#>   Heteroscedastic
#> 1           FALSE

# Try on multiple variables
nice_var(
  data = iris,
  variable = names(iris[1:4]),
  group = "Species"
)
#>        Species Setosa Versicolor Virginica Variance.ratio Criteria
#> 1 Sepal.Length  0.124      0.266     0.404            3.3        4
#> 2  Sepal.Width  0.144      0.098     0.104            1.5        4
#> 3 Petal.Length  0.030      0.221     0.305           10.2        4
#> 4  Petal.Width  0.011      0.039     0.075            6.8        4
#>   Heteroscedastic
#> 1           FALSE
#> 2           FALSE
#> 3            TRUE
#> 4            TRUE
```
