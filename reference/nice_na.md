# Report missing values according to guidelines

Nicely reports NA values according to existing guidelines. This function
reports both absolute and percentage values of specified column lists.
Some authors recommend reporting item-level missing item per scale, as
well as participant’s maximum number of missing items by scale. For
example, Parent (2013) writes:

*I recommend that authors (a) state their tolerance level for missing
data by scale or subscale (e.g., “We calculated means for all subscales
on which participants gave at least 75% complete data”) and then (b)
report the individual missingness rates by scale per data point (i.e.,
the number of missing values out of all data points on that scale for
all participants) and the maximum by participant (e.g., “For Attachment
Anxiety, a total of 4 missing data points out of 100 were observed, with
no participant missing more than a single data point”).*

## Usage

``` r
nice_na(data, vars = NULL, scales = NULL)
```

## Arguments

- data:

  The data frame.

- vars:

  Variable (or lists of variables) to check for NAs.

- scales:

  The scale names to check for NAs (single character string).

## Value

A dataframe, with:

- `var`: variables selected

- `items`: number of items for selected variables

- `na`: number of missing cell values for those variables (e.g., 2
  missing values for first participant + 2 missing values for second
  participant = total of 4 missing values)

- `cells`: total number of cells (i.e., number of participants
  multiplied by number of variables, `items`)

- `na_percent`: the percentage of missing values (number of missing
  cells, `na`, divided by total number of cells, `cells`)

- `na_max`: The amount of missing values for the participant with the
  most missing values for the selected variables

- `na_max_percent`: The amount of missing values for the participant
  with the most missing values for the selected variables, in percentage
  (i.e., `na_max` divided by the number of selected variables, `items`)

- `all_na`: the number of participants missing 100% of items for that
  scale (the selected variables)

## References

Parent, M. C. (2013). Handling item-level missing data: Simpler is just
as good. *The Counseling Psychologist*, *41*(4), 568-600.
https://doi.org/10.1177%2F0011000012445176

## Examples

``` r
# Use whole data frame
nice_na(airquality)
#>         var items na cells na_percent na_max na_max_percent all_na
#> 1 Ozone:Day     6 44   918       4.79      2          33.33      0

# Use selected columns explicitly
nice_na(airquality,
  vars = list(
    c("Ozone", "Solar.R", "Wind"),
    c("Temp", "Month", "Day")
  )
)
#>          var items na cells na_percent na_max na_max_percent all_na
#> 1 Ozone:Wind     3 44   459       9.59      2          66.67      0
#> 2   Temp:Day     3  0   459       0.00      0           0.00      0
#> 3      Total     6 44   918       4.79      2          33.33      0

# If the questionnaire items start with the same name, e.g.,
set.seed(15)
fun <- function() {
  c(sample(c(NA, 1:10), replace = TRUE), NA, NA, NA)
}
df <- data.frame(
  ID = c("idz", NA),
  open_1 = fun(), open_2 = fun(), open_3 = fun(),
  extrovert_1 = fun(), extrovert_2 = fun(), extrovert_3 = fun(),
  agreeable_1 = fun(), agreeable_2 = fun(), agreeable_3 = fun()
)

# One can list the scale names directly:
nice_na(df, scales = c("ID", "open", "extrovert", "agreeable"))
#>                       var items na cells na_percent na_max na_max_percent
#> 1                   ID:ID     1  7    14      50.00      1            100
#> 2           open_1:open_3     3 11    42      26.19      3            100
#> 3 extrovert_1:extrovert_3     3 17    42      40.48      3            100
#> 4 agreeable_1:agreeable_3     3 10    42      23.81      3            100
#> 5                   Total    10 45   140      32.14     10            100
#>   all_na
#> 1      7
#> 2      3
#> 3      3
#> 4      3
#> 5      2
```
