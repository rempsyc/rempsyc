#' @title Easy t-tests
#'
#' @description Easily compute t-test analyses, with effect sizes,
#' and format in publication-ready format. The 95% confidence interval
#' is for the effect size, Cohen's d, both provided by the `effectsize` package.
#'
#' @details This function relies on the base R [t.test()] function, which
#' uses the Welch t-test per default (see why here:
#' \url{https://daniellakens.blogspot.com/2015/01/always-use-welchs-t-test-instead-of.html}).
#' To use the Student t-test, simply add the following
#' argument: `var.equal = TRUE`.
#'
#' Note that for paired *t* tests, you need to use `paired = TRUE`, and
#' you also need data in "long" format rather than wide format (like for
#' the `ToothGrowth` data set). In this case, the `group` argument refers
#' to the participant ID for example, so the same group/participant is
#' measured several times, and thus has several rows.
#'
#' For the *easystats* equivalent, use: [report::report()] on the
#' [t.test()] object.
#'
#' @param data The data frame.
#' @param response The dependent variable.
#' @param correction What correction for multiple comparison
#' to apply, if any. Default is "none" and the only other option
#' (for now) is "bonferroni".
#' @param group The group for the comparison.

#' @param warning Whether to display the Welch test warning or not.
#' @param ... Further arguments to be passed to the [t.test()]
#' function (e.g., to use Student instead of Welch test, to
#' change from two-tail to one-tail, or to do a paired-sample
#' t-test instead of independent samples).
#'
#' @keywords t-test group differences
#' @return A formatted dataframe of the specified model, with DV, degrees of
#'         freedom, t-value, p-value, the effect size, Cohen's d, and its
#'         95% confidence interval lower and upper bounds.
#' @export
#' @examplesIf requireNamespace("effectsize", quietly = TRUE)
#' # Make the basic table
#' nice_t_test(
#'   data = mtcars,
#'   response = "mpg",
#'   group = "am"
#' )
#'
#' # Multiple dependent variables at once
#' nice_t_test(
#'   data = mtcars,
#'   response = names(mtcars)[1:7],
#'   group = "am"
#' )
#'
#' # Can be passed some of the regular arguments
#' # of base [t.test()]
#'
#' # Student t-test (instead of Welch)
#' nice_t_test(
#'   data = mtcars,
#'   response = "mpg",
#'   group = "am",
#'   var.equal = TRUE
#' )
#'
#' # One-sided instead of two-sided
#' nice_t_test(
#'   data = mtcars,
#'   response = "mpg",
#'   group = "am",
#'   alternative = "less"
#' )
#'
#' # One-sample t-test
#' nice_t_test(
#'   data = mtcars,
#'   response = "mpg",
#'   mu = 10
#' )
#'
#' # Paired t-test instead of independent samples
#' # Requires data in "long" format
#' nice_t_test(
#'   data = ToothGrowth,
#'   response = "len",
#'   group = "supp",
#'   paired = TRUE
#' )
#' # Make sure cases appear in the same order for
#' # both levels of the grouping factor
#' @seealso
#' Tutorial: \url{https://rempsyc.remi-theriault.com/articles/t-test}
#'

nice_t_test <- function(data,
                        response,
                        group = NULL,
                        correction = "none",
                        warning = TRUE,
                        ...) {
  check_col_names(data, c(group, response))
  rlang::check_installed(c("effectsize", "methods"),
                         reason = "for this function.")
  args <- list(...)
  if (methods::hasArg(var.equal)) {
    if (isTRUE(args$var.equal)) {
      message_white("Using Student t-test. \n ")
    } else if (isFALSE(args$var.equal)) {
      message_white("Using Welch t-test. \n ")
    }
    pooled_sd <- args$var.equal
    } else {
      pooled_sd <- TRUE
  }
  if (methods::hasArg(paired)) {
    paired <- args$paired
    if (paired == TRUE) message_white("Using paired t-test. \n ")
    if (paired == FALSE) message_white("Using independent samples t-test. \n ")
  } else {
    paired <- FALSE
  }
  if (!methods::hasArg(var.equal) & paired == FALSE & warning == TRUE) {
    message_white(
      "Using Welch t-test (base R's default; ",
      "cf. https://doi.org/10.5334/irsp.82).
For the Student t-test, use `var.equal = TRUE`. \n "
    )
  }
  if (!missing(group)) {
    data[[group]] <- as.factor(data[[group]])
    formulas <- paste0(response, " ~ ", group)
    formulas <- lapply(formulas, stats::as.formula)
  } else {
    message_white("Using one-sample t-test. \n ")
    formulas <- lapply(data[response], as.numeric)
  }
  if (methods::hasArg(mu)) {
    mu <- args$mu
  } else {
    mu <- 0
  }
  mod.list <- lapply(formulas, stats::t.test, data = data, ...)
  list.names <- c("statistic", "parameter", "p.value")
  sums.list <- lapply(mod.list, function(x) {
    (x)[list.names]
  })
  boot.lists <- lapply(formulas, function(x) {
    effectsize::cohens_d(x,
      data = data,
      paired = paired,
      mu = mu,
      pooled_sd = pooled_sd
    )
  })
  list.stats <- list()
  for (i in seq_along(list.names)) {
    list.stats[[list.names[i]]] <- unlist(c(t((lapply(sums.list, `[[`, i)))))
  }
  d <- unlist(lapply(boot.lists, function(x) {
    (x)["Cohens_d"]
  }))
  CI_lower <- unlist(lapply(boot.lists, `[[`, "CI_low"))
  CI_higher <- unlist(lapply(boot.lists, `[[`, "CI_high"))
  table.stats <- data.frame(
    response,
    list.stats,
    d,
    CI_lower,
    CI_higher
  )
  row.names(table.stats) <- NULL
  names(table.stats) <- c(
    "Dependent Variable", "t", "df", "p",
    "d", "CI_lower", "CI_upper"
  )
  if (correction == "bonferroni") {
    table.stats$p <- table.stats$p * nrow(table.stats)
  }
  table.stats
}
