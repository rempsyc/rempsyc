#' @title Winsorize based on the absolute median deviation
#'
#' @description Winsorize (bring extreme observations to usually
#' +/- 3 standard deviations) data based on median absolute
#' deviations instead of standard deviations.
#'
#' @details For the *easystats* equivalent, use:
#' `datawizard::winsorize(x, method = "zscore", threshold = 3, robust = TRUE)`.
#' @param x The vector to be winsorized based on the MAD.
#' @param criteria How many MAD to use as threshold
#' (similar to standard deviations)
#' @keywords standardization normalization median MAD mean outliers
#' @return A numeric vector of winsorized data.
#' @references Leys, C., Ley, C., Klein, O., Bernard, P., & Licata, L.
#' (2013). Detecting outliers: Do not use standard deviation
#' around the mean, use absolute deviation around the median.
#' *Journal of Experimental Social Psychology*, *49*(4), 764–766.
#' https://doi.org/10.1016/j.jesp.2013.03.013
#' @export
#' @examples
#' winsorize_mad(mtcars$qsec, criteria = 2)
#' @importFrom stats mad

winsorize_mad <- function(x,
                          criteria = 3) {
  if (criteria <= 0) {
    stop("bad value for 'criteria'")
  }
  med <- median(x, na.rm = TRUE)
  y <- x - med
  sc <- mad(y, center = 0, na.rm = TRUE) * criteria
  y[y > sc] <- sc
  y[y < -sc] <- -sc
  y + med
}
