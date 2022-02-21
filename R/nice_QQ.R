#' @title Easy QQ plots per group
#'
#' @description Easily make nice per-group QQ plots through a wrapper around the `ggplot2` and `qqplotr` packages.
#'
#' @param variable The variable
#' @param group The group
#' @param data The data
#' @param colours The colours
#' @param groups.labels The groups.labels
#' @param grid The grid
#' @param shapiro The shapiro
#' @param title The title
#'
#' @keywords QQ plots, normality, distribution
#' @export
#' @examples
#' # Make the basic plot
#' nice_QQ(variable = "Sepal.Length",
#'        group = "Species",
#'        data = iris)
#'
#' # Further customization
#' nice_QQ(variable = "Sepal.Length",
#'        group = "Species",
#'        data = iris,
#'        colours = c("#00BA38", "#619CFF", "#F8766D"),
#'        groups.labels = c("(a) Setosa", "(b) Versicolor", "(c) Virginica"),
#'        grid = FALSE,
#'        shapiro = TRUE,
#'        title = NULL)
#'
#' @importFrom dplyr mutate %>% select group_by summarize rowwise do
#' @importFrom ggplot2 ggplot labs facet_grid ggtitle theme_bw scale_fill_manual theme aes_string aes element_text element_line element_blank

nice_QQ <- function(variable, group, data, colours, groups.labels=NULL,
                    grid=TRUE, shapiro=FALSE, title=variable) {
  data[[group]] <- as.factor(data[[group]])
  gform <- reformulate(".", response=group)
  {if (!missing(groups.labels)) levels(data[[group]]) <- groups.labels}
  # Make data for the Shapiro-Wilk tests
  if (shapiro == TRUE) {
    format.p <- function(p, precision = 0.001) {
      digits <- -log(precision, base = 10)
      p <- formatC(p, format = 'f', digits = digits)
      if (p < .001) {
        p <- paste0('< ', precision, " (Shapiro-Wilk)")}
      if (p >= .001) {
        p <- paste0('= ', p, " (Shapiro-Wilk)")    }
      sub("0", "", p)
    }
    dat_text <- data %>% group_by(.data[[group]]) %>%
        summarize(text=shapiro.test(.data[[variable]])$p.value) %>%
        rowwise() %>%
        mutate(text=sprintf("italic('p')~'%s'", format.p(text)))
    }
  # Make plot
  ggplot(data = data, mapping = aes_string(fill=group, sample=variable)) +
    qqplotr::stat_qq_band() +
    qqplotr::stat_qq_line() +
    qqplotr::stat_qq_point() +
    labs(x = "Theoretical Quantiles", y = "Sample Quantiles") +
    facet_grid(gform) +
    ggtitle(title) +
    theme_bw(base_size = 24) +
    {if (shapiro == TRUE) ggrepel::geom_text_repel(data = dat_text,
                                                   mapping = aes(x = Inf,
                                                                 y = -Inf,
                                                                 label = text),
                                                   inherit.aes = FALSE,
                                                   size = 6,
                                                   force = 0,
                                                   parse = TRUE)} +
    {if (!missing(colours)) scale_fill_manual(values=colours)} +
    {if (grid == FALSE) theme(panel.grid.major=element_blank(),
                              panel.grid.minor=element_blank())} +
    theme(plot.title = element_text(hjust = 0.5),
          legend.position = "none",
          axis.text.x = element_text(colour="black"),
          axis.text.y = element_text(colour="black"),
          panel.border=element_blank(),
          axis.line=element_line(colour = "black"),
          axis.ticks=element_line(colour = "black"))
}
