#' @title Easy scatter plots over multiple times (T1, T2, T3)
#'
#' @description Make nice scatter plots over multiple times (T1, T2, T3) easily.
#'
#' @param data The data frame.
#' @param response The dependent variable to be plotted.
#' @param ytitle An optional x-axis label, if desired.
#' @param group The group by which to plot the variable
#' @param error_bars Logical, whether to include 95% confidence intervals for means.
#' @return A scatter plot of class ggplot.
#' @export
#' @examplesIf requireNamespace("ggplot2", quietly = TRUE)
#' # Make the basic plot
#' nice_scatter_times(
#'   data = iris,
#'   response = names(iris)[1:4],
#'   group = "Species"
#' )
#'
nice_scatter_times <- function(data,
                               response,
                               group,
                               error_bars = FALSE,
                               ytitle = gsub(".*_", "", response[[1]])) {
  check_col_names(data, c(group))
  rlang::check_installed(c("ggplot2", "tidyr"),
    reason = "for this function.",
    version = get_dep_version(c("ggplot2", "tidyr"))
  )

  data_summary <- data %>%
    mutate(across(all_of(response), as.numeric)) %>%
    tidyr::pivot_longer(
      cols = dplyr::all_of(response),
      names_to = "Time"
    ) %>%
    dplyr::group_by(.data[[group]], .data$Time) %>%
    dplyr::summarize(
      mean = mean(.data$value),
      sd = sd(.data$value),
      n = n(),
      se = sd / sqrt(n),
      ci = stats::qt(0.975, df = n - 1) * .data$se
    ) %>%
    dplyr::mutate(Time = dplyr::case_match(
      .data$Time,
      response[1] ~ 1,
      response[2] ~ 2,
      response[3] ~ 3,
      response[4] ~ 4
    )) %>%
    dplyr::rename(Group = group)

  # Plot
  rge <- range(data_summary$Time)
  ggplot2::ggplot(data_summary, ggplot2::aes(x = .data$Time, y = mean)) +
    ggplot2::geom_line(ggplot2::aes(color = .data$Group), size = 3) +
    ggplot2::scale_color_manual(values = c("#00BA38", "#619CFF", "#F8766D")) +
    ggplot2::geom_point(size = 4, shape = 22, fill = "white", stroke = 1.5) +
    { if (error_bars) {
      ggplot2::geom_errorbar(ggplot2::aes(
        ymin = mean - .data$ci, ymax = mean + .data$ci), width = 0.2)
      }
    } +
    ggplot2::scale_x_continuous(
      limits = rge, breaks = seq(rge[1], rge[2], by = 1)) +
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
}
