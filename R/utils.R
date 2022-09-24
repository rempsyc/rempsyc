#' @noRd
theme_apa <-
  theme_bw(base_size = 24) +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "none",
    axis.text.x = element_text(colour = "black"),
    axis.text.y = element_text(colour = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.ticks = element_line(colour = "black")
  )

#' @noRd
message_white <- function(...) {
  message("\033[97m", ..., "\033[97m")
}

