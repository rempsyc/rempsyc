#' @title Easy violin plots
#'
#' @description Make nice violin plots easily with 95% bootstrapped confidence intervals.
#'
#' @param data The data
#' @param group The group
#' @param response The response
#' @param boot The boot
#' @param bootstraps The bootstraps
#' @param colours The colours
#' @param xlabels The xlabels
#' @param ytitle The ytitle
#' @param xtitle The xtitle
#' @param has.ylabels The has.ylabels
#' @param has.xlabels The has.xlabels
#' @param comp1 The comp1
#' @param comp2 The comp2
#' @param signif_annotation The signif_annotation
#' @param signif_yposition The signif_yposition
#' @param signif_xmin The signif_xmin
#' @param signif_xmax The signif_xmax
#' @param ymin The ymin
#' @param ymax The ymax
#' @param yby The yby
#' @param CIcap.width The CIcap.width
#' @param obs The obs
#' @param alpha The alpha
#' @param border.colour The border.colour
#'
#' @keywords violin plots
#' @export
#' @examples
#' # Make the basic plot
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len")
#'
#' # Save a high-resolution image file to specified directory
#' ggplot2::ggsave('niceviolinplothere.tiff', width = 7, height = 7, unit = 'in',
#'        dpi = 300, path = NULL) # change for your own desired path
#'
#' # Change x- and y- axes labels
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len",
#'            ytitle = "Length of Tooth",
#'            xtitle = "Vitamin C Dosage")
#'
#' # See difference between two groups
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len",
#'            comp1 = "0.5",
#'            comp2 = "2")
#'
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len",
#'            comp1 = 2,
#'            comp2 = 3)
#'
#' # Compare all three groups
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len",
#'            signif_annotation = c("*","**","***"), # manually enter the number of stars
#'            signif_yposition = c(30,35,40), # What height (y) should the stars appear?
#'            signif_xmin = c(1,2,1), # Where should the left-sided brackets start (x)?
#'            signif_xmax = c(2,3,3)) # Where should the right-sided brackets end (x)?
#'
#' # Set the colours manually
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len",
#'            colours = c("darkseagreen","cadetblue","darkslateblue"))
#'
#' # Changing the names of the x-axis labels
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len",
#'            xlabels = c("Low", "Medium", "High"))
#'
#' # Removing the x-axis or y-axis titles
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len",
#'            ytitle = NULL,
#'            xtitle = NULL)
#'
#' # Removing the x-axis or y-axis labels (for whatever purpose)
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len",
#'            has.ylabels = FALSE,
#'            has.xlabels = FALSE)
#'
#' # Set y-scale manually
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len",
#'            ymin = 5,
#'            ymax = 35,
#'            yby = 5)
#'
#' # Plotting individual observations
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len",
#'            obs = TRUE)
#'
#' # Micro-customizations
#' nice_violin(data = ToothGrowth,
#'            group = "dose",
#'            response = "len",
#'            CIcap.width = 0,
#'            alpha = 1,
#'            border.colour = "black")
#'
#' @importFrom ggplot2 ggplot labs facet_grid ggtitle theme_bw scale_fill_manual theme annotate scale_x_discrete ylab xlab geom_violin geom_point geom_errorbar geom_dotplot scale_y_continuous aes_string aes element_blank element_line element_text

nice_violin <- function (data, group, response, boot=TRUE, bootstraps=2000,
                        colours, xlabels=NULL, ytitle=ggplot2::waiver(), xtitle=NULL,
                        has.ylabels=TRUE, has.xlabels=TRUE, comp1=1, comp2=2,
                        signif_annotation=NULL, signif_yposition=NULL, signif_xmin=NULL,
                        signif_xmax=NULL, ymin, ymax, yby=1, CIcap.width=0.1, obs=FALSE,
                        alpha=.70, border.colour="white") {
  data[[group]] <- as.factor(data[[group]])
  gform <- reformulate(group, response)
  class(data[[response]]) <- "numeric"
  dataSummary <- rcompanion_groupwiseMean(gform,
                                          data = data,
                                          conf = 0.95,
                                          digits = 3,
                                          R = bootstraps,
                                          boot = TRUE,
                                          traditional = !boot,
                                          normal = FALSE,
                                          basic = FALSE,
                                          percentile = FALSE,
                                          bca = boot)
  ggplot(data, aes(x = .data[[group]],
                   y = .data[[response]],
                   fill = .data[[group]])) +
    theme_bw(base_size = 24) +
    {if (!missing(colours)) scale_fill_manual(values=colours)} +
    {if (!missing(xlabels)) scale_x_discrete(labels=c(xlabels))} +
    ylab(ytitle) +
    xlab(xtitle) +
    geom_violin(color = border.colour, alpha = alpha) +
    geom_point(aes(y = Mean),
               color = "black",
               size = 4,
               data = dataSummary) +
    geom_errorbar(aes(y = Mean,
                      ymin = dataSummary[,6],
                      ymax = dataSummary[,7]),
                  color = "black",
                  size = 1,
                  width = CIcap.width,
                  data = dataSummary) +
    theme(legend.position = "none",
          axis.text.x = element_text(colour="black"),
          axis.text.y = element_text(colour="black"),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          panel.border=element_blank(),
          axis.line=element_line(colour = "black"),
          axis.ticks=element_line(colour = "black")) +
    {if (obs == TRUE) geom_dotplot(binaxis = "y",
                                   stackdir = "center",
                                   position = "dodge",
                                   color = NA,
                                   fill = "black",
                                   alpha = 0.3,
                                   dotsize = 0.5)} +
    {if (has.ylabels == FALSE) theme(axis.text.y=element_blank(),
                                     axis.ticks.y=element_blank())} +
    {if (has.xlabels == FALSE) theme(axis.text.x=element_blank(),
                                     axis.ticks.x=element_blank())} +
    {if (!missing(ymin)) scale_y_continuous(limits=c(ymin, ymax),
                                            breaks = seq(ymin, ymax, by = yby))} +
    {if (!missing(comp1)) ggsignif::geom_signif(comparisons = list(c(comp1, comp2)),
                                                map_signif_level=TRUE,
                                                size= 1.3,
                                                textsize=8)} +
    {if (!missing(signif_annotation)) ggsignif::geom_signif(annotation=signif_annotation,
                                                            y_position=signif_yposition,
                                                            xmin=signif_xmin,
                                                            xmax=signif_xmax,
                                                            size=1.3,
                                                            textsize=8)}
}
