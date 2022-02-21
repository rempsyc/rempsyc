#' @title Obtain variance per group
#'
#' @description Obtain variance per group as well as check for the rule of thumb of one group having variance four times bigger than any of the other groups.
#'
#' @param variable The variable
#' @param group The group
#' @param data The data
#'
#' @keywords variance
#' @export
#' @examples
#' # Make the basic table
#' nice_var(variable="Sepal.Length",
#'         group="Species",
#'         data=iris)
#'
#' # Try on multiple variables
#' DV <- names(iris[1:4])
#' var.table <- do.call("rbind", lapply(DV, nice_var, data=iris, group="Species"))
#' var.table
#'
#' @importFrom dplyr mutate %>% select group_by summarize rowwise do rename_with

nice_var <- function(variable, group, data) {
  # Make group as factor
  data[[group]] <- as.factor(data[[group]])
  # Make basic frame
  var.table <- data %>%
    group_by(.data[[group]]) %>%
    summarize(var=var(.data[[variable]])) %>%
    t %>%
    as.data.frame
  # Format table in an acceptable format
  var.table <- cbind(variable, var.table)
  var.table <- var.table[-1,]
  rownames(var.table) <- NULL
  # Make all relevant variables numeric
  var.table <- var.table %>%
    mutate(across(-variable, function(x) round(as.numeric(x),3)))
  # Add the ratio and hetero columns
  var.table %>%
    rowwise() %>%
    mutate(`Max/Min Ratio` = round(max(select(., -variable))/min(select(., -variable)),1),
           `Heteroscedastic (four times bigger)?` = `Max/Min Ratio` > 4) -> var.table
  # Change names to something meaningful
  for (i in 1:length(levels(data[[group]]))) {
    names(var.table)[1+i] <- levels(data[[group]])[i]
  }
  # Capitalize first letters
  var.table <- var.table %>%
    rename_with(tools::toTitleCase, everything())
  # Get resulting table
  var.table
}
niceVar <- nice_var
