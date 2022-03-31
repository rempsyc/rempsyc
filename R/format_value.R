#' @title Easily format p or r values
#'
#' @description Easily format p or r values. Note: converts to character class for use in figures or manuscripts to accommodate e.g., "< .001".
#'
#' @param p p-value to format
#' @param r r-value to format
#' @param precision Level of precision desired, if necessary
#' @param type Specify r or p value
#' @param type Value to be formatted, when using the generic `format_value()`
#' @param ... To specify precision level, if necessary, when using the generic `format_value()`
#'
#' @keywords formatting, p-value, r-value, correlation
#' @export
#' @examples
#' format_value(0.00041231, "p")
#' format_value(0.00041231, "r")
#' format_p(0.0041231)
#' format_p(0.00041231)
#' format_r(0.41231)
#' format_r(0.041231)
#' @name format_value
format_value <- function(value, type, ...) {
  if(type == "r") {format_r(value, ...)}
  else if(type == "p") {format_p(value, ...)}
}

#' @export
#' @rdname format_value
format_p <- function(p, precision = 0.001) {
  digits <- -log(precision, base = 10)
  p <- formatC(p, format = 'f', digits = digits)
  p[p == formatC(0, format = 'f', digits = digits)] <- paste0('< ', precision)
  sub("0", "", p)
}

#' @export
#' @rdname format_value
format_r <- function(r, precision = 0.01) {
  digits <- -log(precision, base = 10)
  r <- formatC(r, format = 'f', digits = digits)
  sub("0", "", r)}
