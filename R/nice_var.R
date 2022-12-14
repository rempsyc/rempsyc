#' @title Obtain variance per group
#'
#' @description Obtain variance per group as well as check for
#' the rule of thumb of one group having variance four times
#' bigger than any of the other groups. Variance ratio is
#' calculated as Max / Min.
#'
#' @param data The data frame
#' @param variable The dependent variable to be plotted.
#' @param group The group by which to plot the variable.
#' @param criteria Desired threshold if one wants something
#' different than four times the variance.
#'
#' @keywords variance
#' @return A dataframe, with the values of the selected variables for
#'         each group, their max variance ratio (maximum variance divided by
#'         the minimum variance), the selected decision criterion, and whether
#'         the data are considered heteroscedastic according to the decision
#'         criterion.
#' @examples
#' # Make the basic table
#' nice_var(
#'   data = iris,
#'   variable = "Sepal.Length",
#'   group = "Species"
#' )
#'
#' # Try on multiple variables
#' nice_var(
#'   data = iris,
#'   variable = names(iris[1:4]),
#'   group = "Species"
#' )
#'
#' @seealso
#' Other functions useful in assumption testing:
#' \code{\link{nice_assumptions}}, \code{\link{nice_density}},
#' \code{\link{nice_normality}}, \code{\link{nice_qq}},
#' \code{\link{nice_varplot}}. Tutorial:
#' \url{https://rempsyc.remi-theriault.com/articles/assumptions}
#'
#' @importFrom dplyr mutate %>% select group_by summarize rowwise
#' do rename_with across everything bind_rows c_across

#' @export
nice_var <- function(data,
                     variable,
                     group,
                     criteria = 4) {
  if (inherits(variable, "list")) {
    variable <- variable
  } else {
    variable <- as.list(variable)
  }
  # Make group as factor
  data[[group]] <- as.factor(data[[group]])
  # Make basic frame

  var.table <- lapply(variable, function(x) {
    var.table <- data %>%
      group_by(.data[[group]]) %>%
      summarize(var = stats::var(.data[[x]], na.rm = TRUE)) %>%
      t() %>%
      as.data.frame()
    cbind(x, var.table)[-1, ]
  })

  var.table <- bind_rows(var.table)

  # Format table in an acceptable format

  rownames(var.table) <- NULL
  # Make all relevant variables numeric
  var.table <- var.table %>%
    mutate(across(-1, function(x) round(as.numeric(x), 3)))
  # Add the ratio and hetero columns
  var.table <- var.table %>%
    rowwise() %>%
    mutate(
      variance.ratio = round(max(c_across(-1), na.rm = TRUE) / min(
        c_across(-1), na.rm = TRUE
      ), 1), criteria = criteria,
      heteroscedastic = variance.ratio > criteria
    )
  # Change names to something meaningful
  for (i in seq_along(levels(data[[group]]))) {
    names(var.table)[1 + i] <- levels(data[[group]])[i]
  }
  names(var.table)[1] <- group
  # Capitalize first letters
  var.table <- var.table %>%
    rename_with(tools::toTitleCase, everything())
  # Get resulting table
  as.data.frame(var.table)
}
