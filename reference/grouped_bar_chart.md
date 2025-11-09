# Easy grouped bar charts for categorical variables

Make nice grouped bar charts easily.

## Usage

``` r
grouped_bar_chart(
  data,
  response,
  label = response,
  group = "T1_Group",
  proportion = TRUE,
  print_table = FALSE
)
```

## Arguments

- data:

  The data frame.

- response:

  The categorical dependent variable to be plotted.

- label:

  Label of legend describing the dependent variable.

- group:

  The group by which to plot the variable

- proportion:

  Logical, whether to use proportion (default), else, counts.

- print_table:

  Logical, whether to also print the computed proportion or count table.

## Value

A bar plot of class ggplot.

## Examples

``` r
# Make the basic plot
iris2 <- iris
iris2$plant <- c(
  rep("yes", 45),
  rep("no", 45),
  rep("maybe", 30),
  rep("NA", 30)
)
grouped_bar_chart(
  data = iris2,
  response = "plant",
  group = "Species"
)
```
