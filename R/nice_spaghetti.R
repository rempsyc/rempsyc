#' Nice Spaghetti Plot for Two Within-Subject Conditions
#'
#' Creates a publication-ready paired (within-subject) spaghetti plot.
#' Individual participant trajectories are shown as connected lines with optional
#' mean overlay. Designed for pre-post designs and other two-condition repeated
#' measures outcomes.
#'
#' @param data A data frame in wide format containing the pre and post variables.
#' @param pre Unquoted name of the pre-intervention variable.
#' @param post Unquoted name of the post-intervention variable.
#' @param group Optional character string specifying a grouping variable.
#' When provided, individual trajectories and (if requested) mean lines
#' are colored by group.
#' @param colors Optional named character vector of colors for the `group` variable.
#' Names must match group levels.
#' @param pre_label Character. Label displayed for the pre condition.
#' @param post_label Character. Label displayed for the post condition.
#' @param y_label Character. Label for the y-axis. Defaults to NULL.
#' @param title Character. Optional plot title.
#' @param subtitle Character. Optional plot subtitle.
#' @param point_size Numeric. Size of individual points. Default is 2.
#' @param line_alpha Numeric between 0 and 1. Transparency of paired lines.
#' @param point_alpha Numeric between 0 and 1. Transparency level for individual points.
#' Lower values are recommended for large samples to reduce overplotting.
#' @param jitter Numeric. Horizontal jitter width applied to individual points
#' (no vertical jitter). Useful for large samples to improve visibility of overlap.
#' @param show_mean Logical. If TRUE, overlays the mean trajectory.
#'
#' @details
#' The function reshapes wide data internally using tidy evaluation.
#' It is intended for within-subject comparisons (e.g., pre-post RCT outcomes).
#' No axis limits are imposed; scaling adapts to the data range.
#'
#' @return A ggplot object.
#'
#' @examples
#' if (requireNamespace("dplyr", quietly = TRUE) &&
#'     requireNamespace("tidyr", quietly = TRUE) &&
#'     requireNamespace("ggplot2", quietly = TRUE)) {
#'
#'   df <- data.frame(
#'     pre = rnorm(50, 25, 5),
#'     post = rnorm(50, 15, 5)
#'   )
#'
#'   nice_spaghetti(
#'     df,
#'     "pre",
#'     "post",
#'     pre_label = "Before",
#'     post_label = "After",
#'     title = "Reduction in Affective Polarization",
#'     subtitle = "Individual trajectories and group mean",
#'     show_mean = TRUE
#'   )
#' }
#' @export
nice_spaghetti <- function(
  data,
  pre,
  post,
  group = NULL,
  colors = NULL,
  pre_label = "Pre",
  post_label = "Post",
  y_label = NULL,
  title = NULL,
  subtitle = NULL,
  point_size = 2,
  line_alpha = .35,
  point_alpha = 0.5,
  jitter = 0,
  show_mean = FALSE
) {
  df_long <- data %>%
    dplyr::mutate(.id = dplyr::row_number()) %>%
    dplyr::select(
      .data$.id,
      .data[[pre]],
      .data[[post]],
      dplyr::all_of(group)
    ) %>%
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

  aes_mapping <- if (is.null(group)) {
    ggplot2::aes(
      x = .data$condition,
      y = .data$score,
      group = .data$.id
    )
  } else {
    ggplot2::aes(
      x = .data$condition,
      y = .data$score,
      group = .data$.id,
      color = .data[[group]]
    )
  }

  p <- ggplot2::ggplot(df_long, aes_mapping) +
    ggplot2::geom_point(
      position = ggplot2::position_jitter(width = jitter, height = 0),
      size = point_size,
      alpha = point_alpha
    ) +
    ggplot2::scale_x_discrete(expand = ggplot2::expansion(add = 0.1)) +
    ggplot2::theme_classic(base_size = 13) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold"),
      axis.title.x = ggplot2::element_blank()
    ) +
    ggplot2::labs(
      title = title,
      subtitle = subtitle,
      y = y_label,
      color = group
    )

  if (is.null(group)) {
    p <- p +
      ggplot2::geom_line(
        alpha = line_alpha,
        linewidth = .6,
        colour = "grey50"
      )
  } else {
    p <- p +
      ggplot2::geom_line(
        alpha = line_alpha,
        linewidth = .6
      )
  }

  if (show_mean) {
    if (is.null(group)) {
      p <- p +
        ggplot2::stat_summary(
          ggplot2::aes(group = 1),
          fun = base::mean,
          geom = "line",
          linewidth = 1.2,
          linetype = "dashed",
          color = "black"
        )
    } else {
      p <- p +
        ggplot2::stat_summary(
          ggplot2::aes(group = .data[[group]]),
          fun = base::mean,
          geom = "line",
          linewidth = 1.2,
          linetype = "dashed"
        )
    }
  }

  if (!is.null(group) && !is.null(colors)) {
    p <- p + ggplot2::scale_color_manual(values = colors)
  }

  return(p)
}
