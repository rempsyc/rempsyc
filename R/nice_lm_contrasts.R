#' @title Easy planned contrasts using lm models
#'
#' @description Easily compute planned contrast analyses (pairwise
#' comparisons similar to t-tests but more powerful when more than
#' 2 groups), and format in publication-ready format. In this particular
#' case, the confidence intervals are bootstraped on chosen effect size
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
#' [bootES::bootES], and correct for contrasts but not for covariates and
#' other predictors. Because this method uses bootstrapping, it is recommended
#' to set a seed before using for reproducibility reasons (e.g.,
#' `sed.seet(100)`).
#'
#' Does not for the moment support nested comparisons for marginal means,
#' only a comparison of all groups. For nested comparisons, please use
#' [emmeans::contrast()] directly, or for the *easystats* equivalent,
#' [modelbased::estimate_contrasts()].
#'
#' When using `nice_lm_contrasts()`, please use `as.factor()` outside the
#' `lm()` formula, or it will lead to an error.
#'
#' @param model The model to be formatted.
#' @param group The group for the comparison.
#' @param data The data frame.
#' @param p_adjust Character: adjustment method (e.g., "bonferroni") – added to options
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
#' @examplesIf requireNamespace("bootES", quietly = TRUE) && requireNamespace("modelbased", quietly = TRUE)
#' # Make and format model (group need to be a factor)
#' mtcars2 <- mtcars
#' mtcars2$cyl <- as.factor(mtcars2$cyl)
#' model <- lm(mpg ~ cyl + wt * hp, mtcars2)
#' set.seed(100)
#' nice_lm_contrasts(model, group = "cyl", data = mtcars, bootstraps = 500)
#'
#' # Several models at once
#' mtcars2$gear <- as.factor(mtcars2$gear)
#' model2 <- lm(qsec ~ cyl, data = mtcars2)
#' my.models <- list(model, model2)
#' set.seed(100)
#' nice_lm_contrasts(my.models, group = "cyl", data = mtcars, bootstraps = 500)
#'
#' # Now supports more than 3 levels
#' mtcars2$carb <- as.factor(mtcars2$carb)
#' model <- lm(mpg ~ carb + wt * hp, mtcars2)
#' set.seed(100)
#' nice_lm_contrasts(model, group = "carb", data = mtcars2, bootstraps = 500)
#'
#' @seealso
#' \code{\link{nice_contrasts}},
#' Tutorial: \url{https://rempsyc.remi-theriault.com/articles/contrasts}
#'
#' @importFrom dplyr %>% bind_rows select

nice_lm_contrasts <- function(model,
                              group,
                              data,
                              p_adjust = "none",
                              effect.type = "cohens.d",
                              bootstraps = 2000,
                              ...) {
  check_col_names(data, group)
  rlang::check_installed(c("modelbased", "bootES"), reason = "for this function.")
  if (inherits(model, "list")) {
    models.list <- model
  } else {
    models.list <- list(model)
  }

  # if (length(models.list) == 1) {
  #  data <- model$model
  # }

  # if (missing(data)) {
  # data.list <- lapply(models.list, `[[`, "model")
  # data.list <- lapply(data.list, function(x) {
  #   x[[group]] = as.factor(x[[group]])
  #   x
  #   })
  # data <- Reduce(dplyr::right_join, data.list) # wrap in suppressMessages later
  # }

  data[[group]] <- as.factor(data[[group]])

  contrval.list <- suppressWarnings(
    lapply(models.list, modelbased::get_emcontrasts,
      contrast = group, adjust = p_adjust
    )
  )

  contrast <- contrval.list[[1]]@misc$con.coef

  groups.contrasts <- lapply(seq_len(nrow(contrast)), function(x) {
    z <- contrast[x, ]
    names(z) <- levels(as.factor(data[[group]]))
    z
  })

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

  boot.sums <- lapply(seq(length(response.list)), function(y) {
    lapply(es.lists, function(x) {
      as.data.frame(summary(x[[y]]))
    }) %>%
      bind_rows() %>%
      select(all_of(c("stat", "ci.low", "ci.high")))
  }) %>%
    bind_rows()

  table.stats <- contrval.list %>%
    lapply(as.data.frame) %>%
    bind_rows() %>%
    select(all_of(c("contrast", "df", "t.ratio", "p.value")))

  response.names <- rep(unlist(response.list), each = nrow(contrast))

  table.stats <- cbind(response.names, table.stats, boot.sums)

  effect.name <- dplyr::case_when(
    effect.type == "unstandardized" ~ "Mean difference",
    effect.type == "cohens.d" ~ "d",
    effect.type == "hedges.g" ~ "g",
    effect.type == "cohens.d.sigma" ~ "d_sigma",
    effect.type == "r" ~ "r",
    effect.type == "akp.robust.d" ~ "dR"
  )

  names(table.stats) <- c(
    "Dependent Variable", "Comparison", "df",
    "t", "p", effect.name, "CI_lower", "CI_upper"
  )
  row.names(table.stats) <- NULL
  table.stats
}
