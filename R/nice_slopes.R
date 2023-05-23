#' @title Easy simple slopes
#'
#' @description Easily compute simple slopes in moderation analysis,
#' with effect sizes, and format in publication-ready format.
#'
#' @inherit nice_lm details
#' @inherit nice_lm_slopes return
#'
#' @param data The data frame
#' @param response The dependent variable.
#' @param predictor The independent variable
#' @param moderator The moderating variable.
#' @param moderator2 The second moderating variable, if applicable.
#' At this time, the second moderator variable can only be a
#' binary variable of the form `c(0, 1)`.
#' @param covariates The desired covariates in the model.
#' @param b.label What to rename the default "b" column
#' (e.g., to capital B if using standardized data for it
#' to be converted to the Greek beta symbol in the [nice_table()]
#' function). Now attempts to automatically detect whether the
#' variables were standardized, and if so, sets `b.label = "B"`
#' automatically. Factor variables or dummy variables (only two
#' numeric values) are ignored when checking for standardization.
#' *This argument is now deprecated, please use
#' argument `standardize` directly instead.*
#' @param standardize Logical, whether to standardize the
#' data before fitting the model. If TRUE, automatically sets
#' `b.label = "B"`. Defaults to `TRUE`.
#' @param mod.id Logical. Whether to display the model number,
#' when there is more than one model.
#' @param ci.alternative Alternative for the confidence interval
#' of the sr2. It can be either "two.sided (the default in this
#' package), "greater", or "less".
#' @param ... Further arguments to be passed to the [lm()]
#' function for the models.
#'
#' @keywords simple slopes moderation interaction regression
#' @export
#' @examplesIf requireNamespace("effectsize", quietly = TRUE)
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
#' x <- nice_slopes(
#'   data = mtcars,
#'   response = "mpg",
#'   predictor = "gear",
#'   moderator = "wt",
#'   moderator2 = "am"
#' )
#' x
#' @examplesIf requireNamespace("effectsize", quietly = TRUE) & packageVersion("effectsize") >= "0.8.3.5"
#' # Get interpretations
#' cbind(x, Interpretation = effectsize::interpret_omega_squared(x$sr2))
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
                        b.label = "b",
                        standardize = TRUE,
                        mod.id = TRUE,
                        ci.alternative = "two.sided",
                        ...) {
  check_col_names(data, c(predictor, response, moderator, moderator2, covariates))
  rlang::check_installed("effectsize", reason = "for this function.")

  if (!missing(b.label)) {
    message(paste("The argument 'b.label' is deprecated.",
                  "If your data is standardized, capital B will be used automatically.",
                  "Else, please use argument 'standardize' directly instead."))
  }

  if (data_is_standardized(data)) {
    b.label <- "B"
  } else if (isTRUE(standardize)) {
    if (!missing(moderator2)) {
      moderator2.data <- data[[moderator2]]
    }
    data <- as.data.frame(lapply(data, scale))
    b.label <- "B"
  }

  if (!missing(covariates)) {
    covariates.term <- paste("+", covariates, collapse = " ")
  } else {
    covariates.term <- ""
  }
  if (!missing(moderator2)) {
    data[[moderator2]] <- moderator2.data
    mod2.levels <- unique(data[[moderator2]])
    if (length(mod2.levels) != 2) {
      stop("Non-binary second moderators are not supported at this time.")
    }
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

  table.stats <- nice_lm_slopes(models.list,
                                predictor = predictor,
                                moderator = moderator,
                                ci.alternative = ci.alternative)
  names(table.stats)[names(table.stats) == "b"] <- b.label

  if (missing(moderator2)) {
    return(table.stats)
  } else {
    # Repeat steps for other level of the moderator

    # Add a column about moderator to the first column
    table.stats <- dplyr::rename(table.stats,
                                 Predictor = "Predictor (+/-1 SD)")
    table.stats[moderator2] <- mod2.levels[2]
    table.stats <- dplyr::select(table.stats, `Dependent Variable`,
                                 dplyr::all_of(moderator2),
                                 "Predictor":"CI_upper")

    # Recode dichotomic group variable moderator2
    data[moderator2] <- ifelse(data[moderator2] == mod2.levels[2],
                               mod2.levels[1], mod2.levels[2])

    # Generate formulas, models, and simple slopes
    formulas <- paste(
      response, "~", predictor, "*", moderator,
      moderator2.term, covariates.term
    )
    models.list <- lapply(formulas, lm, data = data, ...)

    table2.stats <- nice_lm_slopes(models.list,
                                   predictor = predictor,
                                   moderator = moderator,
                                   ci.alternative = ci.alternative)

    # Add a column for moderator2
    table2.stats <- dplyr::rename(table2.stats,
                                  Predictor = "Predictor (+/-1 SD)")
    table2.stats[moderator2] <- mod2.levels[1]
    table2.stats <- dplyr::select(table2.stats, `Dependent Variable`,
                                  dplyr::all_of(moderator2),
                                  "Predictor":"CI_upper")
    names(table2.stats)[names(table2.stats) == "b"] <- b.label

    # Merge with the first table
    final.table <- rbind(table.stats, table2.stats)
    final.table <- final.table %>% dplyr::arrange(
      dplyr::desc(`Dependent Variable`)
    )
    final.table <- dplyr::rename(final.table,
                                 `Predictor (+/-1 SD)` = "Predictor")
    if (length(models.list) > 1 & mod.id == TRUE) {
      model.number <- rep(seq_along(response), each = 3 * 2)
      final.table <- stats::setNames(cbind(model.number, final.table),
                              c("Model Number", names(final.table)))
      row.names(final.table) <- NULL
    }
    final.table
  }
}
