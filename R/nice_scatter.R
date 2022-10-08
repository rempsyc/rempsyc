#' @title Easy scatter plots
#'
#' @description Make nice scatter plots easily.
#'
#' @param data The data frame.
#' @param predictor The independent variable to be plotted.
#' @param response The dependent variable to be plotted.
#' @param xtitle An optional y-axis label, if desired.
#' @param ytitle An optional x-axis label, if desired.
#' @param has.points Whether to plot the individual observations or not.
#' @param has.jitter Alternative to `has.points`. "Jitters"
#' the observations to avoid overlap (overplotting). Use one
#' or the other, not both.
#' @param alpha The desired level of transparency.
#' @param has.line Whether to plot the regression line(s).
#' @param has.confband Logical. Whether to display the
#' confidence band around the slope.
#' @param has.fullrange Logical. Whether to extend the slope
#' beyond the range of observations.
#' @param has.linetype Logical. Whether to change line types
#' as a function of group.
#' @param has.shape Logical. Whether to change shape of
#' observations as a function of group.
#' @param xmin The minimum score on the x-axis scale.
#' @param xmax The maximum score on the x-axis scale.
#' @param xby How much to increase on each "tick" on the x-axis scale.
#' @param ymin The minimum score on the y-axis scale.
#' @param ymax The maximum score on the y-axis scale.
#' @param yby How much to increase on each "tick" on the y-axis scale.
#' @param has.legend Logical. Whether to display the legend or not.
#' @param legend.title The desired legend title.
#' @param group The group by which to plot the variable
#' @param colours Desired colours for the plot, if desired.
#' @param groups.order Specifies the desired display order of the groups.
#' @param groups.labels Changes groups names (labels).
#' Note: This applies after changing order of level.
#' @param groups.alpha The manually specified transparency
#' desired for the groups slopes. Use only when plotting groups
#' separately.
#' @param has.r Whether to display the correlation coefficient, the r-value.
#' @param r.x The x-axis coordinates for the r-value.
#' @param r.y The y-axis coordinates for the r-value.
#' @param has.p Whether to display the p-value.
#' @param p.x The x-axis coordinates for the p-value.
#' @param p.y The y-axis coordinates for the p-value.
#'
#' @keywords scatter plots
#' @return A scatter plot of class ggplot.
#' @export
#' @examples
#' # Make the basic plot
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg"
#' )
#' \donttest{
#' \dontshow{.old_wd <- setwd(tempdir())}
#' # Save a high-resolution image file to specified directory
#' ggplot2::ggsave("nicescatterplothere.pdf", width = 7,
#'   height = 7, unit = "in", dpi = 300
#' ) # change for your own desired path
#' \dontshow{setwd(.old_wd)}
#' # Change x- and y- axis labels
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   ytitle = "Miles/(US) gallon",
#'   xtitle = "Weight (1000 lbs)"
#' )
#'
#' # Have points "jittered"
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   has.jitter = TRUE
#' )
#'
#' # Change the transparency of the points
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   alpha = 1
#' )
#'
#' # Remove points
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   has.points = FALSE,
#'   has.jitter = FALSE
#' )
#'
#' # Add confidence band
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   has.confband = TRUE
#' )
#'
#' # Set x- and y- scales manually
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   xmin = 1,
#'   xmax = 6,
#'   xby = 1,
#'   ymin = 10,
#'   ymax = 35,
#'   yby = 5
#' )
#'
#' # Change plot colour
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   colours = "blueviolet"
#' )
#'
#' # Add correlation coefficient to plot and p-value
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   has.r = TRUE,
#'   has.p = TRUE
#' )
#'
#' # Change location of correlation coefficient or p-value
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   has.r = TRUE,
#'   r.x = 4,
#'   r.y = 25,
#'   has.p = TRUE,
#'   p.x = 5,
#'   p.y = 20
#' )
#'
#' # Plot by group
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   group = "cyl"
#' )
#'
#' # Use full range on the slope/confidence band
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   group = "cyl",
#'   has.fullrange = TRUE
#' )
#'
#' # Remove lines
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   group = "cyl",
#'   has.line = FALSE
#' )
#'
#' # Add a legend
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   group = "cyl",
#'   has.legend = TRUE
#' )
#'
#' # Change order of labels on the legend
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   group = "cyl",
#'   has.legend = TRUE,
#'   groups.order = c(8, 4, 6)
#' )
#'
#' # Change legend labels
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   group = "cyl",
#'   has.legend = TRUE,
#'   groups.labels = c("Weak", "Average", "Powerful")
#' )
#' # Warning: This applies after changing order of level
#'
#' # Add a title to legend
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   group = "cyl",
#'   has.legend = TRUE,
#'   legend.title = "cylinders"
#' )
#'
#' # Plot by group + manually specify colours
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   group = "cyl",
#'   colours = c("burlywood", "darkgoldenrod", "chocolate")
#' )
#'
#' # Plot by group + use different line types for each group
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   group = "cyl",
#'   has.linetype = TRUE
#' )
#'
#' # Plot by group + use different point shapes for each group
#' nice_scatter(
#'   data = mtcars,
#'   predictor = "wt",
#'   response = "mpg",
#'   group = "cyl",
#'   has.shape = TRUE
#' )
#' }
#'
#' @seealso
#' Visualize group differences via violin plots:
#' \code{\link{nice_violin}}. Tutorial:
#' \url{https://rempsyc.remi-theriault.com/articles/scatter}
#'
#' @importFrom stats cor.test

nice_scatter <- function(data,
                         predictor,
                         response,
                         xtitle = predictor,
                         ytitle = response,
                         has.points = TRUE,
                         has.jitter = FALSE,
                         alpha = 0.7,
                         has.line = TRUE,
                         has.confband = FALSE,
                         has.fullrange = FALSE,
                         has.linetype = FALSE,
                         has.shape = FALSE,
                         xmin,
                         xmax,
                         xby = 1,
                         ymin,
                         ymax,
                         yby = 1,
                         has.legend = FALSE,
                         legend.title = "",
                         group = NULL,
                         colours = "#619CFF",
                         groups.order = NULL,
                         groups.labels = NULL,
                         groups.alpha = NULL,
                         has.r = FALSE,
                         r.x = Inf,
                         r.y = -Inf,
                         has.p = FALSE,
                         p.x = Inf,
                         p.y = -Inf) {
  rlang::check_installed("ggplot2", reason = "for this function.")
  has.groups <- !missing(group)
  if (has.r == TRUE) {
    r <- format_r(cor.test(data[[predictor]],
      data[[response]],
      use = "complete.obs",
    )$estimate)
  }
  if (has.p == TRUE) {
    p <- format_p(cor.test(data[[predictor]],
      data[[response]],
      use = "complete.obs",
    )$p.value,
    sign = TRUE
    )
  }
  if (missing(group)) {
    smooth <- ggplot2::stat_smooth(
      formula = y ~ x, geom = "line", method = "lm",
      fullrange = has.fullrange, color = colours, size = 1
    )
  }
  if (!missing(group)) {
    data[[group]] <- as.factor(data[[group]])
    smooth <- ggplot2::stat_smooth(
      formula = y ~ x, geom = "line", method = "lm",
      fullrange = has.fullrange, size = 1
    )
  }
  if (!missing(groups.order)) {
    data[[group]] <- factor(data[[group]], levels = groups.order)
  }
  if (!missing(groups.labels)) {
    levels(data[[group]]) <- groups.labels
  }
  if (has.confband == TRUE & missing(group)) {
    band <- ggplot2::geom_smooth(formula = y ~ x, method = "lm",
                                 colour = NA, fill = colours)
  }
  if (has.confband == TRUE & !missing(group)) {
    band <- ggplot2::geom_smooth(formula = y ~ x, method = "lm", colour = NA)
  }
  if (has.points == TRUE & missing(group) & missing(colours)) {
    observations <- ggplot2::geom_point(size = 2, alpha = alpha, shape = 16)
  }
  if (has.points == TRUE & !missing(group) & has.shape == FALSE) {
    observations <- ggplot2::geom_point(size = 2, alpha = alpha, shape = 16)
  }
  if (has.points == TRUE & missing(group) & !missing(colours)) {
    observations <- ggplot2::geom_point(
      size = 2, alpha = alpha,
      colour = colours, shape = 16
    )
  }
  if (has.points == TRUE & !missing(group) & has.shape == TRUE) {
    observations <- ggplot2::geom_point(size = 2, alpha = alpha)
  }
  if (has.jitter == TRUE & missing(group) & missing(colours)) {
    observations <- ggplot2::geom_jitter(size = 2, alpha = alpha, shape = 16)
    has.points <- FALSE
  }
  if (has.jitter == TRUE & !missing(group) & has.shape == FALSE) {
    observations <- ggplot2::geom_jitter(size = 2, alpha = alpha, shape = 16)
    has.points <- FALSE
  }
  if (has.jitter == TRUE & missing(group) & !missing(colours)) {
    observations <- ggplot2::geom_jitter(
      size = 2, alpha = alpha,
      colour = colours, shape = 16
    )
    has.points <- FALSE
  }
  if (has.jitter == TRUE & !missing(group) & has.shape == TRUE) {
    observations <- ggplot2::geom_jitter(size = 2, alpha = alpha)
    has.points <- FALSE
  }
  plot <- ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = .data[[predictor]],
      y = .data[[response]],
      colour = switch(has.groups == TRUE,
        .data[[group]]
      ),
      fill = switch(has.groups == TRUE,
        .data[[group]]
      ),
      linetype = switch(has.groups == TRUE & has.linetype == TRUE,
        .data[[group]]
      ),
      shape = switch(has.groups == TRUE & has.shape == TRUE,
        .data[[group]]
      ),
      alpha = switch(!is.null(groups.alpha),
        .data[[group]]
      )
    )
  ) +
    ggplot2::xlab(xtitle) +
    ggplot2::ylab(ytitle) +
    {
      if (has.line == TRUE) {
        smooth
      }
    } +
    {
      if (has.confband == TRUE) {
        band
      }
    } +
    {
      if (exists("observations")) {
        observations
      }
    } +
    {
      if (!missing(xmin)) {
        ggplot2::scale_x_continuous(
          limits = c(xmin, xmax), breaks = seq(xmin, xmax, by = xby)
        )
      }
    } +
    {
      if (!missing(ymin)) {
        ggplot2::scale_y_continuous(
          limits = c(ymin, ymax), breaks = seq(ymin, ymax, by = yby)
        )
      }
    } +
    {
      if (!missing(colours) & !missing(group)) {
        ggplot2::scale_color_manual(values = colours, name = legend.title)
      }
    } +
    {
      if (!missing(colours) & !missing(group)) {
        ggplot2::scale_fill_manual(values = colours, name = legend.title)
      }
    } +
    {
      if (!missing(colours)) {
        ggplot2::guides(fill = ggplot2::guide_legend(
          override.aes = list(colour = colours)
        ))
      }
    } +
    {
      if (has.legend == FALSE) {
        ggplot2::theme(legend.position = "none")
      }
    } +
    ggplot2::labs(
      legend.title = legend.title, colour = legend.title,
      fill = legend.title, linetype = legend.title, shape = legend.title
    ) +
    {
      if (!missing(groups.alpha)) {
        ggplot2::scale_alpha_manual(values = groups.alpha, guide = "none")
      }
    } +
    {
      if (has.r == TRUE) {
        ggplot2::annotate(
          geom = "text",
          x = r.x,
          y = r.y,
          label = sprintf("italic('r =')~'%s'", r),
          parse = TRUE,
          hjust = 1,
          vjust = -3,
          size = 7
        )
      }
    } +
    {
      if (has.p == TRUE) {
        ggplot2::annotate(
          geom = "text",
          x = p.x,
          y = p.y,
          label = sprintf("italic('p')~'%s'", p),
          parse = TRUE,
          hjust = 1,
          vjust = -1,
          size = 7
        )
      }
    }
  theme_apa(plot)
}
