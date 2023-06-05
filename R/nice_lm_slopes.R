#' @title Nice formatting of simple slopes for lm models
#'
#' @description Extracts simple slopes from [lm()] model
#' object and format for a publication-ready format.
#'
#' @inherit nice_lm details
#'
#' @param model The model to be formatted.
#' @param predictor The independent variable.
#' @param moderator The moderating variable.
#' @param b.label What to rename the default "b" column (e.g.,
#' to capital B if using standardized data for it to be converted
#' to the Greek beta symbol in the [nice_table()] function). Now
#' attempts to automatically detect whether the variables were
#' standardized, and if so, sets `b.label = "B"` automatically.
#' Factor variables or dummy variables (only two numeric values)
#' are ignored when checking for standardization.
#' *This argument is now deprecated, please use argument
#' `standardize` directly instead.*
#' @param standardize Logical, whether to standardize the
#' data before refitting the model. If `TRUE`, automatically sets
#' `b.label = "B"`. Defaults to `FALSE`. Note that if you have factor
#' variables, these will be pseudo-betas, so these coefficients could
#' be interpreted more like Cohen's *d*.
#' @param mod.id Logical. Whether to display the model number,
#' when there is more than one model.
#' @param ci.alternative Alternative for the confidence interval
#' of the sr2. It can be either "two.sided (the default in this
#' package), "greater", or "less".
#' @param ... Further arguments to be passed to the [lm()]
#' function for the models.
#'
#' @keywords moderation interaction regression
#' @return A formatted dataframe of the simple slopes of the specified lm model,
#' with DV, levels of IV, degrees of freedom, regression coefficient,
#' t-value, p-value, and the effect size, the semi-partial correlation
#' squared, and its confidence interval.
#' @export
#' @examplesIf requireNamespace("effectsize", quietly = TRUE)
#' # Make and format model
#' model <- lm(mpg ~ gear * wt, mtcars)
#' nice_lm_slopes(model, predictor = "gear", moderator = "wt")
#'
#' # Make and format multiple models
#' model2 <- lm(qsec ~ gear * wt, mtcars)
#' my.models <- list(model, model2)
#' x <- nice_lm_slopes(my.models, predictor = "gear", moderator = "wt")
#' x
#' @examplesIf requireNamespace("effectsize", quietly = TRUE) && packageVersion("effectsize") >= "0.8.3.5"
#' # Get interpretations
#' cbind(x, Interpretation = effectsize::interpret_omega_squared(x$sr2))
#'
#' @seealso
#' Checking for moderation before checking simple slopes:
#' \code{\link{nice_lm}}, \code{\link{nice_mod}},
#' \code{\link{nice_slopes}}. Tutorial:
#' \url{https://rempsyc.remi-theriault.com/articles/moderation}
#'

nice_lm_slopes <- function(model,
                           predictor,
                           moderator,
                           b.label = "b",
                           standardize = FALSE,
                           mod.id = TRUE,
                           ci.alternative = "two.sided",
                           ...) {
  rlang::check_installed("effectsize", reason = "for this function.")
  if (inherits(model, "list") && all(unlist(lapply(model, inherits, "lm")))) {
    models.list <- model
  } else if (inherits(model, "lm")) {
    models.list <- list(model)
  } else {
    stop("Model must be of class 'lm' or be a 'list()' of lm models (using 'c()' won't work).")
  }

  lapply(models.list, function(x) {
    check_col_names(x$model, c(predictor, moderator))
  })

  if (!missing(b.label)) {
    message(paste(
      "The argument 'b.label' is deprecated.",
      "If your data is standardized, capital B will be used automatically.",
      "Else, please use argument 'standardize' directly instead."
    ))
  }

  if (model_is_standardized(models.list)) {
    b.label <- "B"
  } else if (isTRUE(standardize)) {
    data.list <- lapply(models.list, function(x) {
      scale(x$model)
    })
    models.list <- lapply(seq_along(models.list), function(i) {
      data <- as.data.frame(data.list[i])
      stats::update(models.list[[i]], data = data)
    })
    b.label <- "B"
  }

  data.list <- lapply(models.list, function(x) {
    x$model
  })

  DV.list <- unlist(lapply(models.list, function(x) {
    as.character(x$terms[[2]])
  }))

  # Calculate simple slopes for LOWS
  data.list.lows <- lapply(data.list, function(x) {
    x$lows <- unlist(x[, moderator] + sd(unlist(x[, moderator])))
    x
  })
  formulas.lows <- lapply(models.list, function(x) {
    gsub(moderator, "lows", list(x$terms))
  })
  models.list.lows <- lapply(seq(length(formulas.lows)), function(x) {
    lm(formulas.lows[[x]], data = data.list.lows[[x]], ...)
  })

  table.stats1 <- lapply(models.list.lows, nice_lm,
    ci.alternative = ci.alternative
  )
  table.stats1 <- dplyr::bind_rows(table.stats1)
  table.stats1 <- dplyr::filter(table.stats1, .data$Predictor == {{ predictor }})
  table.stats1$Predictor <- paste0(predictor, " (LOW-", moderator, ")")

  # Calculate simple slopes for mean-level
  table.stats2 <- lapply(models.list, nice_lm, ci.alternative = ci.alternative)
  table.stats2 <- dplyr::bind_rows(table.stats2)
  table.stats2 <- dplyr::filter(table.stats2, .data$Predictor == {{ predictor }})
  table.stats2$Predictor <- paste0(predictor, " (MEAN-", moderator, ")")

  # Calculate simple slopes for HIGHS
  data.list.highs <- lapply(data.list, function(x) {
    x$highs <- unlist(x[, moderator] - sd(unlist(x[, moderator])))
    x
  })
  formulas.highs <- lapply(models.list, function(x) {
    gsub(moderator, "highs", list(x$terms))
  })
  models.list.highs <- lapply(seq(length(formulas.highs)), function(x) {
    lm(formulas.highs[[x]], data = data.list.highs[[x]], ...)
  })

  table.stats3 <- lapply(models.list.highs, nice_lm,
    ci.alternative = ci.alternative
  )
  table.stats3 <- dplyr::bind_rows(table.stats3)
  table.stats3 <- dplyr::filter(table.stats3, .data$Predictor == {{ predictor }})
  table.stats3$Predictor <- paste0(predictor, " (HIGH-", moderator, ")")

  # Combine both dataframes for both LOWS and HIGHS
  table.stats <- rbind(table.stats1, table.stats2, table.stats3)
  correct.order <- c(aperm(
    array(
      seq(nrow(table.stats)),
      c(1, nrow(table.stats) / 3, 3)
    ),
    c(1, 3, 2)
  ))
  table.stats <- table.stats[correct.order, ] # 1, 4, 7, 2, 5, 8, 3, 6, 9
  table.stats <- dplyr::rename(table.stats,
    `Predictor (+/-1 SD)` = .data$Predictor
  )

  names(table.stats)[names(table.stats) == "b"] <- b.label

  if (length(models.list) > 1 & mod.id == TRUE) {
    model.number <- rep(seq_along(models.list), each = 3)
    table.stats <- stats::setNames(
      cbind(model.number, table.stats),
      c("Model Number", names(table.stats))
    )
  }
  row.names(table.stats) <- NULL
  table.stats
}
