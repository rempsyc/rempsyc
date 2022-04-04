#' @title Easy t-tests
#'
#' @description Easily compute t-test analyses, with effect sizes, and format in publication-ready format.
#'
#' @param data The data frame.
#' @param response The dependent variable.
#' @param group The group for the comparison.
#' @param ... Further arguments to be passed to the `t.test` function (e.g., to change from two-tail to one-tail).
#'
#' @keywords t-test, group differences
#' @export
#' @examples
#' # Make the basic table
#' nice_t_test(data = mtcars,
#'             response = "mpg",
#'             group = "am")
#'
#' # Multiple dependent variables at once
#' nice_t_test(data = mtcars,
#'             response = c("mpg", "disp", "drat", "wt", "qsec", "gear", "carb"),
#'             group = "am")
#'
#' # Can be passed some of the regular arguments of base `t.test()`
#' nice_t_test(data = mtcars,
#'             response = "mpg",
#'             group = "am",
#'             alternative = "less") # to make it one-sided instead of two-sided

nice_t_test <- function(data, response, group, ...) {

  data[[group]] <- as.factor(data[[group]])
  formulas <- paste0(response, " ~ ", group)
  formulas <- sapply(formulas, stats::as.formula)
  mod.list <- sapply(formulas, stats::t.test, data = data, ...,
                     simplify = FALSE, USE.NAMES = TRUE)
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
  row.names(table.stats) <- NULL
  names(table.stats) <- c("Dependent Variable", "t", "df", "p", "d", "CI_lower", "CI_upper")
  table.stats
}
