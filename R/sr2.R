#' Semi-Partial Correlation Squared (Delta R2) [Deprecated]
#'
#' `r lifecycle::badge("deprecated")`
#'
#' Compute the semi-partial correlation squared (also known as the delta
#' R2), for a `lm` model.
#'
#' @param model An `lm` model.
#' @param ... Arguments passed to `lm`.
#'   these can be `subset` and `na.action`.
#'
#' @return A data frame with the effect size.
#'
#' @family effect size correlation
#'
#' @examples
#' \dontrun{
#' m <- lm(mpg ~ cyl + disp + hp * drat, data = mtcars)
#' sr2(m)
#' }
#' @export

sr2 <- function(model, ...) {
  .Deprecated("effectsize::r2_semipartial")
  rlang::check_installed(c("performance", "insight"),
                         reason = "for this function.")
  data <- insight::get_data(model)
  response <- insight::find_response(model)

  list.parameters <- insight::find_parameters(model)$conditional[-1]
  list.parameters.all <- lapply(seq(list.parameters), function(x) {
    list.parameters[-x]
  })

  formulas <- lapply(list.parameters.all, function(x) {
    x <- paste0(x, collapse = " + ")
    paste(response, "~", x)
  })

  list.models <- lapply(formulas, stats::lm, data = data, ...)

  r_total <- performance::r2(model)$R2
  list.R2 <- lapply(list.models, performance::r2, data = data)
  list.sr2 <- lapply(list.R2, function(x) {
    r_total - x$R2
  })

  data.frame(
    Parameter = list.parameters,
    sr2 = unlist(list.sr2)
  )
}
