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
#' @param b.label What to rename the default "b" column (e.g., to capital B if using standardized data for it to be converted to the Greek beta symbol in the `nice_table` function).
#' @param mod.id Logical. Whether to display the model number, when there is more than one model.
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
#' Checking simple slopes after testing for moderation: \code{\link{nice_slopes}}, \code{\link{nice_lm}}, \code{\link{nice_lm_slopes}}. Tutorial: \url{https://remi-theriault.com/blog_moderation}
#'

nice_mod <- function(data,
                     response,
                     predictor,
                     moderator,
                     moderator2 = NULL,
                     covariates = NULL,
                     b.label = "b",
                     mod.id = TRUE,
                     ...) {
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
  stats.list <- lapply(stats.list, function(x) {
    x <- as.data.frame(x)
    IV <- row.names(x)
    x <- cbind(IV, x)
  })
  table.stats <- do.call(rbind.data.frame, stats.list)
  response.names <- rep(response, each=nrow(sums.list[[1]]))
  row.names(table.stats) <- NULL
  table.stats <- cbind(response.names, table.stats)
  good.names <- c("Dependent Variable", "Predictor",
                  "df", "b", "t", "p", "sr2")
  if(length(models.list) > 1 & mod.id == TRUE) {
    model.number <- rep(1:length(models.list), times = lapply(sums.list, nrow))
    table.stats <- cbind(model.number, table.stats)
    names(table.stats) <- c("Model Number", good.names)
  } else {
    names(table.stats) <- good.names}
  if(!missing(b.label)) { names(table.stats)[names(table.stats) == "b"] <- b.label}
  table.stats
}
