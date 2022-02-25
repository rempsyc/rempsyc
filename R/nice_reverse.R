#' @title Easily recode scores
#'
#' @description Easily recode scores (reverse-score), typically for questionnaire answers.
#'
#' @param x the score to reverse
#' @param max the maximum score on the scale
#' @param min the miminum score on the scale (optional unless it isn't 1)
#' @param warning whether to show the warning about the minimum not being 1
#'
#' @keywords reverse scoring
#' @export
#' @examples
#' # Reverse score of 5 with a maximum score of 5
#' nice_reverse(5, 5)
#'
#' # Reverse score of 1 with a maximum score of 5
#' nice_reverse(1, 5)
#'
#' # Reverse score of 3 with a maximum score of 5
#' nice_reverse(3, 5)
#'
#' # Reverse score of 4 with a maximum score of 4 and a minimum of 0
#' nice_reverse(4, 4, min = 0)
#'
#' # Reverse score of 0 with a maximum score of 4 and a minimum of 0
#' nice_reverse(0, 4, min = 0)
#'
#' # Reverse score of -3 with a maximum score of 3 and a minimum of -3
#' nice_reverse(-3, 3, min = -3)
#'
#' # Reverse score of 0 with a maximum score of 4 and a minimum of 0
#' nice_reverse(3, 3, min = -3)

nice_reverse <- function(x, max, min = 1, warning = TRUE) {
  if(missing(min) & warning == TRUE) { message("If your scale minimum score is not '1', please specify it in the 'min' argument")}
  if(min < 1) {
    max + 1 - as.numeric(x) - 1 + min
    } else
      max + 1 - as.numeric(x)
}
