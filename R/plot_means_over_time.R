#' @title Easy scatter plots over multiple times (T1, T2, T3)
#'
#' @description Make nice scatter plots over multiple times (T1, T2, T3) easily.
#'
#' @details Error bars are calculated using the method of Morey (2008) through
#' [Rmisc::summarySEwithin()], but raw means are plotted instead of the normed
#' means. For more information, visit:
#' http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2).
#' @references Morey, R. D. (2008). Confidence intervals from normalized data:
#' A correction to Cousineau (2005). *Tutorials in Quantitative Methods for
#' Psychology*, *4*(2), 61-64. \doi{10.20982/tqmp.04.2.p061}
#' @param data The data frame.
#' @param response The dependent variable to be plotted (e.g.,
#'  `c("variable_T1", "variable_T2", "variable_T3")`, etc.).
#' @param ytitle An optional x-axis label, if desired. If `NULL`, will take the
#'  variable name of the first variable in `response`, and keep only the part of
#'  the string before an underscore or period.
#' @param legend.title The desired legend title.
#' @param group The group by which to plot the variable
#' @param groups.order Specifies the desired display order of the groups
#' on the legend. Either provide the levels directly, or a string: "increasing"
#' or "decreasing", to order based on the average value of the variable on the
#' y axis, or "string.length", to order from the shortest to the longest
#' string (useful when working with long string names). "Defaults to "none".
#' @param error_bars Logical, whether to include 95% confidence intervals for means.
#' @param significance_bars_x Vector of where on the x-axis vertical
#' significance bars should appear on the plot (e.g., `c(2:4)`).
#' @param significance_stars Vetor of significance stars to display on the
#' plot (e.g,. `c("*", "**", "***")`).
#' @param significance_stars_x Vector of where on the x-axis significance
#' stars should appear on the plot (e.g., `c(2.2, 3.2, 4.2)`).
#' @param significance_stars_y Vector of where on the y-axis significance
#' stars should appear on the plot. The logic here is different than previous
#' arguments. Rather than providing actual coordinates, we provide a list
#' object with structure group 1, group 2, and time of comparison, e.g.,
#' `list(c("group1", "group2", time = 2), c("group1", "group3", time = 3), c("group2", "group3", time = 4))`.
#' @param print_table Logical, whether to also print the computed table.
#' @param verbose Logical, whether to also print a note regarding the meaning
#' of the error bars.
#' @return A scatter plot of class ggplot.
#' @export
#' @examplesIf requireNamespace("ggplot2", quietly = TRUE)
#' data <- mtcars
#' names(data)[6:3] <- paste0("T", 1:4, "_var")
#' plot_means_over_time(
#'   data = data,
#'   response = names(data)[6:3],
#'   group = "cyl",
#'   groups.order = "decreasing"
#' )
#'
#' # Add significance stars/bars
#' plot_means_over_time(
#'   data = data,
#'   response = names(data)[6:3],
#'   group = "cyl",
#'   significance_bars_x = c(3.15, 4.15),
#'   significance_stars = c("*", "***"),
#'   significance_stars_x = c(3.25, 4.5),
#'   significance_stars_y = list(
#'     c("4", "8", time = 3),
#'     c("4", "8", time = 4)
#'   )
#' )
#' # significance_stars_y: List with structure: list(c("group1", "group2", time))
plot_means_over_time <- function(data,
                                 response,
                                 group,
                                 groups.order = "none",
                                 error_bars = TRUE,
                                 ytitle = NULL,
                                 legend.title = "",
                                 significance_stars,
                                 significance_stars_x,
                                 significance_stars_y,
                                 significance_bars_x,
                                 print_table = FALSE,
                                 verbose = FALSE) {
  check_col_names(data, c(response, group))
  rlang::check_installed(c("ggplot2", "tidyr", "Rmisc"),
    reason = "for this function.",
    version = get_dep_version(c("ggplot2", "tidyr", "Rmisc"))
  )
  if (is.null(ytitle)) {
    ytitle <- gsub(".*_", "", response[[1]])
  }

  data <- dplyr::ungroup(data)
  data$subject_ID <- seq(nrow(data))
  data[[group]] <- as.factor(data[[group]])
  data[response] <- lapply(data[response], as.numeric)

  # Convert to long format
  data_long <- tidyr::pivot_longer(
    data,
    dplyr::all_of(response),
    names_to = "Time",
    names_ptypes = factor()
  )

  data_summary <- Rmisc::summarySEwithin(
    data_long,
    measurevar = "value",
    withinvars = "Time",
    betweenvars = group,
    idvar = "subject_ID",
    na.rm = FALSE,
    conf.interval = .95
  )

  data_summary2 <- data_long %>%
    dplyr::group_by(.data[[group]], .data$Time) %>%
    dplyr::summarize(
      mean = mean(.data$value),
      sd = stats::sd(.data$value),
      n = dplyr::n(),
      se = sd / sqrt(n),
      ci = stats::qt(0.975, df = n - 1) * .data$se
    )

  data_summary$value <- data_summary2$mean

  if (print_table) {
    print(data_summary)
  }
  times <- seq(length(response))

  dataSummary <- data_summary %>%
    summarize(Mean = mean(.data$value, na.rm = TRUE), .by = all_of(group))

  if (groups.order[1] == "increasing") {
    data_summary[[group]] <- factor(
      data_summary[[group]],
      levels = levels(data_summary[[group]])[order(dataSummary$Mean)]
    )
  } else if (groups.order[1] == "decreasing") {
    data_summary[[group]] <- factor(
      data_summary[[group]],
      levels = levels(data_summary[[group]])[order(dataSummary$Mean,
        decreasing = TRUE
      )]
    )
  } else if (groups.order[1] == "string.length") {
    data_summary[[group]] <- factor(
      data_summary[[group]],
      levels = levels(data_summary[[group]])[order(
        nchar(levels(data_summary[[group]]))
      )]
    )
  } else if (groups.order[1] != "none") {
    data_summary[[group]] <- factor(data_summary[[group]], levels = groups.order)
  }

  # ggplot2
  pd <- ggplot2::position_dodge(0.2) # move them .01 to the left and right
  p <- ggplot2::ggplot(
    data_summary, ggplot2::aes(
      x = .data$Time,
      y = .data$value,
      group = .data[[group]],
      # fill = "white",
      shape = .data[[group]],
      colour = .data[[group]]
    )
  ) +
    ggplot2::geom_line(ggplot2::aes(
      color = .data[[group]]
    ), linewidth = 3, position = pd) +
    {
      if (error_bars) {
        ggplot2::geom_errorbar(
          width = .1, ggplot2::aes(
            ymin = .data$value - .data$ci, ymax = .data$value + .data$ci
          ),
          position = pd, linewidth = 1
        )
      }
    } +
    ggplot2::geom_point(
      size = 4,
      # shape = 22,
      fill = "white",
      # colour = "black",
      stroke = 1.5,
      position = pd
    ) +
    ggplot2::discrete_scale("shape", palette = function(n) {
      # stopifnot("more than 5 shapes not supported" = n <= 5)
      # 20 + seq_len(n)
      c(21:25, 0:20)[1:n]
    }) +
    # guides(fill = guide_legend(override.aes = list(shape = 21))) +
    ggplot2::scale_x_discrete(labels = times) +
    ggplot2::theme_bw(base_size = 24) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(colour = "black"),
      axis.text.y = ggplot2::element_text(colour = "black"),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      axis.line = ggplot2::element_line(colour = "black"),
      axis.ticks = ggplot2::element_line(colour = "black")
    ) +
    ggplot2::labs(
      legend.title = legend.title, colour = legend.title,
      fill = legend.title, linetype = legend.title, shape = legend.title
    ) +
    ggplot2::ylab(ytitle)

  if (!missing(significance_stars)) {
    # significance bars/stars
    m <- data %>%
      dplyr::select(dplyr::all_of(c(group, response))) %>%
      dplyr::summarize(dplyr::across(dplyr::all_of(response), mean),
        .by = dplyr::all_of(group)
      )

    get_segment_y <- function(m, significance_stars_y, groups = 1:2, value = 1:2) {
      zz <- dplyr::filter(m, .data[[group]] %in% significance_stars_y[groups]) %>%
        dplyr::select(as.numeric(significance_stars_y[3]) + 1) %>%
        unlist()
      zz[value]
    }

    significance_stars_y_internal <- lapply(significance_stars_y, function(x) {
      mean(c(
        get_segment_y(m, x, groups = 1:2, value = 2),
        get_segment_y(m, x, groups = 1:2, value = 1)
      ))
    }) %>% unlist()

    p <- p +
      ggplot2::annotate(
        "text",
        x = significance_stars_x,
        y = significance_stars_y_internal,
        label = significance_stars,
        size = 10
      )

    segment_data_y_internal <- lapply(significance_stars_y, function(x) {
      get_segment_y(m, x, groups = 1:2, value = 1)
    }) %>% unlist()

    segment_data_yend_internal <- lapply(significance_stars_y, function(x) {
      get_segment_y(m, x, groups = 1:2, value = 2)
    }) %>% unlist()

    segment_data <- data.frame(
      x = significance_bars_x,
      xend = significance_bars_x,
      y = segment_data_y_internal,
      yend = segment_data_yend_internal
    )

    segment_data[[group]] <- m[[group]][1]

    p <- p + ggplot2::geom_segment(
      data = segment_data,
      ggplot2::aes(
        x = .data$x,
        xend = .data$x,
        y = .data$y,
        yend = .data$yend
      ),
      linewidth = 0.5,
      colour = "black"
    )
    p
  }
  if (verbose && error_bars) {
    cat(
      "Error bars represent 95% confidence intervals adjusted for",
      "repeated measures as by the method of Morey (2008)."
    )
  }
  p
}
