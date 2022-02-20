#' @title Easy density plots
#'
#' @description Make nice density plots easily.
#' @param dataframe The dataframe
#' @keywords density, normality
#' @export
#' @examples
#' # Make the basic plot
#' nice_density(variable = "Sepal.Length",
#'             group = "Species",
#'             data = iris)
#'
#' # Further customization
#' nice_density(variable = "Sepal.Length",
#'             group = "Species",
#'             data = iris,
#'             colours = c("#00BA38", "#619CFF", "#F8766D"),
#'             xtitle = "Sepal Length",
#'             ytitle = "Density (vs. Normal Distribution)",
#'             groups.labels = c("(a) Setosa", "(b) Versicolor", "(c) Virginica"),
#'             grid = FALSE,
#'             shapiro = TRUE,
#'             title = "Density (Sepal Length)")
#' @importFrom dplyr mutate %>% select group_by summarize rowwise
#' @importFrom ggplot2 ggplot labs facet_grid ggtitle theme_bw scale_fill_manual theme annotate scale_x_discrete ylab xlab geom_violin geom_point geom_errorbar geom_dotplot scale_y_continuous stat_smooth geom_smooth geom_jitter scale_x_continuous scale_color_manual guides scale_alpha_manual geom_density geom_line aes_string aes

nice_density <- function(variable, group, data, colours, ytitle="Density", xtitle=variable, groups.labels=NULL, grid=TRUE, shapiro=FALSE, title=variable) {
  options(dplyr.summarize.inform = FALSE)
  data[[group]] <- as.factor(data[[group]])
  gform <- reformulate(".", response=group)
  {if (!missing(groups.labels)) levels(data[[group]]) <- groups.labels}
  # Make data for normally distributed lines
  dat_norm <- data %>% group_by(.data[[group]]) %>%
    do(summarize(.,x=seq(min(.[[variable]]),
                         max(.[[variable]]),
                         length.out=100),
                 y=dnorm(seq(min(.[[variable]]),
                             max(.[[variable]]),
                             length.out=100),
                         mean(.[[variable]]),
                         sd(.[[variable]]))))
  # Make data for the Shapiro-Wilk tests
  if (shapiro == TRUE) {
    format.p <- function(p, precision = 0.001) {
      digits <- -log(precision, base = 10)
      p <- formatC(p, format = 'f', digits = digits)
      if (p < .001) {
        p = paste0('< ', precision, " (Shapiro-Wilk)")}
      if (p >= .001) {
        p = paste0('= ', p, " (Shapiro-Wilk)")    }
      sub("0", "", p)
    }
    dat_text <- data %>% group_by(.data[[group]]) %>%
        summarise(text=shapiro.test(.data[[variable]])$p.value) %>%
        rowwise() %>%
        mutate(text=sprintf("italic('p')~'%s'", format.p(text)))
  }
  # Make plot
  ggplot(data, aes_string(x=variable, fill=group)) +
    geom_density(alpha=0.6, size=1, colour="gray25") +
    theme_bw(base_size = 24) +
    ggtitle(title) +
    facet_grid(gform) +
    geom_line(data = dat_norm, aes(x = x, y = y), color = "darkslateblue", size=1.2, alpha=0.9) +
    ylab(ytitle) +
    xlab(xtitle) +
    {if (shapiro == TRUE) ggrepel::geom_text_repel(data = dat_text,
                                                   mapping = aes(x = Inf,
                                                                 y = Inf,
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
