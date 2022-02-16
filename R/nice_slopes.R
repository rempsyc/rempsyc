#' @title Easy simple slopes
#'
#' @description Easily compute simple slopes in moderation analysis, with effect sizes, and format in publication-ready format.
#'
#' Note: this function uses the `modelEffectSizes` function from the `lmSupport` package to get the sr2 effect sizes.
#'
#' @param dataframe The dataframe
#' @keywords simple slopes, moderation, interaction, regression
#' @export
#' @examples
#' # Make the basic table
#' nice_slopes(response = "mpg",
#'             predictor = "gear",
#'             moderator = "wt",
#'             data = mtcars)
#'
#' # Multiple dependent variables at once
#' nice_slopes(response = c("mpg", "disp", "hp"),
#'             predictor = "gear",
#'             moderator = "wt",
#'             data = mtcars)
#'
#' # Add covariates
#' nice_slopes(response = "mpg",
#'             predictor = "gear",
#'             moderator = "wt",
#'             covariates = c("am", "vs"),
#'             data = mtcars)
#'
#' # Three-way interaction (continuous moderator and binary second moderator required)
#' nice_slopes(response = "mpg",
#'             predictor = "gear",
#'             moderator = "wt",
#'             moderator2 = "am",
#'             data = mtcars)

nice_slopes <- function(response, predictor, moderator, moderator2=NULL, covariates=NULL, data, ...) {

  if(!missing(covariates)) {
    covariates.term <- paste("+", covariates, collapse = " ")
  } else {covariates.term <- ""}
  if(!missing(moderator2)) {
    moderator2.term <- paste("*", moderator2, collapse = " ")
  } else {moderator2.term <- ""}

  # Calculate simple slopes for LOWS
  data$lows <- unlist(data[,moderator]+sd(unlist(data[,moderator])))
  formulas <- paste(response, "~", predictor, "* lows", moderator2.term, covariates.term)
  models.list <- sapply(formulas, lm, data = data, ..., simplify = FALSE, USE.NAMES = TRUE)
  sums.list <- lapply(models.list, function(x) {summary(x)$coefficients[-1,-2]})
  df.list <- lapply(models.list, function(x) x[["df.residual"]])
  ES.list <- lapply(models.list, function(x) {
    lmSupport_modelEffectSizes(x, Print=FALSE)$Effects[-1,4]
    })
  stats.list <- mapply(cbind,df.list,sums.list,ES.list,SIMPLIFY=FALSE)
  stats.list <- lapply(stats.list, function(x) x[predictor,])
  table.stats1 <- do.call(rbind.data.frame, stats.list)
  predictor.names <- paste0(predictor, " (LOW-", moderator, ")")
  table.stats1 <- cbind(response, predictor.names, table.stats1)
  names(table.stats1) <- c("Dependent Variable", "Predictor (+/-1 SD)", "df", "b", "t", "p", "sr2")

  # Calculate simple slopes for mean-level
  formulas <- paste(response, "~", predictor, "*", moderator, moderator2.term, covariates.term)
  models.list <- sapply(formulas, lm, data = data, ..., simplify = FALSE, USE.NAMES = TRUE)
  sums.list <- lapply(models.list, function(x) {summary(x)$coefficients[-1,-2]})
  df.list <- lapply(models.list, function(x) x[["df.residual"]])
  ES.list <- lapply(models.list, function(x) {
    lmSupport_modelEffectSizes(x, Print=FALSE)$Effects[-1,4]
    })
  stats.list <- mapply(cbind,df.list,sums.list,ES.list,SIMPLIFY=FALSE)
  stats.list <- lapply(stats.list, function(x) x[predictor,])
  table.stats2 <- do.call(rbind.data.frame, stats.list)
  predictor.names <- paste0(predictor, " (MEAN-", moderator, ")")
  table.stats2 <- cbind(response, predictor.names, table.stats2)
  names(table.stats2) <- c("Dependent Variable", "Predictor (+/-1 SD)", "df", "b", "t", "p", "sr2")

  # Calculate simple slopes for HIGHS
  data$highs <- unlist(data[,moderator]-sd(unlist(data[,moderator])))
  formulas <- paste(response, "~", predictor, "* highs", moderator2.term, covariates.term)
  models.list <- sapply(formulas, lm, data = data, ..., simplify = FALSE, USE.NAMES = TRUE)
  sums.list <- lapply(models.list, function(x) {summary(x)$coefficients[-1,-2]})
  df.list <- lapply(models.list, function(x) x[["df.residual"]])
  ES.list <- lapply(models.list, function(x) {
    lmSupport_modelEffectSizes(x, Print=FALSE)$Effects[-1,4]
    })
  stats.list <- mapply(cbind,df.list,sums.list,ES.list,SIMPLIFY=FALSE)
  stats.list <- lapply(stats.list, function(x) x[predictor,])
  table.stats3 <- do.call(rbind.data.frame, stats.list)
  predictor.names <- paste0(predictor, " (HIGH-", moderator, ")")
  table.stats3 <- cbind(response, predictor.names, table.stats3)
  names(table.stats3) <- c("Dependent Variable", "Predictor (+/-1 SD)", "df", "b", "t", "p", "sr2")

  # Combine both dataframes for both LOWS and HIGHS
  table.stats <- rbind(table.stats1,table.stats2,table.stats3)
  correct.order <- c(aperm(array(1:nrow(table.stats),
                                 c(1,nrow(table.stats)/3,3)),
                           c(1,3,2)))
  table.stats <- table.stats[correct.order,] # 1, 4, 7, 2, 5, 8, 3, 6, 9

  if(missing(moderator2)){ return(table.stats) }

  if(!missing(moderator2)) { # Repeat steps for other level of the moderator

    # Add a column about moderator to the first column
    table.stats[moderator2] <- 0
    table.stats <- cbind(table.stats[1], table.stats[8], table.stats[2:7])

    # Recode dichotomic group variable moderator2
    data[moderator2] <- ifelse(data[moderator2] =="0", 1, 0)

    # Calculate simple slopes for LOWS
    data$lows <- unlist(data[,moderator]+sd(unlist(data[,moderator])))
    formulas <- paste(response, "~", predictor, "* lows", moderator2.term, covariates.term)
    models.list <- sapply(formulas, lm, data = data, ..., simplify = FALSE, USE.NAMES = TRUE)
    sums.list <- lapply(models.list, function(x) {summary(x)$coefficients[-1,-2]})
    df.list <- lapply(models.list, function(x) x[["df.residual"]])
    ES.list <- lapply(models.list, function(x) {
      lmSupport_modelEffectSizes(x, Print=FALSE)$Effects[-1,4]
      })
    stats.list <- mapply(cbind,df.list,sums.list,ES.list,SIMPLIFY=FALSE)
    stats.list <- lapply(stats.list, function(x) x[predictor,])
    table.stats1 <- do.call(rbind.data.frame, stats.list)
    predictor.names <- paste0(predictor, " (LOW-", moderator, ")")
    table.stats1 <- cbind(response, predictor.names, table.stats1)
    names(table.stats1) <- c("Dependent Variable", "Predictor (+/-1 SD)", "df", "b", "t", "p", "sr2")

    # Calculate simple slopes for mean-level
    formulas <- paste(response, "~", predictor, "*", moderator, moderator2.term, covariates.term)
    models.list <- sapply(formulas, lm, data = data, ..., simplify = FALSE, USE.NAMES = TRUE)
    sums.list <- lapply(models.list, function(x) {summary(x)$coefficients[-1,-2]})
    df.list <- lapply(models.list, function(x) x[["df.residual"]])
    ES.list <- lapply(models.list, function(x) {
      lmSupport_modelEffectSizes(x, Print=FALSE)$Effects[-1,4]
      })
    stats.list <- mapply(cbind,df.list,sums.list,ES.list,SIMPLIFY=FALSE)
    stats.list <- lapply(stats.list, function(x) x[predictor,])
    table.stats2 <- do.call(rbind.data.frame, stats.list)
    predictor.names <- paste0(predictor, " (MEAN-", moderator, ")")
    table.stats2 <- cbind(response, predictor.names, table.stats2)
    names(table.stats2) <- c("Dependent Variable", "Predictor (+/-1 SD)", "df", "b", "t", "p", "sr2")

    # Calculate simple slopes for HIGHS
    data$highs <- unlist(data[,moderator]-sd(unlist(data[,moderator])))
    formulas <- paste(response, "~", predictor, "* highs", moderator2.term, covariates.term)
    models.list <- sapply(formulas, lm, data = data, ..., simplify = FALSE, USE.NAMES = TRUE)
    sums.list <- lapply(models.list, function(x) {summary(x)$coefficients[-1,-2]})
    df.list <- lapply(models.list, function(x) x[["df.residual"]])
    ES.list <- lapply(models.list, function(x) {
      lmSupport_modelEffectSizes(x, Print=FALSE)$Effects[-1,4]})
    stats.list <- mapply(cbind,df.list,sums.list,ES.list,SIMPLIFY=FALSE)
    stats.list <- lapply(stats.list, function(x) x[predictor,])
    table.stats3 <- do.call(rbind.data.frame, stats.list)
    predictor.names <- paste0(predictor, " (HIGH-", moderator, ")")
    table.stats3 <- cbind(response, predictor.names, table.stats3)
    names(table.stats3) <- c("Dependent Variable", "Predictor (+/-1 SD)", "df", "b", "t", "p", "sr2")

    # Combine both dataframes for both LOWS and HIGHS
    table2.stats <- rbind(table.stats1,table.stats2,table.stats3)
    correct.order <- c(aperm(array(1:nrow(table2.stats),
                                   c(1,nrow(table2.stats)/3,3)),
                             c(1,3,2)))
    table2.stats <- table2.stats[correct.order,] # 1, 4, 7, 2, 5, 8, 3, 6, 9

    # Add a column for moderator2
    table2.stats[moderator2] <- 1
    table2.stats <- cbind(table2.stats[1], table2.stats[8], table2.stats[2:7])

    # Merge with the first table
    final.table <- rbind(table.stats, table2.stats)
    final.table

  }

}
