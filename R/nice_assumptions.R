#' @title Easy assumptions checks
#'
#' @description Test linear regression assumptions easily with a
#' nice summary table.
#'
#' @param model The `lm` object to be passed to the function.
#' @param interpretation Whether to display the interpretation helper or not.
#'
#' @keywords assumptions linear regression statistical violations
#' @export
#' @examples
#' # Create a regression model (using data available in R by default)
#' model <- lm(mpg ~ wt * cyl + gear, data = mtcars)
#' nice_assumptions(model)
#'
#' # Multiple dependent variables at once
#' DV <- names(mtcars[-1])
#' formulas <- paste(DV, "~ mpg")
#' models.list <- lapply(X = formulas, FUN = lm, data = mtcars)
#' assumptions.table <- do.call("rbind", lapply(models.list, nice_assumptions,
#'   interpretation = FALSE
#' ))
#' assumptions.table
#'
#' @seealso
#' Other functions useful in assumption testing:
#' \code{\link{nice_density}}, \code{\link{nice_normality}},
#' \code{\link{nice_qq}}, \code{\link{nice_varplot}},
#' \code{\link{nice_var}}. Tutorial:
#' \url{https://rempsyc.remi-theriault.com/articles/assumptions}
#'

nice_assumptions <- function(model,
                             interpretation = TRUE) {
  model.name <- format(model$terms)
  shapiro <- round(stats::shapiro.test(model$residuals)$p.value, 3)
  bp <- round(lmtest::bptest(model)$p.value, 3)
  dw <- round(lmtest::dwtest(model)$p.value, 3)
  dg <- sum(shapiro < .05, bp < .05, dw < .05)
  df <- data.frame(
    "Model..." = model.name,
    "Normality (Shapiro-Wilk)..." = shapiro,
    "Homoscedasticity (Breusch-Pagan)..." = bp,
    "Autocorrelation of residuals (Durbin-Watson)..." = dw,
    "Diagnostic..." = dg,
    check.names = FALSE
  )
  row.names(df) <- NULL
  if (interpretation == TRUE) {
    cat(
      "Interpretation: (p) values < .05 imply assumptions are not respected. ",
      "Diagnostic is how many assumptions are not respected for a given model ",
      "or variable. \n\n",
      sep = ""
    )
  }
  df
}
