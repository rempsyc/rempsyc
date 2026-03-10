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
#> 2  2        BP
#> 3  3        PZ
#> 4  4        CX
#> 5  5        PZ
#> 6  6        ZL
#> 7  7        CX
#> 8  8        BP

# Within-Group Design
nice_randomize(
  design = "within", Ncondition = 4, n = 6,
  condition.names = c("SV", "AV", "ST", "AT")
)
#>   id         Condition
#> 1  1 AT - ST - SV - AV
#> 2  2 SV - AV - AT - ST
#> 3  3 AV - AT - SV - ST
#> 4  4 ST - AV - AT - SV
#> 5  5 SV - AT - AV - ST
#> 6  6 SV - AT - ST - AV

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
#> 1  1 AV - AT - ST - SV        NA      NA      NA         NA     NA    NA
#> 2  2 SV - ST - AV - AT        NA      NA      NA         NA     NA    NA
#> 3  3 ST - SV - AV - AT        NA      NA      NA         NA     NA    NA
#> 4  4 ST - SV - AV - AT        NA      NA      NA         NA     NA    NA
#> 5  5 SV - ST - AV - AT        NA      NA      NA         NA     NA    NA
#> 6  6 AT - ST - SV - AV        NA      NA      NA         NA     NA    NA
```
