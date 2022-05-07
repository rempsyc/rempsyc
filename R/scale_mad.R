#' @title Normalize based on the absolute median deviation
#'
#' @description Scale and center ("standardize") data based on the median absolute deviation.
#'
#' See: Leys, C., Ley, C., Klein, O., Bernard, P., & Licata, L. (2013). Detecting outliers: Do not use standard deviation around the mean, use absolute deviation around the median. Journal of Experimental Social Psychology, 49(4), 764–766. https://doi.org/10.1016/j.jesp.2013.03.013
#'
#' @param x The vector to be scaled.
#' @keywords standardization, normalization, median, MAD, mean, outliers
#' @author Hugues Leduc, Charles-Étienne Lavoie
#' @export
#' @examples
#' scale_mad(mtcars$mpg)
#' @importFrom stats mad median

scale_mad <- function (x) {
  median.x <- median(x, na.rm = TRUE)
  mad.x <- mad(x, na.rm = TRUE)
  y <- (x - median.x)/mad.x
  y
}
