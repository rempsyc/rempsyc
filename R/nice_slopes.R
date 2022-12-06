#' @title Easy simple slopes
#'
#' @description Easily compute simple slopes in moderation analysis,
#' with effect sizes, and format in publication-ready format.
#'
#' @details The effect size (semi-partial correlation squared, also
#' known as delta R2), is computed through [effectsize::r2_semipartial].
#' Please read the documentation for that function, especially regarding
#' the interpretation of the confidence interval. By default, it uses a
#' one-sided alternative ("greater"), since the sr2, like the R2, cannot
#' be negative, with the upper bound fixed to 1.
#'
#' @param data The data frame
#' @param response The dependent variable.
#' @param predictor The independent variable
#' @param moderator The moderating variable.
#' @param moderator2 The second moderating variable, if applicable.
#' @param covariates The desired covariates in the model.
#' @param b.label What to rename the default "b" column
#' (e.g., to capital B if using standardized data for it
#' to be converted to the Greek beta symbol in the `nice_table`
#' function).
#' @param mod.id Logical. Whether to display the model number,
#' when there is more than one model.
#' @param ... Further arguments to be passed to the `lm`
#' function for the models.
#'
#' @keywords simple slopes moderation interaction regression
#' @return A formatted dataframe of the simple slopes of the specified lm
#'         model, with DV, levels of IV, degrees of freedom, regression
#'         coefficient, t-value, p-value, and the effect size, the
#'         semi-partial correlation squared, and its confidence interval.
#' @export
#' @examples
#' # Make the basic table
#' nice_slopes(
#'   data = mtcars,
#'   response = "mpg",
#'   predictor = "gear",
#'   moderator = "wt"
#' )
#'
#' # Multiple dependent variables at once
#' nice_slopes(
#'   data = mtcars,
#'   response = c("mpg", "disp", "hp"),
#'   predictor = "gear",
#'   moderator = "wt"
#' )
#'
#' # Add covariates
#' nice_slopes(
#'   data = mtcars,
#'   response = "mpg",
#'   predictor = "gear",
#'   moderator = "wt",
#'   covariates = c("am", "vs")
#' )
#'
#' # Three-way interaction (continuous moderator and binary
#' # second moderator required)
#' nice_slopes(
#'   data = mtcars,
#'   response = "mpg",
#'   predictor = "gear",
#'   moderator = "wt",
#'   moderator2 = "am"
#' )
#'
#' @seealso
#' Checking for moderation before checking simple slopes:
#' \code{\link{nice_mod}}, \code{\link{nice_lm}},
#' \code{\link{nice_lm_slopes}}. Tutorial:
#' \url{https://rempsyc.remi-theriault.com/articles/moderation}
#'
#' @importFrom stats lm sd

nice_slopes <- function(data,
                        response,
                        predictor,
                        moderator,
                        moderator2 = NULL,
                        covariates = NULL,
                        b.label,
                        mod.id = TRUE,
                        ...) {
  if (!missing(covariates)) {
    covariates.term <- paste("+", covariates, collapse = " ")
  } else {
    covariates.term <- ""
  }
  if (!missing(moderator2)) {
    moderator2.term <- paste("*", moderator2, collapse = " ")
  } else {
    moderator2.term <- ""
  }

  # Generate formulas, models, and simple slopes
  formulas <- paste(
    response, "~", predictor, "*", moderator,
    moderator2.term, covariates.term
  )
  models.list <- lapply(formulas, lm, data = data, ...)

  table.stats <- nice_lm_slopes(models.list, predictor = predictor, moderator = moderator)

  if (missing(moderator2)) {
    return(table.stats)
  }

  if (!missing(moderator2)) { # Repeat steps for other level of the moderator

    # Add a column about moderator to the first column
    table.stats <- dplyr::rename(table.stats, Predictor = .data$`Predictor (+/-1 SD)`)
    table.stats[moderator2] <- 0
    table.stats <- dplyr::select(table.stats, `Dependent Variable`,
                                 dplyr::all_of(moderator2),
                                 .data$Predictor:.data$CI_upper)

    # Recode dichotomic group variable moderator2
    data[moderator2] <- ifelse(data[moderator2] == "0", 1, 0)

    # Generate formulas, models, and simple slopes
    formulas <- paste(
      response, "~", predictor, "*", moderator,
      moderator2.term, covariates.term
    )
    models.list <- lapply(formulas, lm, data = data, ...)

    table2.stats <- nice_lm_slopes(models.list, predictor = predictor, moderator = moderator)

    # Add a column for moderator2
    table2.stats <- dplyr::rename(table2.stats, Predictor = .data$`Predictor (+/-1 SD)`)
    table2.stats[moderator2] <- 1
    table2.stats <- dplyr::select(table2.stats, `Dependent Variable`,
                                  dplyr::all_of(moderator2),
                                  .data$Predictor:.data$CI_upper)

    # Merge with the first table
    final.table <- rbind(table.stats, table2.stats)
    final.table <- final.table %>% dplyr::arrange(
      dplyr::desc(`Dependent Variable`)
    )
    final.table <- dplyr::rename(final.table, `Predictor (+/-1 SD)` = .data$Predictor)
    if (!missing(b.label)) {
      names(final.table)[names(
        final.table
      ) == "b"] <- b.label
    }
    if (length(models.list) > 1 & mod.id == TRUE) {
      model.number <- rep(seq_along(response), each = 3 * 2)
      final.table <- stats::setNames(cbind(model.number, final.table),
                              c("Model Number", names(final.table)))
      row.names(final.table) <- NULL
    }
    final.table
  }
}
