# Easily randomization

Randomize easily with different designs.

## Usage

``` r
nice_randomize(
  design = "between",
  Ncondition = 3,
  n = 9,
  condition.names = c("a", "b", "c"),
  col.names = c("id", "Condition")
)
```

## Arguments

- design:

  The design: either between-subject (different groups) or
  within-subject (repeated-measures on same people).

- Ncondition:

  The number of conditions you want to randomize.

- n:

  The desired sample size. Note that it needs to be a multiple of your
  number of groups if you are using `between`.

- condition.names:

  The names of the randomized conditions.

- col.names:

  The desired additional column names for a runsheet.

## Value

A dataframe, with participant ID and randomized condition, based on
selected design.

## See also

Tutorial: <https://rempsyc.remi-theriault.com/articles/randomize>

## Examples

``` r
# Specify design, number of conditions, number of
# participants, and names of conditions:
nice_randomize(
  design = "between", Ncondition = 4, n = 8,
  condition.names = c("BP", "CX", "PZ", "ZL")
)
#>   id Condition
#> 1  1        ZL
#> 2  2        PZ
#> 3  3        CX
#> 4  4        BP
#> 5  5        ZL
#> 6  6        PZ
#> 7  7        BP
#> 8  8        CX

# Within-Group Design
nice_randomize(
  design = "within", Ncondition = 4, n = 6,
  condition.names = c("SV", "AV", "ST", "AT")
)
#>   id         Condition
#> 1  1 SV - AV - AT - ST
#> 2  2 AV - AT - SV - ST
#> 3  3 ST - AV - AT - SV
#> 4  4 SV - AT - AV - ST
#> 5  5 SV - AT - ST - AV
#> 6  6 AV - AT - ST - SV

# Make a quick runsheet
randomized <- nice_randomize(
  design = "within", Ncondition = 4, n = 128,
  condition.names = c("SV", "AV", "ST", "AT"),
  col.names = c(
    "id", "Condition", "Date/Time",
    "SONA ID", "Age/Gd.", "Handedness",
    "Tester", "Notes"
  )
)
head(randomized)
#>   id         Condition Date/Time SONA ID Age/Gd. Handedness Tester Notes
#> 1  1 SV - ST - AV - AT        NA      NA      NA         NA     NA    NA
#> 2  2 ST - SV - AV - AT        NA      NA      NA         NA     NA    NA
#> 3  3 ST - SV - AV - AT        NA      NA      NA         NA     NA    NA
#> 4  4 SV - ST - AV - AT        NA      NA      NA         NA     NA    NA
#> 5  5 AT - ST - SV - AV        NA      NA      NA         NA     NA    NA
#> 6  6 SV - ST - AT - AV        NA      NA      NA         NA     NA    NA
```
