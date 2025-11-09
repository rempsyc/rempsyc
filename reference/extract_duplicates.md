# Extract all duplicates

Extract all duplicates, for visual inspection. Note that it also
contains the first occurrence of future duplicates, unlike
[`duplicated()`](https://rdrr.io/r/base/duplicated.html) or
[`dplyr::distinct()`](https://dplyr.tidyverse.org/reference/distinct.html)).
Also contains an additional column reporting the number of missing
values for that row, to help in the decision-making when selecting which
duplicates to keep.

## Usage

``` r
extract_duplicates(data, id)
```

## Arguments

- data:

  The data frame.

- id:

  The ID variable for which to check for duplicates.

## Value

A dataframe, containing all duplicates.

## Details

For the *easystats* equivalent, see:
[`datawizard::data_unique()`](https://easystats.github.io/datawizard/reference/data_unique.html).

## Examples

``` r
df1 <- data.frame(
  id = c(1, 2, 3, 1, 3),
  item1 = c(NA, 1, 1, 2, 3),
  item2 = c(NA, 1, 1, 2, 3),
  item3 = c(NA, 1, 1, 2, 3)
)

extract_duplicates(df1, id = "id")
#>   Row id item1 item2 item3 count_na
#> 1   1  1    NA    NA    NA        3
#> 2   4  1     2     2     2        0
#> 3   3  3     1     1     1        0
#> 4   5  3     3     3     3        0

# Filter to exclude duplicates
df2 <- df1[-c(1, 5), ]
df2
#>   id item1 item2 item3
#> 2  2     1     1     1
#> 3  3     1     1     1
#> 4  1     2     2     2
```
