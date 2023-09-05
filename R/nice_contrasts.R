#' @title Easy planned contrasts
#'
#' @inherit nice_lm_contrasts description details return
#'
#' @param response The dependent variable.
#' @param group The group for the comparison.
#' @param covariates The desired covariates in the model.
#' @param data The data frame.
#' @param effect.type What effect size type to use. One of "cohens.d" (default),
#' "akp.robust.d", "unstandardized", "hedges.g", "cohens.d.sigma", or "r".
#' @param bootstraps The number of bootstraps to use for the confidence interval
#' @param ... Arguments passed to [bootES::bootES].
#' @keywords planned contrasts pairwise comparisons
#' group differences
#' @export
#' @examplesIf requireNamespace("bootES", quietly = TRUE) && requireNamespace("modelbased", quietly = TRUE)
#' # Basic example
#' set.seed(100)
#' nice_contrasts(
#'   data = mtcars,
#'   response = "mpg",
#'   group = "cyl",
#'   bootstraps = 200
#' )
#' \donttest{
#' set.seed(100)
#' nice_contrasts(
#'   data = mtcars,
#'   response = "disp",
#'   group = "gear"
#' )
#'
#' # Multiple dependent variables
#' set.seed(100)
#' nice_contrasts(
#'   data = mtcars,
#'   response = c("mpg", "disp", "hp"),
#'   group = "cyl"
#' )
#'
#' # Adding covariates
#' set.seed(100)
#' nice_contrasts(
#'   data = mtcars,
#'   response = "mpg",
#'   group = "cyl",
#'   covariates = c("disp", "hp")
#' )
#'
#' # Now supports more than 3 levels
#' mtcars2 <- mtcars
#' mtcars2$carb <- as.factor(mtcars2$carb)
#' set.seed(100)
#' nice_contrasts(
#'   data = mtcars,
#'   response = "mpg",
#'   group = "carb",
#'   bootstraps = 200
#' )
#' }
#' @seealso
#' \code{\link{nice_lm_contrasts}},
#' Tutorial: \url{https://rempsyc.remi-theriault.com/articles/contrasts}
#'
#' @importFrom dplyr %>% bind_rows

nice_contrasts <- function(response,
                           group,
                           covariates = NULL,
                           data,
                           effect.type = "cohens.d",
                           bootstraps = 2000,
                           ...) {
  check_col_names(data, c(group, response, covariates))
  rlang::check_installed(c("bootES", "modelbased"), reason = "for this function.")
  data[[group]] <- as.factor(data[[group]])
  data[response] <- lapply(data[response], as.numeric)
  if (!missing(covariates)) {
    data[covariates] <- lapply(data[covariates], as.numeric)
    covariates.term <- paste("+", covariates, collapse = " ")
  } else {
    covariates.term <- ""
  }
  formulas <- paste(
    response, "~", group,
    covariates.term
  ) ### Add support for moderator(s)
  models.list <- lapply(formulas, lm, data = data)

  table.stats <- nice_lm_contrasts(
    models.list,
    group = group, data = data,
    effect.type = effect.type, bootstraps = bootstraps
  )
  table.stats
}
