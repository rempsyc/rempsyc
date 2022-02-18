#' @title Attempt to visualize variance per group
#'
#' @description Attempt to visualize variance per group. It is not a good way to visualize variance because the concentration of points may be hidden on such plots. use for exploratory purposes only.
#' @param dataframe The dataframe
#' @keywords variance
#' @export
#' @examples
#' # Make the basic plot
#' nice_varplot(variable = "Sepal.Length",
#'              group = "Species",
#'              data = iris)
#'
#' # Further customization
#' nice_varplot(variable = "Sepal.Length",
#'              group = "Species",
#'              data = iris,
#'              colours = c("#00BA38", "#619CFF", "#F8766D"),
#'              ytitle = "Sepal Length",
#'              groups.labels = c("(a) Setosa", "(b) Versicolor", "(c) Virginica"))

nice_varplot <- function(variable, group, data, colours, groups.labels, grid=TRUE, shapiro=FALSE, ytitle=variable) {
  library(dplyr)
  library(ggplot2)
  source("https://raw.githubusercontent.com/RemPsyc/niceplots/master/niceScatterFunction.R")
  data[[group]] <- as.factor(data[[group]])
  {if (!missing(groups.labels)) levels(data[[group]]) <- groups.labels}
  # Calculate variance
  var <- data %>%
    group_by(.data[[group]]) %>%
    summarize(var=var(.data[[variable]]))
  diff <- max(var[,"var"])/min(var[,"var"])
  # Make annotation dataframe
  dat_text <- var %>%
    mutate(text=paste0("var = ", round(var,2)))
  # Make plot
  nice_scatter(data=data,
               predictor=.data[[group]],
               response=.data[[variable]],
               group.variable=data[[group]],
               colours=colours,
               groups.names=groups.labels,
               xtitle=NULL,
               ytitle=ytitle) +
    annotate(geom="text",
             x=median(1:length(levels(data[[group]]))),
             y=max(data[[variable]]),
             label=paste0("max/min = ",
                          round(diff, 2),
                          "x bigger"),
             hjust=0.5,
             size=6) +
    ggrepel::geom_text_repel(data=dat_text,
                    mapping=aes(x=.data[[group]],
                                y=-Inf,
                                label=text),
                    inherit.aes=FALSE,
                    size=6)
}
