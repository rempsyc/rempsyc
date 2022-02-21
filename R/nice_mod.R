#' @title Easy moderations
#'
#' @description Easily compute moderation analyses, with effect sizes, and format in publication-ready format.
#'
#' Note: this function uses the `modelEffectSizes` function from the `lmSupport` package to get the sr2 effect sizes.
#'
#' @param response The response
#' @param predictor The predictor
#' @param moderator The moderator
#' @param moderator2 The moderator2
#' @param covariates The covariates
#' @param data The data
#' @param ... The ...
#'
#' @keywords moderation, interaction, regression
#' @export
#' @examples
#' # Make the basic table
#' nice_mod(response = "mpg",
#'         predictor = "gear",
#'         moderator = "wt",
#'         data = mtcars)
#'
#' # Multiple dependent variables at once
#' nice_mod(response = c("mpg", "disp", "hp"),
#'         predictor = "gear",
#'         moderator = "wt",
#'         data = mtcars)
#'
#' # Add covariates
#' nice_mod(response = "mpg",
#'          predictor = "gear",
#'          moderator = "wt",
#'          covariates = c("am", "vs"),
#'          data = mtcars)
#'
#' # Three-way interaction
#' nice_mod(response = "mpg",
#'          predictor = "gear",
#'          moderator = "wt",
#'          moderator2 = "am",
#'          data = mtcars)

nice_mod <- function(response, predictor, moderator, moderator2=NULL,
                     covariates=NULL, data, ...) {

  if(!missing(covariates)) {
    covariates.term <- paste("+", covariates, collapse = " ")
  } else {covariates.term <- ""}
  if(!missing(moderator2)) {
    moderator2.term <- paste("*", moderator2, collapse = " ")
  } else {moderator2.term <- ""}
  formulas <- paste(response, "~", predictor, "*", moderator,
                    moderator2.term, covariates.term)
  models.list <- sapply(formulas, stats::lm, data = data, ...,
                        simplify = FALSE, USE.NAMES = TRUE)
  sums.list <- lapply(models.list, function(x) {summary(x)$coefficients[-1,-2]})
  df.list <- lapply(models.list, function(x) x[["df.residual"]])
  ES.list <- lapply(models.list, function(x) {
    lmSupport_modelEffectSizes(x, Print=FALSE)$Effects[-1,4]
  })
  stats.list <- mapply(cbind,df.list,sums.list,ES.list,SIMPLIFY=FALSE)
  table.stats <- do.call(rbind.data.frame, stats.list)
  response.names <- rep(response, each=nrow(sums.list[[1]]))
  predictor.names <- row.names(table.stats)
  row.names(table.stats) <- NULL
  predictor.names <- gsub(".*\\.", "", predictor.names)
  table.stats <- cbind(response.names, predictor.names, table.stats)
  names(table.stats) <- c("Dependent Variable", "Predictor", "df", "b", "t", "p", "sr2")
  table.stats
}
niceMod <- nice_mod
