#' @title Easy t-tests
#'
#' @description Easily compute t-test analyses, with effect sizes, and format in publication-ready format. The 95% confidence interval is for the effect size (Cohen's d).
#'
#' This function relies on the base R `t.test` function, which uses the Welch t-test per default (see why here: https://daniellakens.blogspot.com/2015/01/always-use-welchs-t-test-instead-of.html). To use the Student t-test, simply add the following argument: `var.equal = TRUE`.
#'
#' @param data The data frame.
#' @param response The dependent variable.
#' @param group The group for the comparison.
#' @param warning Whether to display the Welch test warning or not.
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

nice_t_test <- function(data, response, group, warning = TRUE, ...) {
  if (warning == TRUE) {
    cat("Welch t-test (base R's default; cf. https://doi.org/10.5334/irsp.82). \nFor the Student t-test, use `var.equal = TRUE`. \n \n ")
  }
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
