#' @title Nice formatting of simple slopes for lm models
#'
#' @description Extracts simple slopes from `lm` model
#' object and format for a publication-ready format.
#'
#' Note: this function uses the `modelEffectSizes` function
#' from the `lmSupport` package to get the sr2 effect sizes.
#'
#' @param model The model to be formatted.
#' @param predictor The independent variable.
#' @param moderator The moderating variable.
#' @param b.label What to rename the default "b" column (e.g.,
#' to capital B if using standardized data for it to be converted
#' to the Greek beta symbol in the `nice_table` function).
#' @param mod.id Logical. Whether to display the model number,
#' when there is more than one model.
#' @param ... Further arguments to be passed to the `lm`
#' function for the models.
#'
#' @keywords moderation interaction regression
#' @export
#' @examples
#' # Make and format model
#' model <- lm(mpg ~ gear * wt, mtcars)
#' nice_lm_slopes(model, predictor = "gear", moderator = "wt")
#'
#' # Make and format multiple models
#' model2 <- lm(qsec ~ gear * wt, mtcars)
#' my.models <- list(model, model2)
#' nice_lm_slopes(my.models, predictor = "gear", moderator = "wt")
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
                           mod.id = TRUE,
                           ...) {
  ifelse(class(model) == "list",
    models.list <- model,
    models.list <- list(model)
  )

  good.names <- c(
    "Dependent Variable", "Predictor (+/-1 SD)",
    "df", "b", "t", "p", "sr2"
  )

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
  sums.list <- lapply(models.list.lows, function(x) {
    summary(x)$coefficients[-1, -2]
  })
  df.list <- lapply(models.list.lows, function(x) x[["df.residual"]])
  ES.list <- lapply(models.list.lows, function(x) {
    lmSupport_modelEffectSizes(x, Print = FALSE)$Effects[-1, 4]
  })
  stats.list <- mapply(cbind, df.list, sums.list, ES.list, SIMPLIFY = FALSE)
  stats.list <- lapply(stats.list, function(x) x[predictor, ])
  table.stats1 <- do.call(rbind.data.frame, stats.list)
  predictor.names <- paste0(predictor, " (LOW-", moderator, ")")
  table.stats1 <- cbind(DV.list, predictor.names, table.stats1)
  names(table.stats1) <- good.names

  # Calculate simple slopes for mean-level
  sums.list <- lapply(models.list, function(x) {
    summary(x)$coefficients[-1, -2]
  })
  df.list <- lapply(models.list, function(x) x[["df.residual"]])
  ES.list <- lapply(models.list, function(x) {
    lmSupport_modelEffectSizes(x, Print = FALSE)$Effects[-1, 4]
  })
  stats.list <- mapply(cbind, df.list, sums.list, ES.list, SIMPLIFY = FALSE)
  stats.list <- lapply(stats.list, function(x) x[predictor, ])
  table.stats2 <- do.call(rbind.data.frame, stats.list)
  predictor.names <- paste0(predictor, " (MEAN-", moderator, ")")
  table.stats2 <- cbind(DV.list, predictor.names, table.stats2)
  names(table.stats2) <- good.names

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
  sums.list <- lapply(models.list.highs, function(x) {
    summary(x)$coefficients[-1, -2]
  })
  df.list <- lapply(models.list.highs, function(x) x[["df.residual"]])
  ES.list <- lapply(models.list.highs, function(x) {
    lmSupport_modelEffectSizes(x, Print = FALSE)$Effects[-1, 4]
  })
  stats.list <- mapply(cbind, df.list, sums.list, ES.list, SIMPLIFY = FALSE)
  stats.list <- lapply(stats.list, function(x) x[predictor, ])
  table.stats3 <- do.call(rbind.data.frame, stats.list)
  predictor.names <- paste0(predictor, " (HIGH-", moderator, ")")
  table.stats3 <- cbind(DV.list, predictor.names, table.stats3)
  names(table.stats3) <- good.names

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

  if (!missing(b.label)) {
    names(table.stats)[names(
      table.stats
    ) == "b"] <- b.label
  }
  if (length(models.list) > 1 & mod.id == TRUE) {
    model.number <- rep(seq_along(models.list), times = lapply(sums.list, nrow))
    table.stats <- cbind(model.number, table.stats)
    names(table.stats) <- c("Model Number", good.names)
  }
  row.names(table.stats) <- NULL
  table.stats
}
