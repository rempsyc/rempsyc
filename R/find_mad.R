#' @title Identify outliers based on 3 MAD
#'
#' @description Identify outliers based on 3 median absolute deviations (MAD).
#'
#' See: Leys, C., Ley, C., Klein, O., Bernard, P., & Licata, L. (2013).
#' Detecting outliers: Do not use standard deviation around the mean,
#' use absolute deviation around the median. *Journal of Experimental
#' Social Psychology*, *49*(4), 764–766.
#' https://doi.org/10.1016/j.jesp.2013.03.013
#'
#' @param data The data frame.
#' @param col.list List of variables to check for outliers.
#' @param ID ID variable if you would like the outliers to be identified
#' as such.
#' @param criteria How many MAD to use as threshold (similar to standard
#' deviations)
#' @param mad.scores Logical, whether to output robust z (MAD) scores (default)
#'                   or raw scores. Defaults to `TRUE`.
#' @keywords standardization normalization median MAD mean outliers
#' @author Hugues Leduc, Charles-Étienne Lavoie, Rémi Thériault
#' @return A list of dataframes of outliers per variable, with row
#'         numbers, based on the MAD. When printed, provides the number
#'         of outliers, selected variables, and any outlier flagged for
#'         more than one variable. More information can be obtainned
#'         by using the `attributes()` function around the generated object.
#' @export
#' @examples
#' find_mad(
#'   data = mtcars,
#'   col.list = names(mtcars),
#'   criteria = 3
#' )
#'
#' mtcars2 <- mtcars
#' mtcars2$car <- row.names(mtcars)
#' find_mad(
#'   data = mtcars2,
#'   col.list = names(mtcars),
#'   ID = "car",
#'   criteria = 3
#' )
#' @importFrom dplyr mutate %>% select ends_with across all_of
#' if_any filter bind_rows count n

#' @export
find_mad <- function(data,
                     col.list,
                     ID = NULL,
                     criteria = 3,
                     mad.scores = TRUE) {
  if (missing(ID)) {
    data$ID <- rownames(data)
  }
  row.names(data) <- NULL

  mad0.list <- lapply(col.list, function(x) {
    find_mad0(data,
              x,
              ID = ID,
              criteria = criteria,
              mad.scores = mad.scores
    )
  })
  names(mad0.list) <- col.list
  mad0.list <- mad0.list[lapply(mad0.list, nrow) > 0]

  duplicates.df <- bind_rows(mad0.list) %>%
    select(where(~ !all(is.na(.x))))
  if (nrow(duplicates.df) > 0) {
    if (!missing(ID)) {
      duplicates.df <- duplicates.df %>%
        count(Row, .[[ID]]) %>%
        rename({{ ID }} := ".[[ID]]")
    } else {
      duplicates.df <- duplicates.df %>%
        count(Row)
    }
    duplicates.df <- duplicates.df %>%
      filter(n > 1)
  }
  mad0 <- find_mad0(data, col.list, ID = ID, criteria, mad.scores)

  # Define attributes!
  out <- mad0.list
  class(out) <- "find_mad"
  attr(out, "outlier_list") <- mad0.list
  attr(out, "outlier_total") <- mad0
  attr(out, "outlier_multiple") <- duplicates.df
  attr(out, "criteria") <- criteria
  attr(out, "col.list") <- col.list
  out

}

#' @noRd
find_mad0 <- function(data, col.list, ID = ID, criteria = 3, mad.scores) {
  if (criteria <= 0) {
    stop("Criteria needs to be greater than one.")
  }
  data <- data %>%
    select(-ends_with("_mad")) %>%
    mutate(
      Row = row(.[1]),
      across(all_of(col.list), rempsyc::scale_mad,
             .names = "{col}_mad"
      )
    ) %>%
    filter(if_any(ends_with("_mad"), ~ . > criteria | . < -criteria))

  if (isTRUE(mad.scores)) {
    data <- data %>%
      select(Row, all_of(ID), ends_with("_mad"))
  } else {
    data <- data %>%
      select(Row, all_of(ID), all_of(col.list))
  }
  data
}

#' @noRd
print.find_mad <- function(x, ...) {
  mad0 <- attr(x, "outlier_total")
  duplicates.df <- attr(x, "outlier_multiple")
  criteria <- attr(x, "criteria")
  col.list <- attr(x, "col.list")
  mad0.list <- attr(x, "outlier_list")

  if (isTRUE(nrow(mad0) > 0)) {
    cat(
      nrow(mad0), "outlier(s) based on", criteria,
      "median absolute deviations for variable(s): \n",
      paste0(col.list, collapse = ", "), "\n\n"
    )
    if (nrow(duplicates.df) > 0) {
      cat(
        "The following participants were considered outliers ",
        "for more than one variable: \n\n",
        sep = ""
      )
      print(duplicates.df)
      cat("\n")
    }
    cat("Outliers per variable: \n\n")
    print(mad0.list)
  } else {
    cat(
      "There were no outlier based on", criteria,
      "median absolute deviations.\n\n"
    )
  }
}
