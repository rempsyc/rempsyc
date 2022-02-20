#' @title Easy scatter plots
#'
#' @description Make nice violon plots easily.
#'
#' @param data The data
#' @param predictor The predictor
#' @param response The response
#' @param xtitle The xtitle
#' @param ytitle The ytitle
#' @param has.points The has.points
#' @param has.jitter The has.jitter
#' @param alpha The alpha
#' @param has.confband The has.confband
#' @param has.fullrange The has.fullrange
#' @param has.linetype The has.linetype
#' @param has.shape The has.shape
#' @param xmin The xmin
#' @param xmax The xmax
#' @param xby The xby
#' @param ymin The ymin
#' @param ymax The ymax
#' @param yby The yby
#' @param has.legend The has.legend
#' @param legend.title The legend.title
#' @param group.variable The group.variable
#' @param colours The colours
#' @param groups.order The groups.order
#' @param groups.names The groups.names
#' @param manual.slope.alpha The manual.slope.alpha
#' @param has.r The has.r
#' @param r.x The r.x
#' @param r.y The r.y
#' @param has.p The has.p
#' @param p.x The p.x
#' @param p.y The p.y
#'
#' @keywords scatter plots
#' @export
#' @examples
#' # Make the basic plot
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg)
#'
#' # Save a high-resolution image file to specified directory
#' ggplot2::ggsave('nicescatterplothere.tiff', width = 7, height = 7, unit = 'in',
#'                 dpi = 300, path = NULL) # change for your own desired path
#'
#' # Change x- and y- axis labels
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             ytitle = "Miles/(US) gallon",
#'             xtitle = "Weight (1000 lbs)")
#'
#' # Have points "jittered"
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             has.jitter = TRUE)
#'
#' # Change the transparency of the points
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             alpha = 1)
#'
#' # Remove points
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             has.points = FALSE,
#'             has.jitter = FALSE)
#'
#' # Add confidence band
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             has.confband = TRUE)
#'
#' # Set x- and y- scales manually
#' nice_scatter(data = mtcars,
#'            predictor = wt,
#'            response = mpg,
#'            xmin = 1,
#'            xmax = 6,
#'            xby = 1,
#'            ymin = 10,
#'            ymax = 35,
#'            yby = 5)
#'
#' # Change plot colour
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             colours = "blueviolet")
#'
#' # Add correlation coefficient to plot and p-value
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             has.r = TRUE,
#'             has.p = TRUE)
#'
#' # Change location of correlation coefficient or p-value
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             has.r = TRUE,
#'             r.x = 4,
#'             r.y = 25,
#'             has.p = TRUE,
#'             p.x = 5,
#'             p.y = 20)
#'
#' # Plot by group
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             group.variable = factor(mtcars$cyl))
#'
#' # Use full range on the slope/confidence band
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             group.variable = factor(mtcars$cyl),
#'             has.fullrange = TRUE)
#'
#' # Add a legend
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             group.variable = factor(mtcars$cyl),
#'             has.legend = TRUE)
#'
#' # Change order of labels on the legend
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             group.variable = factor(mtcars$cyl),
#'             has.legend = TRUE,
#'             groups.order = c(8,4,6))
#'
#' # Change legend labels
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             group.variable = factor(mtcars$cyl),
#'             has.legend = TRUE,
#'             groups.names = c("Weak","Average","Powerful"))
#' # Warning: This applies after changing order of level
#'
#' # Add a title to legend
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             group.variable = factor(mtcars$cyl),
#'             has.legend = TRUE,
#'             legend.title = "Cylinders")
#'
#' # Plot by group + manually specify colours
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             group.variable = factor(mtcars$cyl),
#'             colours = c("burlywood","darkgoldenrod","chocolate"))
#'
#' # Plot by group + use different line types for each group
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             group.variable = factor(mtcars$cyl),
#'             has.linetype = TRUE)
#'
#' # Plot by group + use different point shapes for each group
#' nice_scatter(data = mtcars,
#'             predictor = wt,
#'             response = mpg,
#'             group.variable = factor(mtcars$cyl),
#'             has.shape = TRUE)
#'
#' @importFrom ggplot2 ggplot labs facet_grid ggtitle theme_bw scale_fill_manual theme annotate scale_x_discrete ylab xlab geom_violin geom_point geom_errorbar geom_dotplot scale_y_continuous stat_smooth geom_smooth geom_jitter scale_x_continuous scale_color_manual guides scale_alpha_manual aes_string aes element_blank element_line element_text

nice_scatter <- function(data,predictor, response, xtitle=ggplot2::waiver(),
                         ytitle=ggplot2::waiver(), has.points=TRUE, has.jitter=FALSE,
                         alpha=0.7, has.confband=FALSE, has.fullrange=FALSE,
                         has.linetype=FALSE, has.shape=FALSE, xmin, xmax, xby=1, ymin,
                         ymax, yby=1, has.legend=FALSE, legend.title="",
                         group.variable=NULL, colours="#619CFF", groups.order=NULL,
                         groups.names=NULL, manual.slope.alpha=NULL, has.r=FALSE, r.x=Inf,
                         r.y=-Inf, has.p=FALSE, p.x=Inf, p.y=-Inf) {
  has.groups=!missing(group.variable)
  if (has.r == T) {
    format.r <- function(r, precision = 0.01) {
      digits <- -log(precision, base = 10)
      r <- formatC(r, format = 'f', digits = digits)
      sub("0", "", r)}
    r = format.r(cor.test(data[,deparse(substitute(predictor))],data[,deparse(substitute(response))], use="complete.obs",)$estimate)
  }
  if (has.p == T) {
    format.p <- function(p, precision = 0.001) {
      digits <- -log(precision, base = 10)
      p <- formatC(p, format = 'f', digits = digits)
      if (p < .001) {
        p = paste0('< ', precision)}
      if (p >= .001) {
        p = paste0('= ', p)    }
      sub("0", "", p)
    }
    p = format.p(cor.test(data[,deparse(substitute(predictor))],data[,deparse(substitute(response))], use="complete.obs",)$p.value)
  }
  if (!missing(groups.order)) {group.variable <- factor(group.variable, levels=groups.order)}
  if (!missing(groups.names)) {levels(group.variable) = groups.names}
  if (missing(group.variable)) {
    smooth <- stat_smooth(geom="line", method="lm", fullrange=has.fullrange, color = colours, size = 1)}
  if (!missing(group.variable)) {
    smooth <- stat_smooth(geom="line", method="lm", fullrange=has.fullrange, size = 1)}
  if (has.confband == T & missing(group.variable)) {
    band <- geom_smooth(method="lm",colour=NA,fill=colours)}
  if (has.confband == T & !missing(group.variable)) {
    band <- geom_smooth(method="lm",colour=NA)}
  if (has.points == T & missing(group.variable) & missing(colours)) {
    observations <- geom_point(size = 2, alpha = alpha, shape = 16)}
  if (has.points == T & !missing(group.variable) & has.shape == F) {
    observations <- geom_point(size = 2, alpha = alpha, shape = 16)}
  if (has.points == T & missing(group.variable) & !missing(colours)) {
    observations <- geom_point(size = 2, alpha = alpha, colour = colours, shape = 16)}
  if (has.points == T & !missing(group.variable) & has.shape == T) {
    observations <- geom_point(size = 2, alpha = alpha)}
  if (has.jitter == T & missing(group.variable) & missing(colours)) {
    observations <- geom_jitter(size = 2, alpha = alpha, shape = 16)
    has.points=F}
  if (has.jitter == T & !missing(group.variable) & has.shape == F) {
    observations <- geom_jitter(size = 2, alpha = alpha, shape = 16)
    has.points=F}
  if (has.jitter == T & missing(group.variable) & !missing(colours)) {
    observations <- geom_jitter(size = 2, alpha = alpha, colour = colours, shape = 16)
    has.points=F}
  if (has.jitter == T & !missing(group.variable) & has.shape == T) {
    observations <- geom_jitter(size = 2, alpha = alpha)
    has.points=F}
  ggplot(data,aes(x={{predictor}},y={{response}}, colour = switch(has.groups==T, group.variable), fill = switch(has.groups==T, group.variable), linetype = switch(has.groups==T & has.linetype==T, group.variable), shape = switch(has.groups==T & has.shape==T, group.variable), alpha = switch(!is.null(manual.slope.alpha),group.variable))) +
    xlab(xtitle) +
    ylab(ytitle) +
    smooth +
    theme_bw(base_size = 24) +
    {if (has.confband == TRUE) band} +
    {if (exists("observations")) observations} +
    {if (!missing(xmin)) scale_x_continuous(limits=c(xmin, xmax), breaks = seq(xmin, xmax, by = xby))} +
    {if (!missing(ymin)) scale_y_continuous(limits=c(ymin, ymax), breaks = seq(ymin, ymax, by = yby))} +
    {if (!missing(colours) & !missing(group.variable)) scale_color_manual(values=colours, name = legend.title)} +
    {if (!missing(colours) & !missing(group.variable)) scale_fill_manual(values=colours, name = legend.title)} +
    {if (!missing(colours)) guides(fill = guide_legend(override.aes=list(colour = colours)))} +
    {if (has.legend == FALSE) theme(legend.position = "none")} +
    labs(legend.title = legend.title, colour = legend.title, fill = legend.title, linetype = legend.title, shape = legend.title) +
    {if (!missing(manual.slope.alpha)) scale_alpha_manual(values=manual.slope.alpha, guide=FALSE)} +
    {if (has.r == TRUE) annotate(geom="text", x=r.x, y=r.y, label=sprintf("italic('r =')~'%s'", r), parse = TRUE, hjust=1, vjust=-3, size=7)} +
    {if (has.p == TRUE) annotate(geom="text", x=p.x, y=p.y, label=sprintf("italic('p')~'%s'", p), parse = TRUE, hjust=1, vjust=-1, size=7)} +
    theme(axis.text.x = element_text(colour="black"), axis.text.y = element_text(colour="black"), panel.grid.major=element_blank(), panel.grid.minor=element_blank(), panel.border=element_blank(), axis.line=element_line(colour = "black"), axis.ticks=element_line(colour = "black"))
}
