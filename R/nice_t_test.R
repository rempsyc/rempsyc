#' @title Easy t-tests
#'
#' @description Easily compute t-test analyses, with effect sizes, and format in publication-ready format. The 95% confidence interval is for the effect size, Cohen's d, both provided by the `effectsize` package.
#'
#' This function relies on the base R `t.test` function, which uses the Welch t-test per default (see why here: https://daniellakens.blogspot.com/2015/01/always-use-welchs-t-test-instead-of.html). To use the Student t-test, simply add the following argument: `var.equal = TRUE`.
#'
#' @param data The data frame.
#' @param response The dependent variable.
#' @param correction What correction for multiple comparison to apply, if any. Default is "none" and the only other option (for now) is "bonferroni".
#' @param group The group for the comparison.

#' @param warning Whether to display the Welch test warning or not.
#' @param ... Further arguments to be passed to the `t.test` function (e.g., to use Student instead of Welch test, to change from two-tail to one-tail, or to do a paired-sample t-test instead of independent samples).
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
#'             response = names(mtcars)[1:7],
#'             group = "am")
#'
#' # Can be passed some of the regular arguments
#' # of base `t.test()`
#'
#' # Student t-test (instead of Welch)
#' nice_t_test(data = mtcars,
#'             response = "mpg",
#'             group = "am",
#'             var.equal = TRUE)
#'
#' # One-sided instead of two-sided
#' nice_t_test(data = mtcars,
#'             response = "mpg",
#'             group = "am",
#'             alternative = "less")
#'
#' # One-sample t-test
#' nice_t_test(data = mtcars,
#'             response = "mpg",
#'             mu = 10)
#'
#' # Paired t-test instead of independent samples
#' nice_t_test(data = ToothGrowth,
#'             response = "len",
#'             group = "supp",
#'             paired = TRUE)
#' # Make sure cases appear in the same order for
#' # both levels of the grouping factor
#' @importFrom methods hasArg
#'
#' @seealso
#' Tutorial: \url{https://remi-theriault.com/blog_t-test}
#'

nice_t_test <- function(data,
                        response,
                        group = NULL,
                        correction = "none",
                        warning = TRUE,
                        ...) {
  args <- list(...)
  if (hasArg(var.equal)) {
    if(args$var.equal == TRUE) cat("Using Student t-test. \n \n ")
    if(args$var.equal == FALSE) cat("Using Welch t-test. \n \n ")
  }
  if (hasArg(paired)) {
    paired <- args$paired
    if(paired == TRUE) cat("Using paired t-test. \n \n ")
    if(paired == FALSE) cat("Using independent samples t-test. \n \n ")
  } else paired <- FALSE
  if (!hasArg(var.equal) & paired == FALSE & warning == TRUE) {
    cat("Using Welch t-test (base R's default; cf. https://doi.org/10.5334/irsp.82). \nFor the Student t-test, use `var.equal = TRUE`. \n \n ")
  }
  if(!missing(group)) {
    data[[group]] <- as.factor(data[[group]])
    formulas <- paste0(response, " ~ ", group)
  formulas <- sapply(formulas, stats::as.formula)
  } else {
    cat("Using one-sample t-test. \n \n ")
    formulas <- lapply(data[response], as.numeric)
  }
  if(hasArg(mu)) {
    mu = args$mu
  } else {mu = 0}
  mod.list <- sapply(formulas, stats::t.test, data = data, ...,
                     simplify = FALSE, USE.NAMES = TRUE)
  list.names <- c("statistic", "parameter", "p.value")
  sums.list <- lapply(mod.list, function(x) {(x)[list.names]})
  sapply(formulas, function (x) {
    effectsize::cohens_d(x,
                         data = data,
                         paired = paired,
                         mu = mu)},
    simplify = FALSE,
    USE.NAMES = TRUE) -> boot.lists
  list.stats <- list()
  for (i in 1:length(list.names)) {
    list.stats[[list.names[i]]] <- c(t((sapply(sums.list, `[[`, i))))
  }
  d <- unlist(sapply(boot.lists, function(x) {(x)["Cohens_d"]}))
  CI_lower <- sapply(boot.lists, `[[`, "CI_low")
  CI_higher <- sapply(boot.lists, `[[`, "CI_high")
  table.stats <- data.frame(response,
                            list.stats,
                            d,
                            CI_lower,
                            CI_higher)
  row.names(table.stats) <- NULL
  names(table.stats) <- c("Dependent Variable", "t", "df", "p", "d", "CI_lower", "CI_upper")
  if(correction == "bonferroni") {
    table.stats$p <- table.stats$p * nrow(table.stats)
  }
  table.stats
}
