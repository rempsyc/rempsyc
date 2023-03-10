#' @title Easy planned contrasts using lm models
#'
#' @description Easily compute planned contrast analyses (pairwise
#' comparisons similar to t-tests but more powerful when more than
#' 2 groups), and format in publication-ready format. Supports only
#' three groups for the moment. In this particular case, the
#' confidence intervals are bootstraped on chosen effect size
#' (default to Cohen's d).
#'
#' @details Statistical power is lower with the standard *t* test
#' compared than it is with the planned contrast version for two
#' reasons: a) the sample size is smaller with the *t* test,
#' because only the cases in the two groups are selected; and b)
#' in the planned contrast the error term is smaller than it is
#' with the standard *t* test because it is based on all the cases
#' ([source](https://web.pdx.edu/~newsomj/uvclass/ho_planned%20contrasts.pdf)).
#'
#' The effect size and confidence interval are calculated via
#' [bootES::bootES].
#'
#' For the *easystats* equivalent, see:
#' `modelbased::estimate_contrasts()`.
#'
#' @param model The model to be formatted.
#' @param group The group for the comparison.
#' @param data The data frame.
#' @param effect.type What effect size type to use. One of "cohens.d" (default),
#' "akp.robust.d", "unstandardized", "hedges.g", "cohens.d.sigma", or "r".
#' @param bootstraps The number of bootstraps to use for the confidence interval
#' @param ... Arguments passed to [bootES::bootES].
#' @keywords planned contrasts pairwise comparisons
#' group differences
#' @return A dataframe, with the selected dependent variable(s), comparisons of
#'         interest, degrees of freedom, t-values, p-values, Cohen's d, and the
#'         lower and upper 95% confidence intervals of the
#'         effect size (i.e., dR).
#' @export
#' @examples
#' # Make and format model (group need to be a factor)
#' model <- lm(mpg ~ as.factor(cyl) + wt * hp, mtcars)
#' nice_lm_contrasts(model, group = "cyl", data = mtcars, bootstraps = 500)
#'
#' model2 <- lm(qsec ~ as.factor(cyl), data = mtcars)
#' my.models <- list(model, model2)
#'
#' nice_lm_contrasts(my.models, group = "cyl", data = mtcars, bootstraps = 500)
#'
#' @seealso
#' \code{\link{nice_contrasts}},
#' Tutorial: \url{https://rempsyc.remi-theriault.com/articles/contrasts}
#'
#' @importFrom dplyr %>% bind_rows

nice_lm_contrasts <- function(model,
                              group,
                              data,
                              effect.type = "cohens.d",
                              bootstraps = 2000,
                              ...) {
  check_col_names(data, group)
  rlang::check_installed(c("bootES", "emmeans"), reason = "for this function.")
  if (inherits(model, "list")) {
    models.list <- model
  } else {
    models.list <- list(model)
  }

  #if (length(models.list) == 1) {
  #  data <- model$model
  #}

  #if (missing(data)) {
    # data.list <- lapply(models.list, `[[`, "model")
    # data.list <- lapply(data.list, function(x) {
    #   x[[group]] = as.factor(x[[group]])
    #   x
    #   })
    # data <- Reduce(dplyr::right_join, data.list) # wrap in suppressMessages later
  #}

  data[[group]] <- as.factor(data[[group]])
  leastsquare.list <- lapply(models.list, emmeans::emmeans, specs = group, data = data)
  groups.contrasts <- list(
    comp1 = stats::setNames(c(1, 0, -1), levels(data[[group]])),
    # Add support x groups
    comp2 = stats::setNames(c(0, 1, -1), levels(data[[group]])),
    # Add support x groups
    comp3 = stats::setNames(c(1, -1, 0), levels(data[[group]]))
  )

  response.list <- lapply(models.list, function(x) {
    as.character(attributes(x$terms)$variables[[2]])
  })

  # Add support x groups
  es.lists <- lapply(groups.contrasts, function(y) {
    lapply(response.list, function(x) {
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

  boot.sums <- lapply(seq(length(response.list)), function(y) {
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
  response.names <- rep(unlist(response.list), each = length(contrval.sums[[1]]$contrast))
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
    times = length(response.list)
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
