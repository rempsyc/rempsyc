#' Paired Pre–Post Spaghetti Plot
#'
#' Creates a publication-ready paired (within-subject) plot for pre–post designs.
#' Individual participant trajectories are shown as connected lines with optional
#' mean overlay. Designed for thermometer-style scales or other continuous outcomes.
#'
#' @param data A data frame in wide format containing the pre and post variables.
#' @param pre Unquoted name of the pre-intervention variable.
#' @param post Unquoted name of the post-intervention variable.
#' @param pre_label Character. Label displayed for the pre condition.
#' @param post_label Character. Label displayed for the post condition.
#' @param y_label Character. Label for the y-axis. Defaults to NULL.
#' @param title Character. Optional plot title.
#' @param point_size Numeric. Size of individual points. Default is 2.
#' @param line_alpha Numeric between 0 and 1. Transparency of paired lines.
#' @param show_mean Logical. If TRUE, overlays the mean trajectory.
#'
#' @details
#' The function reshapes wide data internally using tidy evaluation.
#' It is intended for within-subject comparisons (e.g., pre–post RCT outcomes).
#' No axis limits are imposed; scaling adapts to the data range.
#'
#' @return A ggplot object.
#'
#' @examples
#' df <- data.frame(
#'   pre = rnorm(50, 25, 5),
#'   post = rnorm(50, 15, 5)
#' )
#'
#' plot_prepost(df, "pre", "post",
#'               pre_label = "Before",
#'               post_label = "After",
#'               title = "Reduction in Affective Polarization",
#'               show_mean = TRUE)
#'
#' @export

plot_prepost <- function(
  data,
  pre,
  post,
  pre_label = "Pre",
  post_label = "Post",
  y_label = NULL,
  title = NULL,
  point_size = 2,
  line_alpha = .35,
  show_mean = FALSE
) {
  df_long <- data %>%
    dplyr::mutate(.id = dplyr::row_number()) %>%
    dplyr::select(.data$.id, .data[[pre]], .data[[post]]) %>%
    tidyr::pivot_longer(
      cols = c(.data[[pre]], .data[[post]]),
      names_to = "condition",
      values_to = "score"
    ) %>%
    dplyr::mutate(
      condition = factor(
        .data$condition,
        levels = c(pre, post),
        labels = c(pre_label, post_label)
      )
    )
  p <- ggplot2::ggplot(
    df_long,
    ggplot2::aes(
      x = .data$condition,
      y = .data$score,
      group = .data$.id
    )
  ) +
    ggplot2::geom_line(
      color = "black",
      alpha = line_alpha,
      linewidth = .5
    ) +
    ggplot2::geom_point(
      size = point_size,
      alpha = .85
    ) +
    ggplot2::scale_x_discrete(
      expand = ggplot2::expansion(add = 0.1)
    ) +
    ggplot2::theme_classic(base_size = 13) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold"),
      axis.title.x = ggplot2::element_blank()
    ) +
    ggplot2::labs(
      title = title,
      y = y_label
    )
  if (show_mean) {
    p <- p +
      ggplot2::stat_summary(
        ggplot2::aes(group = 1),
        fun = base::mean,
        geom = "line",
        linewidth = 1
      )
  }
  return(p)
}
