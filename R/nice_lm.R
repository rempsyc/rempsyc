#' @title Nice formatting of lm models
#'
#' @description Formats output of `lm` model object for a
#' publication-ready format.
#'
#' @details The effect size, sr2 (semi-partial correlation squared, also
#' known as delta R2), is computed through [effectsize::r2_semipartial].
#' Please read the documentation for that function, especially regarding
#' the interpretation of the confidence interval. In `rempsyc`, instead
#' of using the default one-sided alternative ("greater"), we use the
#' two-sided alternative.
#'
#' @param model The model to be formatted.
#' @param b.label What to rename the default "b" column (e.g.,
#' to capital B if using standardized data for it to be converted
#' to the Greek beta symbol in the `nice_table` function).
#' @param mod.id Logical. Whether to display the model number,
#' when there is more than one model.
#' @param ci.alternative Alternative for the confidence interval
#' of the sr2. It can be either "two.sided (the default in this
#' package), "greater", or "less".
#' @param ... Further arguments to be passed to the
#' [effectsize::r2_semipartial] function for the effect size.
#'
#' @keywords moderation interaction regression
#' @return A formatted dataframe of the specified lm model, with DV, IV, degrees
#'         of freedom, regression coefficient, t-value, p-value, and the effect
#'         size, the semi-partial correlation squared, and its confidence interval.
#' @export
#' @examples
#' # Make and format model
#' model <- lm(mpg ~ cyl + wt * hp, mtcars)
#' nice_lm(model)
#'
#' # Make and format multiple models
#' model2 <- lm(qsec ~ disp + drat * carb, mtcars)
#' my.models <- list(model, model2)
#' nice_lm(my.models)
#'
#' @seealso
#' Checking simple slopes after testing for moderation:
#' \code{\link{nice_lm_slopes}}, \code{\link{nice_mod}},
#' \code{\link{nice_slopes}}. Tutorial:
#' \url{https://rempsyc.remi-theriault.com/articles/moderation}
#'

nice_lm <- function(model,
                    b.label = "b",
                    mod.id = TRUE,
                    ci.alternative = "two.sided",
                    ...) {
  ifelse(class(model) == "list",
    models.list <- model,
    models.list <- list(model)
  )
  sums.list <- lapply(models.list, function(x) {
    summary(x)$coefficients[-1, -2]
  })
  df.list <- lapply(models.list, function(x) x["df.residual"])
  ES.list <- lapply(models.list, function(x) {
    z <- effectsize::r2_semipartial(x, alternative = ci.alternative, ...)
    dplyr::select(z, "r2_semipartial", "CI_low", "CI_high")
  })
  stats.list <- mapply(cbind, df.list, sums.list, ES.list, SIMPLIFY = FALSE)
  stats.list <- lapply(stats.list, function(x) {
    x <- as.data.frame(x)
    IV <- row.names(x)
    x <- cbind(IV, x)
  })
  table.stats <- do.call(rbind.data.frame, stats.list)
  response.names <- unlist(lapply(models.list, function(x) {
    rep(as.character(x$terms[[2]]), each = length(x$assign) - 1)
  }))
  row.names(table.stats) <- NULL
  table.stats <- cbind(response.names, table.stats)
  good.names <- c(
    "Dependent Variable", "Predictor",
    "df", "b", "t", "p", "sr2", "CI_lower", "CI_upper"
  )
  if (length(models.list) > 1 & mod.id == TRUE) {
    model.number <- rep(seq_along(models.list), times = lapply(sums.list, nrow))
    table.stats <- cbind(model.number, table.stats)
    names(table.stats) <- c("Model Number", good.names)
  } else {
    names(table.stats) <- good.names
  }
  if (!missing(b.label)) {
    names(table.stats)[names(
      table.stats
    ) == "b"] <- b.label
  }
  table.stats
}
