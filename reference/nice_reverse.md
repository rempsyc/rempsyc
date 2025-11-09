# Easily recode scores

Easily recode scores (reverse-score), typically for questionnaire
answers.

For the *easystats* equivalent, see:
[`datawizard::reverse()`](https://easystats.github.io/datawizard/reference/reverse.html).

## Usage

``` r
nice_reverse(x, max, min = 1)
```

## Arguments

- x:

  The score to reverse.

- max:

  The maximum score on the scale.

- min:

  The minimum score on the scale (optional unless it isn't 1).

## Value

A numeric vector, of reversed scores.

## Examples

``` r
# Reverse score of 5 with a maximum score of 5
nice_reverse(5, 5)
#> [1] 1

# Reverse several scores at once
nice_reverse(1:5, 5)
#> [1] 5 4 3 2 1

# Reverse scores with maximum = 4 and minimum = 0
nice_reverse(1:4, 4, min = 0)
#> [1] 3 2 1 0

# Reverse scores with maximum = 3 and minimum = -3
nice_reverse(-3:3, 3, min = -3)
#> [1]  3  2  1  0 -1 -2 -3
```
