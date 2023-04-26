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
#' @param boot Logical, whether to use bootstrapping for the confidence
#' interval or not.
#' @param bootstraps The number of bootstraps to use for the confidence interval
#' @param ... Arguments passed to [bootES::bootES].
#' @keywords planned contrasts pairwise comparisons
#' group differences
#' @return A dataframe, with the selected dependent variable(s), comparisons of
#'         interest, degrees of freedom, t-values, p-values, robust Cohen's d
#'         (dR), and the lower and upper 95% confidence intervals of the
#'         effect size (i.e., dR).
#' @export
#' @examples
#' # Basic example
#' nice_contrasts(
#'   data = mtcars,
#'   response = "mpg",
#'   group = "cyl",
#'   bootstraps = 200
#' )
#' \donttest{
#' nice_contrasts(
#'   data = mtcars,
#'   response = "disp",
#'   group = "gear"
#' )
#'
#' # Multiple dependent variables
#' nice_contrasts(
#'   data = mtcars,
#'   response = c("mpg", "disp", "hp"),
#'   group = "cyl"
#' )
#'
#' # Adding covariates
#' nice_contrasts(
#'   data = mtcars,
#'   response = "mpg",
#'   group = "cyl",
#'   covariates = c("disp", "hp")
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
                           boot = FALSE,
                           bootstraps = 2000,
                           ...) {
  check_col_names(data, c(group, response, covariates))
  rlang::check_installed(c("bootES", "emmeans"), reason = "for this function.")
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
  leastsquare.list <- lapply(models.list, emmeans::emmeans, group, data = data)
  groups.contrasts <- list(
    comp1 = stats::setNames(c(1, 0, -1), levels(data[[group]])),
    # Add support x groups
    comp2 = stats::setNames(c(0, 1, -1), levels(data[[group]])),
    # Add support x groups
    comp3 = stats::setNames(c(1, -1, 0), levels(data[[group]]))
  )

  # Add support x groups
  if (isFALSE(boot)) {
    bootstraps <- 0
  }
  es.lists <- lapply(groups.contrasts, function(y) {
    lapply(response, function(x) {
      bootES::bootES(
        data = stats::na.omit(data[, c(group, x)]),
        R = bootstraps,
        data.col = x,
        group.col = group,
        contrast = y,
        effect.type = effect.type,
        ...
      )
    })
  })

  contrval.list <- lapply(leastsquare.list, emmeans::contrast,
    groups.contrasts,
    adjust = "none"
  )
  contrval.sums <- lapply(contrval.list, summary)

  boot.sums <- lapply(seq(length(response)), function(y) {
    lapply(es.lists, function(x) {
      as.data.frame(summary(x[[y]]))
        }) %>%
      bind_rows
  })
  list.names <- c("estimates", "SE", "df", "tratio", "pvalue")
  stats.list <- list()
  for (i in seq_along(list.names)) {
    stats.list[[list.names[i]]] <- unlist(c(t((
      lapply(contrval.sums, `[[`, i + 1)))))
  }
  response.names <- rep(response, each = length(contrval.sums[[1]]$contrast))
  comparisons.names <- rep(
    c(
      paste(
        levels(data[[group]])[1], "-",
        levels(data[[group]])[3]
      ), ###### support x groups
      paste(
        levels(data[[group]])[2], "-",
        levels(data[[group]])[3]
      ), ###### support x groups
      paste(
        levels(data[[group]])[1], "-",
        levels(data[[group]])[2]
      )
    ), ###### support x groups
    times = length(response)
  )
  table.stats <- data.frame(
    response.names,
    comparisons.names,
    stats.list[-c(1:2)],
    bind_rows(boot.sums)[1:3]
  )

  effect.name <- dplyr::case_when(
    effect.type == "unstandardized" ~ "Mean difference",
    effect.type == "cohens.d" ~ "d",
    effect.type == "hedges.g" ~ "g",
    effect.type == "cohens.d.sigma" ~ "d_sigma",
    effect.type == "r" ~ "r",
    effect.type == "akp.robust.d" ~ "dR")

  names(table.stats) <- c(
    "Dependent Variable", "Comparison", "df",
    "t", "p", effect.name, "CI_lower", "CI_upper"
  )
  row.names(table.stats) <- NULL
  table.stats
}
