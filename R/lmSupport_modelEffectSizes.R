#' @title Get effect sizes (lmSupport::modelEffectSizes)
#'
#' @description Get effect sizes from the `lmSupport` package
#' and `modelEffectSizes` function. The function had to be taken
#' separately from the package as the package was removed from
#' CRAN and the dependency was failing.
#'
#' From the original documentation: "Calculates unique SSRs, SSE,
#' SST. Based on these SSs, it calculates partial eta2 and delta
#' R2 for all effects in a linear model object. For categorical
#' variables coded as factors, it calculates these for multi-df
#' effect. Manually code regressors to get 1 df effects Uses
#' car::Anova() with Type 3 error"
#'
#' @param Model	 a linear model, produced by lm
#' @param Print Display results to screen. Default = TRUE
#' @param Digits Number of digits for printing effect sizes
#'
#' @return Returns a list with fields for effect sizes, SSE, and SST.
#' @export
#' @author John J. Curtin, \email{jjcurtin@wisc.edu}
#' @keywords internal moderation interaction regression effect size internal
#' @examples
#' \donttest{
#' m <- lm(mpg ~ cyl + disp, data = mtcars)
#' lmSupport_modelEffectSizes(m)
#' }
#'
lmSupport_modelEffectSizes <- function(Model,
                                       Print = TRUE,
                                       Digits = 4) {
  HasIntercept <- (attr(Model$terms, "intercept"))
  tANOVA <- car::Anova(Model, type = 3)
  nEffects <- nrow(tANOVA) - 1
  tSS <- matrix(NA, nEffects, 4)
  rownames(tSS) <- c(row.names(tANOVA)[1:(nEffects)])
  colnames(tSS) <- c(
    "SSR", "df", "pEta-sqr",
    "dR-sqr"
  )
  SSE <- sum(stats::residuals(Model)^2)
  SST <- sum((Model$model[, 1] - mean(Model$model[, 1]))^2)
  tSS[1:nEffects, 1] <- tANOVA[1:nEffects, 1]
  tSS[1:nEffects, 2] <- tANOVA[1:nEffects, 2]
  tSS[1:nEffects, 3] <- tSS[1:nEffects, 1] / (SSE + tSS[
    1:nEffects,
    1
  ])
  if (HasIntercept && nEffects > 1) {
    tSS[2:nEffects, 4] <- tSS[2:nEffects, 1] / SST
  }
  Results <- list(Effects = tSS, SSE = SSE, SST = SST)
  if (Print) {
    print(Model$call)
    cat("\n", "Coefficients\n", sep = "")
    print(round(Results$Effects, digits = Digits))
    cat(sprintf(
      "\nSum of squared errors (SSE): %.1f\n",
      Results$SSE
    ), sep = "")
    cat(sprintf(
      "Sum of squared total  (SST): %.1f\n",
      Results$SST
    ), sep = "")
  }
  invisible(Results)
}
