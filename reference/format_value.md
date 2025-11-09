# Easily format p or r values

Easily format p or r values. Note: converts to character class for use
in figures or manuscripts to accommodate e.g., "\< .001".

## Usage

``` r
format_value(value, type = "d", ...)

format_p(
  p,
  precision = 0.001,
  prefix = NULL,
  suffix = NULL,
  sign = FALSE,
  stars = FALSE
)

format_r(r, precision = 0.01)

format_d(d, precision = 0.01)
```

## Arguments

- value:

  Value to be formatted, when using the generic `format_value()`.

- type:

  Specify r or p value.

- ...:

  To specify precision level, if necessary, when using the generic
  `format_value()`. Simply add the `precision` argument.

- p:

  p value to format.

- precision:

  Level of precision desired, if necessary.

- prefix:

  To add a prefix before the value.

- suffix:

  To add a suffix after the value.

- sign:

  Logical. Whether to add an equal sign for p values higher or equal to
  .001.

- stars:

  Logical. Whether to add asterisks for significant p values.

- r:

  r value to format.

- d:

  d value to format.

## Value

A formatted p, r, or d value.

## Details

For the *easystats* equivalent, see:
[`insight::format_value()`](https://easystats.github.io/insight/reference/format_value.html).

## Examples

``` r
format_value(0.00041231, "p")
#> [1] "< .001"
format_value(0.00041231, "r")
#> [1] ".00"
format_value(1.341231, "d")
#> [1] "1.34"
format_p(0.0041231)
#> [1] ".004"
format_p(0.00041231)
#> [1] "< .001"
format_r(0.41231)
#> [1] ".41"
format_r(0.041231)
#> [1] ".04"
format_d(1.341231)
#> [1] "1.34"
format_d(0.341231)
#> [1] "0.34"
```
