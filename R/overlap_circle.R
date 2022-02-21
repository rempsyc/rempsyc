#' @title Interpolate the Inclusion of the Other in the Self Scale
#'
#' @description Interpolating the Inclusion of the Other in the Self Scale easily.
#'
#' @param response The response
#' @param categories The categories
#'
#' @keywords self-other merging, self-other overlap, Venn diagrams, social psychology
#' @export
#' @examples
#' # Score of 1 (0% overlap)
#' overlap_circle(1)
#'
#' # Score of 3.5 (25% overlap)
#' overlap_circle(3.5)
#'
#' # Score of 6.84 (81.8% overlap)
#' overlap_circle(6.84)
#'
#' # Changing labels
#' overlap_circle(3.12, categories = c("Humans","Animals"))
#'
#' ##  NOT RUN
#' # Saving to file (PDF or PNG)
#' ## plot <- overlap_circle(3.5)
#' ## ggplot2::ggsave(plot, file=NULL, width=7, height=7, unit='in', dpi=300)
#' # Change for your own desired path

overlap_circle <- function(response, categories = c("Self", "Other")){
  if(response < 1 | response > 7) {stop('Overlap score must be between 1 and 7!
                                        (scoring system of the Inclusion of the
                                        Other in the Self Scale...)')}
  grid::grid.newpage()
  scale <- (c(1,2,3,4,5,6,7))
  overlap <- (c(0,10,20,30,55,65,85))
  po <- round(approx(scale, overlap, xout = response)$y, digits=2) # po = Percentage overlap
  invisible(VennDiagram::draw.pairwise.venn(area1 = 100,
                                            area2 = 100,
                                            cross.area = po,
                                            category = categories,
                                            cat.cex = 4,
                                            cex = 2,
                                            cat.pos = c(330, 30),
                                            cat.dist = -.09,
                                            lwd = 10,
                                            ext.pos = 0,
                                            ext.dist = -5,
                                            sep.dist = 0.02,
                                            label.col = c("white","black","white")))

}
overlapCircle <- overlap_circle
