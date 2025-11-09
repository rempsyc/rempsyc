# Standardize based on the absolute median deviation

Scale and center ("standardize") data based on the median absolute
deviation (MAD).

## Usage

``` r
scale_mad(x)
```

## Arguments

- x:

  The vector to be scaled.

## Value

A numeric vector of standardized data.

## Details

The function subtracts the median to each observation, and then divides
the outcome by the MAD. This is analogous to regular standardization
which subtracts the mean to each observaion, and then divides the
outcome by the standard deviation.

For the *easystats* equivalent, use:
`datawizard::standardize(x, robust = TRUE)`.

## References

Leys, C., Ley, C., Klein, O., Bernard, P., & Licata, L. (2013).
Detecting outliers: Do not use standard deviation around the mean, use
absolute deviation around the median. *Journal of Experimental Social
Psychology*, *49*(4), 764–766.
https://doi.org/10.1016/j.jesp.2013.03.013

## Examples

``` r
scale_mad(mtcars$mpg)
#>  [1]  0.33262558  0.33262558  0.66525116  0.40654238 -0.09239599 -0.20327119
#>  [7] -0.90548075  0.96091834  0.66525116  0.00000000 -0.25870878 -0.51741757
#> [13] -0.35110478 -0.73916796 -1.62616950 -1.62616950 -0.83156395  2.43925425
#> [19]  2.06967028  2.71644224  0.42502157 -0.68373036 -0.73916796 -1.09027273
#> [25]  0.00000000  1.49681511  1.25658552  2.06967028 -0.62829276  0.09239599
#> [31] -0.77612635  0.40654238
```
