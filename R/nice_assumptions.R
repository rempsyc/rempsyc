#' @title Easy assumptions checks
#'
#' @description Test linear regression assumptions easily with a
#' nice summary table.
#'
#' @param model The [lm()] object to be passed to the function.
#'
#' @details Interpretation: (p) values < .05 imply assumptions are
#' not respected. Diagnostic is how many assumptions are not
#' respected for a given model or variable.
#' @keywords assumptions linear regression statistical violations
#' @return A dataframe, with p-value results for the Shapiro-Wilk,
#'         Breusch-Pagan, and Durbin-Watson tests, as well as a
#'         diagnostic column reporting how many assumptions are
#'         not respected for a given model.
#'         Shapiro-Wilk is set to NA if n < 3 or n > 5000.
#' @export
#' @examplesIf requireNamespace("lmtest", quietly = TRUE)
#' # Create a regression model (using data available in R by default)
#' model <- lm(mpg ~ wt * cyl + gear, data = mtcars)
#' nice_assumptions(model)
#'
#' # Multiple dependent variables at once
#' model2 <- lm(qsec ~ disp + drat * carb, mtcars)
#' my.models <- list(model, model2)
#' nice_assumptions(my.models)
#'
#' @seealso
#' Other functions useful in assumption testing:
#' \code{\link{nice_density}}, \code{\link{nice_normality}},
#' \code{\link{nice_qq}}, \code{\link{nice_varplot}},
#' \code{\link{nice_var}}. Tutorial:
#' \url{https://rempsyc.remi-theriault.com/articles/assumptions}
#'

#' @export
nice_assumptions <- function(model) {
  rlang::check_installed("lmtest", reason = "for this function.")
  if (inherits(model, "list")) {
    models.list <- model
  } else {
    models.list <- list(model)
  }
  model.name <- lapply(models.list, function(x) {
    format(x$terms)
  })
  shapiro <- lapply(models.list, function(x) {
    if(length(x$residuals) > 5000 || length(x$residuals) < 4) {
      message("Sample size must be between 4 and 5000 for shapiro.test(); ",
              "returning NA.")
      return(NA)
    }
    stats::shapiro.test(x$residuals)$p.value
  })
  bp <- lapply(models.list, function(x) {
    lmtest::bptest(x)$p.value
  })
  dw <- lapply(models.list, function(x) {
    lmtest::dwtest(x)$p.value
  })

  df <- list(model.name, shapiro, bp, dw)
  df <- lapply(df, unlist)
  df <- mapply(cbind, df, SIMPLIFY = FALSE) %>%
    as.data.frame()

  names(df) <- c("Model", "shapiro", "bp", "dw")
  df <- df %>%
    dplyr::mutate(dplyr::across(where(is.numeric), \(x) round(x, 3)),
      Diagnostic = rowSums(dplyr::select(., shapiro:dw) < .05, na.rm = TRUE)
    )

  names(df) <- c(
    "Model", "Normality (Shapiro-Wilk)",
    "Homoscedasticity (Breusch-Pagan)",
    "Autocorrelation of residuals (Durbin-Watson)",
    "Diagnostic"
  )

  row.names(df) <- NULL
  class(df) <- c("nice_assumptions", class(df))
  df
}
