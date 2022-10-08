#' @noRd

theme_apa <- function(x) {
  #if (require(ggplot2)) {
    #rlang::check_installed("ggplot2", reason = "for this function.")
    x +
    ggplot2::theme_bw(base_size = 24) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5),
      legend.position = "none",
      axis.text.x = ggplot2::element_text(colour = "black"),
      axis.text.y = ggplot2::element_text(colour = "black"),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      axis.line = ggplot2::element_line(colour = "black"),
      axis.ticks = ggplot2::element_line(colour = "black")
    )
  }

#' @noRd
message_white <- function(...) {
  message("\033[97m", ..., "\033[97m")
}

