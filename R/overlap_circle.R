#' @title Interpolate the Inclusion of the Other in the Self Scale
#'
#' @description Interpolating the Inclusion of the Other in
#' the Self Scale (IOS; self-other merging) easily. The user provides
#' the IOS score, from 1 to 7, and the function will provide a
#' percentage of actual area overlap between the two circles
#' (i.e., not linear overlap), so it is possible to say, e.g.,
#' that experimental group 1 had an average overlap of X%
#' with the other person, whereas experimental group 2 had
#' an average overlap of X% with the other person.
#'
#' @details
#' The circles are generated through the
#' `VennDiagram::draw.pairwise.venn()` function and the desired
#' percentage overlap is passed to its `cross.area` argument
#' ("The size of the intersection between the sets"). The percentage
#' overlap values are interpolated from this reference grid:
#' Score of 1 = 0%, 2 = 10%, 3 = 20%, 4 = 30%, 5 = 55%, 6 = 65%,
#' 7 = 85%.
#'
#' @param response The variable to plot: requires IOS scores ranging
#' from 1 to 7 (when `scoring = "IOS"`).
#' @param categories The desired category names of the two overlapping
#' circles for display on the plot.
#' @param scoring One of `c("IOS", "percentage", "direct")`. If
#' `scoring = "IOS"`, response needs to be a value between 1 to 7.
#' If set to `"percentage"` or `"direct"`, responses need to be
#' between 0 and 100. If set to `"direct"`, must provide exactly
#' three values that represent the area from the first circle,
#' the middle overlapping area, and area from the second circle.
#'
#' @keywords self-other merging self-other overlap Venn diagrams social
#'           psychology
#' @return A plot of class gList, displaying overlapping circles relative
#'         to the selected score.
#' @export
#' @examplesIf requireNamespace("VennDiagram", quietly = TRUE)
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
#' overlap_circle(3.12, categories = c("Humans", "Animals"))
#'
#' \donttest{
#' # Saving to file (PDF or PNG)
#' plot <- overlap_circle(3.5)
#' ggplot2::ggsave(plot,
#'   file = tempfile(fileext = ".pdf"), width = 7,
#'   height = 7, unit = "in", dpi = 300
#' )
#' # Change for your own desired path
#' }
#' @import graphics
#'
#' @seealso
#' Tutorial: \url{https://rempsyc.remi-theriault.com/articles/circles}
#'

overlap_circle <- function(response,
                           categories = c("Self", "Other"),
                           scoring = "IOS") {
  rlang::check_installed("VennDiagram", reason = "for this function.")
  grid::grid.newpage()
  area1 <- 100
  area2 <- 100
  if (scoring == "IOS") {
    if (response < 1 || response > 7) {
      stop(c("Overlap score must be between 1 and 7! Else use `scoring = 'percentage'`\n",
             "(scoring system of the Inclusion of the Other in the Self Scale...)\n"))
    }
    scale <- c(1, 2, 3, 4, 5, 6, 7)
    overlap <- c(0, 10, 20, 30, 55, 65, 85)
    po <- round(stats::approx(scale, overlap, xout = response)$y, digits = 2)
  } else {
    if (any(response < 0 | response > 100)) {
      stop(c("Overlap percentage score must be between 0 and 100!"))
    }
    po <- round(response, digits = 2)
    if (scoring == "direct") {
      if (length(response) != 3) {
        stop(c("Must provide all 3 direct overlap scores!"))
      }
      area1 <- response[1]
      area2 <- response[3]
      po <- response[2]
    }
  }

  # po = Percentage overlap
  invisible(VennDiagram::draw.pairwise.venn(
    area1 = area1,
    area2 = area2,
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
    label.col = c(
      "white",
      "black",
      "white"
    )
  ))
}
nice_circle <- overlap_circle
