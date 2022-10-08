#' @title Easy normality check per group
#'
#' @description Easily make nice per-group density and QQ plots
#' through a wrapper around the `ggplot2` and `qqplotr` packages.
#'
#' @param data The data frame.
#' @param variable The dependent variable to be plotted.
#' @param group The group by which to plot the variable.
#' @param colours Desired colours for the plot, if desired.
#' @param groups.labels How to label the groups.
#' @param grid Logical, whether to keep the default background grid
#' or not. APA style suggests not using a grid in the background,
#' though in this case some may find it useful to more easily
#' estimate the slopes of the different groups.
#' @param shapiro Logical, whether to include the p-value from
#' the Shapiro-Wilk test on the plot.
#' @param title An optional title, if desired.
#' @param histogram Logical, whether to add an histogram
#' on top of the density plot.
#' @param breaks.auto If histogram = TRUE, then option to set bins/breaks
#'                    automatically, mimicking the default behaviour of
#'                    base R `hist()` (the Sturges method). Defaults to
#'                    `FALSE`.
#' @param ... Further arguments from `nice_qq()` and
#' `nice_density()` to be passed to `nice_normality()`
#'
#' @return A plot of classes patchwork and ggplot, containing two plots,
#'         resulting from \code{\link{nice_density}} and \code{\link{nice_qq}}.
#' @keywords QQ plots normality density distribution
#' @export
#' @examples
#' # Make the basic plot
#' nice_normality(
#'   data = iris,
#'   variable = "Sepal.Length",
#'   group = "Species"
#' )
#'
#' # Further customization
#' nice_normality(
#'   data = iris,
#'   variable = "Sepal.Length",
#'   group = "Species",
#'   colours = c(
#'     "#00BA38",
#'     "#619CFF",
#'     "#F8766D"
#'   ),
#'   groups.labels = c(
#'     "(a) Setosa",
#'     "(b) Versicolor",
#'     "(c) Virginica"
#'   ),
#'   grid = FALSE,
#'   shapiro = TRUE
#' )
#'
#' @seealso
#' Other functions useful in assumption testing:
#' \code{\link{nice_assumptions}}, \code{\link{nice_density}},
#' \code{\link{nice_qq}}, \code{\link{nice_var}},
#' \code{\link{nice_varplot}}. Tutorial:
#' \url{https://rempsyc.remi-theriault.com/articles/assumptions}
#'

nice_normality <- function(data,
                           variable,
                           group,
                           colours,
                           groups.labels,
                           grid = TRUE,
                           shapiro = FALSE,
                           title = NULL,
                           histogram = FALSE,
                           breaks.auto = FALSE,
                           ...) {
  rlang::check_installed(c("ggplot2", "see", "patchwork"), reason = "for this function.")
  plot.a <- nice_density(
    data = data, variable = variable, group = group,
    colours = colours, groups.labels = groups.labels,
    grid = grid, shapiro = shapiro, title = title,
    histogram = histogram, breaks.auto = breaks.auto, ...
  )
  plot.a
  plot.b <- nice_qq(
    data = data, variable = variable, group = group,
    colours = colours, groups.labels = groups.labels,
    grid = grid, shapiro = shapiro, title = NULL, ...
  )
  see::plots(plot.a, plot.b)
}
