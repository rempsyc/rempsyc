# Winsorize based on the absolute median deviation

Winsorize (bring extreme observations to usually +/- 3 standard
deviations) data based on median absolute deviations instead of standard
deviations.

## Usage

``` r
winsorize_mad(x, criteria = 3)
```

## Arguments

- x:

  The vector to be winsorized based on the MAD.

- criteria:

  How many MAD to use as threshold (similar to standard deviations)

## Value

A numeric vector of winsorized data.

## Details

For the *easystats* equivalent, use:
`datawizard::winsorize(x, method = "zscore", threshold = 3, robust = TRUE)`.

## References

Leys, C., Ley, C., Klein, O., Bernard, P., & Licata, L. (2013).
Detecting outliers: Do not use standard deviation around the mean, use
absolute deviation around the median. *Journal of Experimental Social
Psychology*, *49*(4), 764–766.
https://doi.org/10.1016/j.jesp.2013.03.013

## Examples

``` r
winsorize_mad(mtcars$qsec, criteria = 2)
#>  [1] 16.46000 17.02000 18.61000 19.44000 17.02000 20.22000 15.84000 20.00000
#>  [9] 20.54177 18.30000 18.90000 17.40000 17.60000 18.00000 17.98000 17.82000
#> [17] 17.42000 19.47000 18.52000 19.90000 20.01000 16.87000 17.30000 15.41000
#> [25] 17.05000 18.90000 16.70000 16.90000 14.87823 15.50000 14.87823 18.60000
```
