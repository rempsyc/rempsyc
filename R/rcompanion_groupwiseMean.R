#' @title Get group means and CIs (rcompanion::groupwiseMean)
#'
#' @description Get group means and bootstrapped effect sizes
#' from the `rcompanion` package and `groupwiseMean` function.
#' The function had to be taken separately from the package as
#' the dependency is failing upon install of the current package.
#'
#' From the original documentation: "Calculates means and
#' confidence intervals for groups."
#'
#' From: https://rcompanion.org/handbook/C_03.html
#'
#' "For routine use, I recommend using bootstrapped confidence
#' intervals, particularly the BCa or percentile methods (but...)
#' by default, the function reports confidence intervals by the
#' traditional method."
#'
#' @param formula A formula indicating the measurement variable and
#'                the grouping variables. e.g. y ~ x1 + x2.
#' @param data The data frame to use.
#' @param var The measurement variable to use. The name is in double quotes.
#' @param group The grouping variable to use. The name is in double quotes.
#'              Multiple names are listed as a vector. (See example.)
#' @param trim The proportion of observations trimmed from each end of the
#'             values before the mean is calculated. (As in \code{mean()})
#' @param na.rm If \code{TRUE}, \code{NA} values are removed during
#'              calculations. (As in \code{mean()})
#' @param conf The confidence interval to use.
#' @param R The number of bootstrap replicates to use for bootstrapped
#'          statistics.
#' @param boot If \code{TRUE}, includes the mean of the bootstrapped means.
#'             This can be used as an estimate of the mean for
#'             the group.
#' @param traditional If \code{TRUE}, includes the traditional confidence
#'                    intervals for the group means, using the t-distribution.
#'                    If \code{trim} is not 0,
#'                    the traditional confidence interval
#'                    will produce \code{NA}.
#'                    Likewise, if there are \code{NA} values that are not
#'                    removed, the traditional confidence interval
#'                    will produce \code{NA}.
#' @param normal If \code{TRUE}, includes the normal confidence
#'                    intervals for the group means by bootstrap.
#'                    See \code{{boot::boot.ci}}.
#' @param basic If \code{TRUE}, includes the basic confidence
#'                    intervals for the group means by bootstrap.
#'                    See \code{{boot::boot.ci}}.
#' @param percentile If \code{TRUE}, includes the percentile confidence
#'                    intervals for the group means by bootstrap.
#'                    See \code{{boot::boot.ci}}.
#' @param bca If \code{TRUE}, includes the BCa confidence
#'                    intervals for the group means by bootstrap.
#'                    See \code{{boot::boot.ci}}.
#' @param digits The number of significant figures to use in output.
#' @param ... Other arguments passed to the \code{boot} function.
#'
#' @details The input should include either \code{formula} and \code{data};
#'              or \code{data}, \code{var}, and \code{group}. (See examples).
#'
#'          Results for ungrouped (one-sample) data can be obtained by either
#'          setting the right side of the formula to 1, e.g.  y ~ 1, or by
#'          setting \code{group=NULL} when using \code{var}.
#'
#' @note    The parsing of the formula is simplistic. The first variable on the
#'          left side is used as the measurement variable.  The variables on the
#'          right side are used for the grouping variables.
#'
#'          In general, it is advisable to handle \code{NA} values before
#'          using this function.
#'          With some options, the function may not handle missing values well,
#'          or in the manner desired by the user.
#'          In particular, if \code{bca=TRUE} and there are \code{NA} values,
#'          the function may fail.
#'
#'          For a traditional method to calculate confidence intervals
#'          on trimmed means,
#'          see Rand Wilcox, Introduction to Robust Estimation and
#'          Hypothesis Testing.
#'
#' @export
#' @author Salvatore Mangiafico, \email{mangiafico@njaes.rutgers.edu}
#' @references \url{http://rcompanion.org/handbook/C_03.html}
#' @concept mean confidence interval bootstrap
#' @return A data frame of requested statistics by group.
#' @keywords group means confidence intervals bootstrapping internal
#' @examples
#' \donttest{
#' ### Example with formula notation
#' data(mtcars)
#' rcompanion_groupwiseMean(mpg ~ factor(cyl),
#'   data         = mtcars,
#'   traditional  = FALSE,
#'   percentile   = TRUE
#' )
#'
#' # Example with variable notation
#' data(mtcars)
#' rcompanion_groupwiseMean(
#'   data = mtcars,
#'   var = "mpg",
#'   group = c("cyl", "am"),
#'   traditional = FALSE,
#'   percentile = TRUE
#' )
#' }
#'
#' @importFrom dplyr syms cur_data group_by summarize rename all_of across

rcompanion_groupwiseMean <- function(formula = NULL,
                                     data = NULL,
                                     var = NULL,
                                     group = NULL,
                                     trim = 0,
                                     na.rm = FALSE,
                                     conf = 0.95,
                                     R = 5000,
                                     boot = FALSE,
                                     traditional = TRUE,
                                     normal = FALSE,
                                     basic = FALSE,
                                     percentile = FALSE,
                                     bca = FALSE,
                                     digits = 3,
                                     ...) {
  ddply <- function(.data, .variables, var, .fun, ...) {
    .data %>%
      group_by(across(all_of(.variables))) %>%
      summarize(V1 = .fun(as.data.frame(cur_data()), var), .groups = "drop") %>%
      as.data.frame()
  }

  if (!is.null(formula)) {
    var <- all.vars(formula[[2]])[1]
    group <- all.vars(formula[[3]])
  }
  if (na.rm) {
    DF <- ddply(.data = data, .variables = group, var, .fun = function(x,
                                                                       idx) {
      sum(!is.na(x[, idx]))
    })
  }
  if (!na.rm) {
    DF <- ddply(.data = data, .variables = group, var, .fun = function(x,
                                                                       idx) {
      length(x[, idx])
    })
  }
  fun1 <- function(x, idx) {
    as.numeric(mean(x[, idx], trim = trim, na.rm = na.rm))
  }
  D1 <- ddply(.data = data, .variables = group, var, .fun = fun1)
  if (boot == TRUE) {
    fun2 <- function(x, idx) {
      mean(boot::boot(x[, idx], function(y, j) {
        mean(y[j], trim = trim, na.rm = na.rm)
      }, R = R, ...)$t[, 1])
    }
    D2 <- ddply(.data = data, .variables = group, var, .fun = fun2)
  }
  if (basic == TRUE) {
    fun4 <- function(x, idx) {
      boot::boot.ci(boot::boot(x[, idx], function(y, j) {
        mean(y[j], trim = trim, na.rm = na.rm)
      }, R = R, ...),
      conf = conf,
      type = "basic", ...
      )$basic[4]
    }
    fun5 <- function(x, idx) {
      boot::boot.ci(boot::boot(x[, idx], function(y, j) {
        mean(y[j], trim = trim)
      }, R = R, ...),
      conf = conf, type = "basic",
      ...
      )$basic[5]
    }
    D4 <- ddply(.data = data, .variables = group, var, .fun = fun4)
    D5 <- ddply(.data = data, .variables = group, var, .fun = fun5)
  }
  if (normal == TRUE) {
    fun6 <- function(x, idx) {
      boot::boot.ci(boot::boot(x[, idx], function(y, j) {
        mean(y[j], trim = trim, na.rm = na.rm)
      }, R = R, ...),
      conf = conf,
      type = "norm", ...
      )$normal[2]
    }
    fun7 <- function(x, idx) {
      boot::boot.ci(boot::boot(x[, idx], function(y, j) {
        mean(y[j], trim = trim, na.rm = na.rm)
      }, R = R, ...),
      conf = conf,
      type = "norm", ...
      )$normal[3]
    }
    D6 <- ddply(.data = data, .variables = group, var, .fun = fun6)
    D7 <- ddply(.data = data, .variables = group, var, .fun = fun7)
  }
  if (percentile == TRUE) {
    fun8 <- function(x, idx) {
      boot::boot.ci(boot::boot(x[, idx], function(y, j) {
        mean(y[j], trim = trim, na.rm = na.rm)
      }, R = R, ...),
      conf = conf,
      type = "perc", ...
      )$percent[4]
    }
    fun9 <- function(x, idx) {
      boot::boot.ci(boot::boot(x[, idx], function(y, j) {
        mean(y[j], trim = trim, na.rm = na.rm)
      }, R = R, ...),
      conf = conf,
      type = "perc", ...
      )$percent[5]
    }
    D8 <- ddply(.data = data, .variables = group, var, .fun = fun8)
    D9 <- ddply(.data = data, .variables = group, var, .fun = fun9)
  }
  if (bca == TRUE) {
    fun10 <- function(x, idx) {
      boot::boot.ci(boot::boot(x[, idx], function(y, j) {
        mean(y[j], trim = trim, na.rm = na.rm)
      }, R = R, ...),
      conf = conf,
      type = "bca", ...
      )$bca[4]
    }
    fun11 <- function(x, idx) {
      boot::boot.ci(boot::boot(x[, idx], function(y, j) {
        mean(y[j], trim = trim, na.rm = na.rm)
      }, R = R, ...),
      conf = conf,
      type = "bca", ...
      )$bca[5]
    }
    D10 <- ddply(.data = data, .variables = group, var, .fun = fun10)
    D11 <- ddply(.data = data, .variables = group, var, .fun = fun11)
  }
  if (traditional == TRUE) {
    Confy <- function(x, ...) {
      S <- sd(x, na.rm = na.rm)
      if (na.rm) {
        N <- length(x[!is.na(x)])
      }
      if (!na.rm) {
        N <- length(x)
      }
      Dist <- conf + (1 - conf) / 2
      Inty <- stats::qt(Dist, df = (N - 1)) * S / sqrt(N)
      if (trim == 0) {
        return(Inty)
      }
      if (trim != 0) {
        return(NA)
      }
    }
    fun12 <- function(x, idx) {
      mean(x[, idx], na.rm = na.rm) - Confy(x[, idx])
    }
    fun13 <- function(x, idx) {
      mean(x[, idx], na.rm = na.rm) + Confy(x[, idx])
    }
    D12 <- ddply(.data = data, .variables = group, var, .fun = fun12)
    D13 <- ddply(.data = data, .variables = group, var, .fun = fun13)
  }

  DF <- rename(DF, n = V1)
  DF$Mean <- signif(D1$V1, digits = digits)
  if (boot == TRUE) {
    DF$Boot.mean <- signif(D2$V1, digits = digits)
  }
  if (basic | normal | percentile | bca | traditional) {
    DF$Conf.level <- conf
  }
  if (traditional == TRUE) {
    DF$Trad.lower <- signif(D12$V1, digits = digits)
  }
  if (traditional == TRUE) {
    DF$Trad.upper <- signif(D13$V1, digits = digits)
  }
  if (basic == TRUE) {
    DF$Basic.lower <- signif(D4$V1, digits = digits)
  }
  if (basic == TRUE) {
    DF$Basic.upper <- signif(D5$V1, digits = digits)
  }
  if (normal == TRUE) {
    DF$Normal.lower <- signif(D6$V1, digits = digits)
  }
  if (normal == TRUE) {
    DF$Normal.upper <- signif(D7$V1, digits = digits)
  }
  if (percentile == TRUE) {
    DF$Percentile.lower <- signif(D8$V1, digits = digits)
  }
  if (percentile == TRUE) {
    DF$Percentile.upper <- signif(D9$V1, digits = digits)
  }
  if (bca == TRUE) {
    DF$Bca.lower <- signif(D10$V1, digits = digits)
  }
  if (bca == TRUE) {
    DF$Bca.upper <- signif(D11$V1, digits = digits)
  }
  return(DF)
}
