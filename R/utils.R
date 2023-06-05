#' @noRd
theme_apa <- function(x, has.legend = FALSE) {
  x +
    ggplot2::theme_bw(base_size = 24) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5),
      axis.text.x = ggplot2::element_text(colour = "black"),
      axis.text.y = ggplot2::element_text(colour = "black"),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      axis.line = ggplot2::element_line(colour = "black"),
      axis.ticks = ggplot2::element_line(colour = "black")
    ) + {
      if (has.legend == FALSE) {
        ggplot2::theme(legend.position = "none")
      }
    }
}

#' @noRd
message_white <- function(...) {
  message("\033[97m", ..., "\033[97m")
}

#' @noRd
check_col_names <- function(data, names) {
  missing.cols <- lapply(names, function(x) {
    x %in% names(data)
    # grep(x, names(data), invert = F)
  })
  if (length(missing.cols) > 0) {
    id <- which(!unlist(missing.cols))
    if (isTRUE(length(id) >= 1)) {
      missing.cols <- toString(names[id])
      stop(paste0("Variables not found: ", missing.cols, ". Please double check spelling."))
    }
  }
}

#' @noRd
data_is_standardized <- function(data) {
  data <- dplyr::select(data, -dplyr::where(is.factor), -dplyr::where(function(x) {
    length(unique(x)) == 2
  }))
  all(lapply(data, function(x) {
    y <- x %>%
      attributes() %>%
      names()
    all(any(grepl("center", y)), any(grepl("scale", y)))
  }) %>% unlist())
}

#' @noRd
model_is_standardized <- function(models.list) {
  all(
    lapply(models.list, function(submodel) {
      data_is_standardized(submodel$model)
    }) %>% unlist()
  )
}
