#' @title Easy scatter plots over multiple times (T1, T2, T3)
#'
#' @description Make nice scatter plots over multiple times (T1, T2, T3) easily.
#'
#' @details Error bars are calculated using the method of Morey (2008) through
#' [Rmisc::summarySEwithin()], but raw means are plotted instead of the normed
#' means. For more information, visit:
#' http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2).
#' @references Morey, R. D. (2008). Confidence intervals from normalized data:
#' A correction to Cousineau (2005). Tutorials in Quantitative Methods for
#' Psychology, 4(2), 61-64. \doi{10.20982/tqmp.04.2.p061}
#' @param data The data frame.
#' @param response The dependent variable to be plotted (e.g.,
#'  `c("variable_T1", "variable_T2", "variable_T3")`, etc.).
#' @param ytitle An optional x-axis label, if desired. If `NULL`, will take the
#'  variable name of the first variable in `response`, and keep only the part of
#'  the string before an underscore or period.
#' @param group The group by which to plot the variable
#' @param error_bars Logical, whether to include 95% confidence intervals for means.
#' @param print_table Logical, whether to also print the computed table.
#' @param verbose Logical, whether to also print a note regarding the meaning
#' of the error bars.
#' @return A scatter plot of class ggplot.
#' @export
#' @examplesIf requireNamespace("ggplot2", quietly = TRUE)
#' plot_means_over_time(
#' data = mtcars,
#' response = names(mtcars)[3:6],
#' group = "cyl"
#' )

plot_means_over_time <- function(data,
                                 response,
                                 group,
                                 error_bars = TRUE,
                                 ytitle = NULL,
                                 print_table = FALSE,
                                 verbose = FALSE) {
  check_col_names(data, c(response, group))
  rlang::check_installed(c("ggplot2", "tidyr", "Rmisc"),
                         reason = "for this function.",
                         version = get_dep_version(c("ggplot2", "tidyr", "Rmisc"))
  )
  if (is.null(ytitle)) {
    ytitle <- gsub("([^_.]+).*", "\\1", response[[1]])
  }

  data$subject_ID <- seq(nrow(data))
  data[[group]] <- as.factor(data[[group]])
  data[response] <- lapply(data[response], as.numeric)

  # Convert to long format
  data_long <- tidyr::pivot_longer(
    data,
    dplyr::all_of(response),
    names_to = "Time",
    names_ptypes = factor())

  data_summary <- Rmisc::summarySEwithin(
    data_long,
    measurevar = "value",
    withinvars = "Time",
    betweenvars = group,
    idvar = "subject_ID",
    na.rm = FALSE,
    conf.interval = .95)

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
  pd <- ggplot2::position_dodge(0.2) # move them .01 to the left and right
  p <- ggplot2::ggplot(data_summary, ggplot2::aes(x = .data$Time, y = .data$value,
                                      group = .data[[group]])) +
    ggplot2::geom_line(ggplot2::aes(
      color = .data[[group]]), linewidth = 3, position = pd) +
  {
    if (error_bars) {
      ggplot2::geom_errorbar(width = .1, ggplot2::aes(
        ymin = .data$value - .data$ci, ymax = .data$value + .data$ci),
        position = pd, linewidth = 1)
      }
    } +
    ggplot2::geom_point(size = 4, shape = 22, fill = "white", stroke = 1.5,
                        position = pd) +
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
    ggplot2::ylab(ytitle)
  if (verbose && error_bars) {
    cat("Error bars represent 95% confidence intervals adjusted for",
        "repeated measures as by the method of Morey (2008).")
  }
  p
}
