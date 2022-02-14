#' @title Easy planned contrasts (function not ready yet, please don't use)
#'
#' @description Easily compute planned contrast analyses (pairwise comparisons similar to t-tests but more powerful when more than 2 groups), and format in publication-ready format..
#' @param dataframe The dataframe
#' @keywords planned contrasts, pairwise comparisons, group differences
#' @export
#' @examples
#' # Example incoming

nice_contrasts <- function(response, group, covariates=NULL, data) {
  data[[group]] <- as.factor(data[[group]])
  data[response] <- lapply(data[response], as.numeric)
  if(!missing(covariates)) {
    data[covariates] <- lapply(data[covariates], as.numeric)
    covariates.term <- paste("+", covariates, collapse = " ")
  } else {covariates.term <- ""}
  formulas <- paste(response, "~", group, covariates.term) ### Add support for moderator(s)
  models.list <- sapply(formulas, lm, data = data, simplify = FALSE, USE.NAMES = TRUE)
  leastsquare.list <- lapply(models.list, emmeans::emmeans, group, data = data)
  groups.contrasts <- list(comp1 = setNames(c(1, 0, -1), levels(data$Group)), # support x groups
                           comp2 = setNames(c(0, 1, -1), levels(data$Group)), # support x groups
                           comp3 = setNames(c(1, -1, 0), levels(data$Group))) # support x groups
  boot.lists <- sapply(groups.contrasts, function (y) {
    sapply(response, function (x) {
      bootES::bootES(data = na.omit(data),
                     data.col = x,
                     group.col = group,
                     contrast = y,
                     effect.type = "akp.robust.d")},
      simplify = FALSE,
      USE.NAMES = TRUE)},
    simplify = FALSE, USE.NAMES = TRUE)
  contrval.list <- lapply(leastsquare.list, emmeans::contrast, groups.contrasts, adjust = "none")
  contrval.sums <- sapply(contrval.list, summary, simplify = FALSE, USE.NAMES = TRUE)
  boot.sums <- lapply(unlist(boot.lists, recursive = FALSE), summary)
  list.names <- c("estimates", "SE", "df", "tratio", "pvalue")
  stats.list <- list()
  for (i in 1:length(list.names)) {
    stats.list[[list.names[i]]] <- c(t((sapply(contrval.sums, `[[`, i+1))))
  }
  list.names2 <- c("cohenD","cohenDL","cohenDH")
  for (i in 1:length(list.names2)) {
    stats.list[[list.names2[i]]] <- sapply(boot.sums, `[[`, i)
  }
  response.names <- rep(response, times=length(contrval.sums[[1]]$contrast))
  comparisons.names <- rep(
    c(paste(levels(data$Group)[1], "-", levels(data$Group)[3]), ###### support x groups
      paste(levels(data$Group)[2], "-", levels(data$Group)[3]), ###### support x groups
      paste(levels(data$Group)[1], "-", levels(data$Group)[2])), ###### support x groups
    each = length(response))
  table.stats <- data.frame(response.names,
                            comparisons.names,
                            stats.list[-c(1:2)])
  table.stats <- table.stats[order(factor(table.stats$response.names, levels = response)),]
  names(table.stats) <- c("Dependent Variable", "Comparison", "df", "t", "p", "dR", "CI_lower", "CI_upper")
  row.names(table.stats) <- NULL
  table.stats
}
