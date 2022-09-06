#' @title Easy density plots
#'
#' @description Make nice density plots easily. Internally, uses `na.rm = TRUE`.
#'
#' @param data The data frame
#' @param variable The dependent variable to be plotted.
#' @param group The group by which to plot the variable.
#' @param colours Desired colours for the plot, if desired.
#' @param ytitle An optional y-axis label, if desired.
#' @param xtitle An optional x-axis label, if desired.
#' @param groups.labels The groups.labels (might rename to
#' `xlabels` for consistency with other functions)
#' @param grid Logical, whether to keep the default background
#' grid or not. APA style suggests not using a grid in the background,
#' though in this case some may find it useful to more easily estimate
#' the slopes of the different groups.
#' @param shapiro Logical, whether to include the p-value
#' from the Shapiro-Wilk test on the plot.
#' @param title The desired title of the plot. Can be put to `NULL` to remove.
#' @param histogram Logical, whether to add an histogram
#' @param breaks.auto If histogram = TRUE, then option to set bins/breaks automatically,
#'                    mimicking the default behaviour of base R `hist()` (the Sturges
#'                    method). Defaults to `FALSE`.
#' @param bins If histogram = TRUE, then option to change the default bin (30).
#' @keywords density, normality
#'
#' @examples
#' # Make the basic plot
#' nice_density(
#'   data = iris,
#'   variable = "Sepal.Length",
#'   group = "Species"
#' )
#'
#' # Further customization
#' nice_density(
#'   data = iris,
#'   variable = "Sepal.Length",
#'   group = "Species",
#'   colours = c("#00BA38", "#619CFF", "#F8766D"),
#'   xtitle = "Sepal Length",
#'   ytitle = "Density (vs. Normal Distribution)",
#'   groups.labels = c(
#'     "(a) Setosa",
#'     "(b) Versicolor",
#'     "(c) Virginica"
#'   ),
#'   grid = FALSE,
#'   shapiro = TRUE,
#'   title = "Density (Sepal Length)"
#' )
#'
#' @importFrom dplyr mutate %>% select group_by summarize rowwise do
#' @importFrom ggplot2 ggplot labs facet_grid ggtitle theme_bw
#' scale_fill_manual theme annotate scale_x_discrete ylab xlab
#' geom_violin geom_point geom_errorbar geom_dotplot scale_y_continuous
#' stat_smooth geom_smooth geom_jitter scale_x_continuous
#' scale_color_manual guides scale_alpha_manual geom_density
#' geom_line aes_string aes element_blank element_line
#' element_text geom_histogram
#' @importFrom stats reformulate dnorm
#'
#' @seealso
#' Other functions useful in assumption testing:
#' \code{\link{nice_assumptions}}, \code{\link{nice_normality}},
#' \code{\link{nice_qq}}, \code{\link{nice_varplot}},
#' \code{\link{nice_var}}. Tutorial:
#' \url{https://rempsyc.remi-theriault.com/articles/assumptions}
#'

#' @export
nice_density <- function(data,
                         variable,
                         group,
                         colours,
                         ytitle = "Density",
                         xtitle = variable,
                         groups.labels = NULL,
                         grid = TRUE,
                         shapiro = FALSE,
                         title = variable,
                         histogram = FALSE,
                         breaks.auto = FALSE,
                         bins = 30) {
  if (missing(group)) {
    group <- "All"
    data[[group]] <- group
  }
  options(dplyr.summarize.inform = FALSE)
  data[[group]] <- as.factor(data[[group]])
  gform <- reformulate(".", response = group)
  {
    if (!missing(groups.labels)) levels(data[[group]]) <- groups.labels
  }
  # Make data for normally distributed lines
  dat_norm <- data %>%
    group_by(.data[[group]]) %>%
    do(summarize(.,
      x = seq(min(.[[variable]], na.rm = TRUE),
        max(.[[variable]], na.rm = TRUE),
        length.out = 100
      ),
      y = dnorm(
        seq(min(.[[variable]], na.rm = TRUE),
          max(.[[variable]], na.rm = TRUE),
          length.out = 100
        ),
        mean(.[[variable]], na.rm = TRUE),
        sd(.[[variable]], na.rm = TRUE)
      )
    ))
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

  if (isTRUE(breaks.auto && isTRUE(histogram))) {
    # Calculating the Sturges bins
    breaks <- pretty(range(data[[variable]]),
                     n = grDevices::nclass.Sturges(data[[variable]]),
                     min.n = 1)
  } else {
    breaks <- NULL
  }

  # Make plot
  ggplot(data, aes_string(x = variable, fill = group)) +
    {
      if (isTRUE(histogram)) {
        geom_histogram(aes(y = ..density.., alpha = 0.5),
          colour = "black", breaks = breaks, bins = bins
        )
      }
    } +
    geom_density(alpha = 0.6, size = 1, colour = "gray25") +
    theme_bw(base_size = 24) +
    ggtitle(title) +
    facet_grid(gform) +
    geom_line(
      data = dat_norm, aes(x = x, y = y),
      color = "darkslateblue", size = 1.2, alpha = 0.9
    ) +
    ylab(ytitle) +
    xlab(xtitle) +
    {
      if (shapiro == TRUE) {
        ggrepel::geom_text_repel(
          data = dat_text,
          mapping = aes(
            x = Inf,
            y = Inf,
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
