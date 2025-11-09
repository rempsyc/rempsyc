# Choose the best duplicate

Chooses the best duplicate, based on the duplicate with the smallest
number of missing values. In case of ties, it picks the first duplicate,
as it is the one most likely to be valid and authentic, given practice
effects.

## Usage

``` r
best_duplicate(data, id, keep.rows = FALSE)
```

## Arguments

- data:

  The data frame.

- id:

  The ID variable for which to check for duplicates.

- keep.rows:

  Logical, whether to add a column at the beginning of the data frame
  with the original row indices.

## Value

A dataframe, containing only the "best" duplicates.

## Details

For the *easystats* equivalent, see:
[`datawizard::data_duplicated()`](https://easystats.github.io/datawizard/reference/data_duplicated.html).

## Examples

``` r
df1 <- data.frame(
  id = c(1, 2, 3, 1, 3),
  item1 = c(NA, 1, 1, 2, 3),
  item2 = c(NA, 1, 1, 2, 3),
  item3 = c(NA, 1, 1, 2, 3)
)

best_duplicate(df1, id = "id", keep.rows = TRUE)
#> (2 duplicates removed)
#>   Row id item1 item2 item3
#> 1   4  1     2     2     2
#> 2   2  2     1     1     1
#> 3   3  3     1     1     1
```
