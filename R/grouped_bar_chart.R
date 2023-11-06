#' @title Easy grouped bar charts for categorical variables
#'
#' @description Make nice grouped bar charts easily.
#'
#' @param data The data frame.
#' @param response The categorical dependent variable to be plotted.
#' @param label Label of legend describing the dependent variable.
#' @param proportion Logical, whether to use proportion (default), else, counts.
#' @param print_table Logical, whether to also print the computed proportion or
#' count table.
#' @param group The group by which to plot the variable
#' @return A bar plot of class ggplot.
#' @export
#' @examplesIf requireNamespace("ggplot2", quietly = TRUE)
#' # Make the basic plot
#' iris2 <- iris
#' iris2$plant <- c(
#'   rep("yes", 45),
#'   rep("no", 45),
#'   rep("maybe", 30),
#'   rep("NA", 30)
#' )
#' grouped_bar_chart(
#'   data = iris2,
#'   response = "plant",
#'   group = "Species"
#' )
grouped_bar_chart <- function(data, response, label = response, group = "T1_Group",
                              proportion = TRUE, print_table = FALSE) {
  trs <- function(x) {
    if (proportion) {
      round(prop.table(x) * 100)
    } else {
      x
    }
  }
  labelz <- function(n) {
    if (proportion) {
      sprintf("%.f%%", n)
    } else {
      as.character(n)
    }
  }
  data <- data %>%
    dplyr::group_by(.data[[group]]) %>%
    dplyr::count(.data[[response]], sort = TRUE) %>%
    dplyr::mutate(n = trs(n))
  if (print_table) {
    print(data)
  }
  data %>%
    ggplot2::ggplot(ggplot2::aes(x = .data[[group]], y = n, fill = .data[[response]])) +
    ggplot2::geom_bar(stat = "identity", position = ggplot2::position_dodge()) +
    ggplot2::labs(x = "Group", y = ifelse(proportion, "Proportion", "Count"), fill = label) +
    ggplot2::theme_minimal() +
    ggplot2::geom_text(ggplot2::aes(label = labelz(n)),
      position = ggplot2::position_dodge(width = 0.9),
      vjust = -0.5,
      size = 3
    )
}
