#' @title Attempt to visualize variance per group
#'
#' @description Attempt to visualize variance per group. It is not a good way to visualize variance because the concentration of points may be hidden on such plots. Use at your own risk and for exploratory purposes only.
#'
#' @param variable The dependent variable to be plotted.
#' @param group The group by which to plot the variable.
#' @param data The data frame
#' @param colours Desired colours for the plot, if desired.
#' @param groups.labels How to label the groups.
#' @param grid Logical, whether to keep the default background grid or not. APA style suggests not using a grid in the background, though in this case some may find it useful to more easily estimate the slopes of the different groups.
#' @param shapiro Logical, whether to include the p-value from the Shapiro-Wilk test on the plot.
#' @param ytitle An optional y-axis label, if desired.
#'
#' @keywords variance
#' @export
#' @examples
#' # Make the basic plot
#' nice_varplot(data = iris,
#'              variable = "Sepal.Length",
#'              group = "Species")
#'
#' # Further customization
#' nice_varplot(data = iris,
#'              variable = "Sepal.Length",
#'              group = "Species",
#'              colours = c("#00BA38", "#619CFF", "#F8766D"),
#'              ytitle = "Sepal Length",
#'              groups.labels = c("(a) Setosa", "(b) Versicolor", "(c) Virginica"))
#'
#' @seealso
#' Other functions useful in assumption testing: \code{\link{nice_assumptions}}, \code{\link{nice_density}}, \code{\link{nice_qq}}, \code{\link{nice_var}}
#'
#' @importFrom dplyr mutate %>% select group_by summarize rowwise do
#' @importFrom ggplot2 ggplot labs facet_grid ggtitle theme_bw scale_fill_manual theme annotate aes
#' @importFrom stats var median

nice_varplot <- function(data, variable, group, colours, groups.labels,
                         grid=TRUE, shapiro=FALSE, ytitle=variable) {
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
               group=data[[group]],
               colours=colours,
               groups.labels=groups.labels,
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
