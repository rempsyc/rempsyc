#' @title Visually check outliers (dot plot)
#'
#' @description Easily and visually check outliers through a dot plot
#' with accompanying reference lines at +/- 3 MAD or SD. When providing
#' a group, data are group-mean centered and standardized (based on
#' MAD or SD); if no group is provided, data are simply standardized.
#'
#' @param data The data frame.
#' @param group The group by which to plot the variable.
#' @param response The dependent variable to be plotted.
#' @param method Method to identify outliers, either (e.g., 3)
#' median absolute deviations ("mad", default) or standard deviations ("sd").
#' @param criteria How many MADs (or standard deviations) to use as
#' threshold (default is 3).
#' @param colours Desired colours for the plot, if desired.
#' @param xlabels The individual group labels on the x-axis.
#' @param ytitle An optional y-axis label, if desired.
#' @param xtitle An optional x-axis label, if desired.
#' @param has.ylabels Logical, whether the x-axis should have labels or not.
#' @param has.xlabels Logical, whether the y-axis should have labels or not.
#' @param ymin The minimum score on the y-axis scale.
#' @param ymax The maximum score on the y-axis scale.
#' @param yby How much to increase on each "tick" on the y-axis scale.
#' @param ... Other arguments passed to [ggplot2::geom_dotplot].
#'
#' @keywords dotplot plots
#' @return A dot plot of class ggplot, by group.
#' @export
#' @examplesIf requireNamespace("ggplot2", quietly = TRUE)
#' # Make the basic plot
#' plot_outliers(
#'   airquality,
#'   group = "Month",
#'   response = "Ozone"
#' )
#'
#' plot_outliers(
#'   airquality,
#'   response = "Ozone",
#'   method = "sd"
#' )
#'
#' @seealso
#' Other functions useful in assumption testing:
#' Tutorial:
#' \url{https://rempsyc.remi-theriault.com/articles/assumptions}
#'

plot_outliers <- function(data,
                          group = NULL,
                          response,
                          method = "mad",
                          criteria = 3,
                          colours,
                          xlabels = NULL,
                          ytitle = NULL,
                          xtitle = NULL,
                          has.ylabels = TRUE,
                          has.xlabels = TRUE,
                          ymin,
                          ymax,
                          yby = 1,
                          ...) {
  check_col_names(data, c(group, response))
  rlang::check_installed(c("ggplot2"), reason = "for this function.")
  mtd <- switch(method,
    "mad" = "median",
    "sd" = "mean"
  )
  if (missing(group)) {
    group <- "All data"
    data[[group]] <- group
    if (is.null(ytitle)) {
      ytitle <- paste0(response, " (", mtd, "-standardized)")
    }
  } else {
    data[[group]] <- as.factor(data[[group]])
    if (is.null(ytitle)) {
      ytitle <- paste0(response, " (group-", mtd, " standardized)")
    }
  }

  data[[response]] <- as.numeric(data[[response]])

  scale_function <- function(x, methodx = method) {
    if (methodx == "mad") {
      rempsyc::scale_mad(x)
    } else if (methodx == "sd") {
      as.numeric(scale(x))
    }
  }

  z.df <- data %>%
    group_by(.data[[group]]) %>%
    mutate(
      across(all_of(response), scale_function,
        .names = "{col}"
      )
    )

  plot <- ggplot2::ggplot(z.df, ggplot2::aes(
    x = .data[[group]],
    y = .data[[response]],
    fill = .data[[group]]
  )) +
    ggplot2::ylab(ytitle) +
    ggplot2::xlab(xtitle) +
    ggplot2::geom_dotplot(
      binaxis = "y",
      stackdir = "center",
      ...
    ) +
    ggplot2::geom_hline(
      yintercept = criteria,
      size = 1,
      colour = "red",
      linetype = "dashed"
    ) +
    ggplot2::geom_hline(
      yintercept = -criteria,
      size = 1,
      colour = "red",
      linetype = "dashed"
    )

  plot <- theme_apa(plot) +
    {
      if (!missing(colours)) {
        ggplot2::scale_fill_manual(values = colours)
      }
    } +
    {
      if (!missing(xlabels)) {
        ggplot2::scale_x_discrete(labels = c(xlabels))
      }
    } +
    {
      if (has.ylabels == FALSE) {
        ggplot2::theme(
          axis.text.y = ggplot2::element_blank(),
          axis.ticks.y = ggplot2::element_blank()
        )
      }
    } +
    {
      if (has.xlabels == FALSE) {
        ggplot2::theme(
          axis.text.x = ggplot2::element_blank(),
          axis.ticks.x = ggplot2::element_blank()
        )
      }
    } + {
      if (!missing(ymin)) {
        ggplot2::scale_y_continuous(
          limits = c(ymin, ymax), breaks = seq(ymin, ymax, by = yby)
        )
      }
    }
  plot
}
