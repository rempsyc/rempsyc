#' @title Easy t-tests
#'
#' @description Easily compute t-test analyses, with effect sizes, and format in publication-ready format.
#'
#' @param dataframe The dataframe
#'
#' @keywords t-test, group differences
#' @export
#' @examples
#' # Make the basic table
#' nice_t_test(response = "mpg",
#'             group = "am",
#'             data = mtcars)
#'
#' # Multiple dependent variables at once
#' nice_t_test(response = c("mpg", "disp", "drat", "wt", "qsec", "gear", "carb"),
#'             group = "am",
#'             data = mtcars)
#'
#' # Can be passed some of the regular arguments of base `t.test()`
#' nice_t_test(response = "mpg",
#'             group = "am",
#'             data = mtcars,
#'             alternative = "less") # to make it one-sided instead of two-sided

nice_t_test <- function(response, group, data, ...) {

  data[[group]] <- as.factor(data[[group]])
  formulas <- paste0(response, " ~ ", group)
  formulas <- sapply(formulas, as.formula)
  mod.list <- sapply(formulas, t.test, data = data, ..., simplify = FALSE, USE.NAMES = TRUE)
  list.names <- c("statistic", "parameter", "p.value")
  sums.list <- lapply(mod.list, function(x) {(x)[list.names]})
  sapply(formulas, function (x) {
    effsize::cohen.d(x,
                     data = data)},
    simplify = FALSE,
    USE.NAMES = TRUE) -> boot.lists
  list.stats <- list()
  for (i in 1:length(list.names)) {
    list.stats[[list.names[i]]] <- c(t((sapply(sums.list, `[[`, i))))
  }
  d <- unlist(sapply(boot.lists, function(x) {(x)["estimate"]}))
  ci <- sapply(boot.lists, function(x) {(x)["conf.int"]})
  CI_lower <- sapply(ci, `[`, "lower")
  CI_higher <- sapply(ci, `[`, "upper")
  table.stats <- data.frame(response,
                            list.stats,
                            d,
                            CI_lower,
                            CI_higher)
  names(table.stats) <- c("Dependent Variable", "t", "df", "p", "d", "CI_lower", "CI_upper")
  table.stats
}
