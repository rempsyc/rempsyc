#' @title Easy moderations
#'
#' @description Easily compute moderation analyses, with effect sizes, and format in publication-ready format.
#'
#' Note: this function uses the `modelEffectSizes` function from the `lmSupport` package to get the sr2 effect sizes.
#'
#' @param data The data frame
#' @param response The dependent variable.
#' @param predictor The independent variable.
#' @param moderator The moderating variable.
#' @param moderator2 The second moderating variable, if applicable.
#' @param covariates The desired covariates in the model.
#' @param ... Further arguments to be passed to the `lm` function for the models.
#'
#' @keywords moderation, interaction, regression
#' @export
#' @examples
#' # Make the basic table
#' nice_mod(data = mtcars,
#'          response = "mpg",
#'          predictor = "gear",
#'          moderator = "wt")
#'
#' # Multiple dependent variables at once
#' nice_mod(data = mtcars,
#'          response = c("mpg", "disp", "hp"),
#'          predictor = "gear",
#'          moderator = "wt")
#'
#' # Add covariates
#' nice_mod(data = mtcars,
#'          response = "mpg",
#'          predictor = "gear",
#'          moderator = "wt",
#'          covariates = c("am", "vs"))
#'
#' # Three-way interaction
#' nice_mod(data = mtcars,
#'          response = "mpg",
#'          predictor = "gear",
#'          moderator = "wt",
#'          moderator2 = "am")
#'
#' @seealso
#' Checking simple slopes after testing for moderation: \code{\link{nice_slopes}}
#'

nice_mod <- function(data, response, predictor, moderator, moderator2=NULL,
                     covariates=NULL, ...) {

  names(data) <- gsub("*\\.", "_t_t_", names(data))
  response <- gsub("*\\.", "_t_t_", response)
  predictor <- gsub("*\\.", "_t_t_", predictor)
  moderator <- gsub("*\\.", "_t_t_", moderator)

  if(!missing(covariates)) {
    covariates <- gsub("*\\.", "_t_t_", covariates)
    covariates.term <- paste("+", covariates, collapse = " ")
  } else {covariates.term <- ""}
  if(!missing(moderator2)) {
    moderator2 <- gsub("*\\.", "_t_t_", moderator2)
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
  table.stats["Dependent Variable"] <- lapply(table.stats["Dependent Variable"], function(x) {
    gsub("*\\_t_t_", ".", x)})
  table.stats$Predictor <- gsub("*\\_t_t_", ".", table.stats$Predictor)
  table.stats
}
