#' @title Easy QQ plots per group
#'
#' @description Easily make nice per-group QQ plots through
#' a wrapper around the `ggplot2` and `qqplotr` packages.
#'
#' @param data The data frame.
#' @param variable The dependent variable to be plotted.
#' @param group The group by which to plot the variable.
#' @param colours Desired colours for the plot, if desired.
#' @param groups.labels How to label the groups.
#' @param grid Logical, whether to keep the default background
#' grid or not. APA style suggests not using a grid in the
#' background, though in this case some may find it useful
#' to more easily estimate the slopes of the different groups.
#' @param shapiro Logical, whether to include the p-value
#' from the Shapiro-Wilk test on the plot.
#' @param title An optional title, if desired.
#'
#' @return A qq plot of class ggplot, by group (if provided), along a
#'         reference interpretation helper, the 95% confidence band.
#' @keywords QQ plots normality distribution
#' @export
#' @examples
#' # Make the basic plot
#' nice_qq(
#'   data = iris,
#'   variable = "Sepal.Length",
#'   group = "Species"
#' )
#'
#' # Further customization
#' nice_qq(
#'   data = iris,
#'   variable = "Sepal.Length",
#'   group = "Species",
#'   colours = c("#00BA38", "#619CFF", "#F8766D"),
#'   groups.labels = c("(a) Setosa", "(b) Versicolor", "(c) Virginica"),
#'   grid = FALSE,
#'   shapiro = TRUE,
#'   title = NULL
#' )
#'
#' @seealso
#' Other functions useful in assumption testing:
#' \code{\link{nice_assumptions}}, \code{\link{nice_density}},
#' \code{\link{nice_normality}}, \code{\link{nice_var}},
#' \code{\link{nice_varplot}}. Tutorial:
#' \url{https://rempsyc.remi-theriault.com/articles/assumptions}
#'
#' @importFrom dplyr mutate %>% select group_by summarize rowwise do
#' @importFrom ggplot2 ggplot labs facet_grid ggtitle
#' theme_bw scale_fill_manual theme aes_string aes element_text
#' element_line element_blank
#' @importFrom stats reformulate shapiro.test

nice_qq <- function(data,
                    variable,
                    group,
                    colours,
                    groups.labels = NULL,
                    grid = TRUE,
                    shapiro = FALSE,
                    title = variable) {
  if (missing(group)) {
    group <- "All"
    data[[group]] <- group
  }
  data[[group]] <- as.factor(data[[group]])
  gform <- reformulate(".", response = group)
  {
    if (!missing(groups.labels)) levels(data[[group]]) <- groups.labels
  }
  # Make data for the Shapiro-Wilk tests
  if (shapiro == TRUE) {
    dat_text <- data %>%
      group_by(.data[[group]]) %>%
      summarize(text = shapiro.test(.data[[variable]])$p.value) %>%
      rowwise() %>%
      mutate(text = sprintf("italic('p')~'%s'", format_p(
        text,
        sign = TRUE, suffix = " (Shapiro-Wilk)"
      )))
  }
  # Make plot
  ggplot(data = data, mapping = aes_string(fill = group, sample = variable)) +
    qqplotr::stat_qq_band() +
    qqplotr::stat_qq_line() +
    qqplotr::stat_qq_point() +
    labs(x = "Theoretical Quantiles", y = "Sample Quantiles") +
    facet_grid(gform) +
    ggtitle(title) +
    {
      if (shapiro == TRUE) {
        ggrepel::geom_text_repel(
          data = dat_text,
          mapping = aes(
            x = Inf,
            y = -Inf,
            label = text
          ),
          inherit.aes = FALSE,
          size = 6,
          force = 0,
          parse = TRUE
        )
      }
    } +
    {
      if (!missing(colours)) scale_fill_manual(values = colours)
    } +
    theme_apa +
    {
      if (grid == TRUE) {
        theme(
          panel.grid.major = element_line(),
          panel.grid.minor = element_line(size = 0.5)
        )
      }
    }
}
