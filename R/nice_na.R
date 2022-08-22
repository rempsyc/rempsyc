#' @title Report missing values according to guidelines
#'
#' @description Nicely reports NA values according to existing
#' guidelines. This function reports both absolute and percentage
#' values of specified column lists. Some authors recommend
#' reporting item-level missing item per scale, as well as
#' participant’s maximum number of missing items by scale.
#' For example, Parent (2013) writes:
#'
#' *I recommend that authors (a) state their tolerance level for
#' missing data by scale or subscale (e.g., “We calculated means
#' for all subscales on which participants gave at least 75%
#' complete data”) and then (b) report the individual missingness
#' rates by scale per data point (i.e., the number of missing
#' values out of all data points on that scale for all participants)
#' and the maximum by participant (e.g., “For Attachment Anxiety,
#' a total of 4 missing data points out of 100 were observed,
#' with no participant missing more than a single data point”).*
#'
#' See: Parent, M. C. (2013). Handling item-level missing
#' data: Simpler is just as good. *The Counseling Psychologist*,
#' *41*(4), 568-600. https://doi.org/10.1177%2F0011000012445176
#'
#' @param data The data frame.
#' @param vars Variable (or lists of variables) to check for NAs.
#' @param scales The scale names to check for NAs (single character string).
#' @keywords missing values, NA, guidelines
#' @export
#' @examples
#' # Use whole data frame
#' nice_na(airquality)
#'
#' # Use selected columns explicitly
#' nice_na(airquality,
#'   vars = list(
#'     c("Ozone", "Solar.R", "Wind"),
#'     c("Temp", "Month", "Day")
#'   )
#' )
#'
#' # If the questionnaire items start with the same name, e.g.,
#' set.seed(15)
#' fun <- function() {
#'   c(sample(c(NA, 1:10), replace = TRUE), NA, NA, NA)
#' }
#' df <- data.frame(
#'   scale1_Q1 = fun(), scale1_Q2 = fun(), scale1_Q3 = fun(),
#'   scale2_Q1 = fun(), scale2_Q2 = fun(), scale2_Q3 = fun(),
#'   scale3_Q1 = fun(), scale3_Q2 = fun(), scale3_Q3 = fun()
#' )
#'
#' # One can list the scale names directly:
#' nice_na(df, scales = c("scale1", "scale2", "scale3"))
#'
#' @importFrom dplyr select all_of bind_rows summarize %>% first last

nice_na <- function(data, vars, scales) {
  classes <- lapply(data, class)
  if (any(!(classes %in% "numeric"))) {
    warning("Some variables are not numeric. ",
            "They are ignored for calculating the `all_na` column.")
  }
  if (missing(vars) & missing(scales)) {
    vars.internal <- names(data)
  } else if (!missing(scales)) {
    vars.internal <- lapply(scales, function(x) {
      grep(paste0("^", x), names(data), value = TRUE)
    })
  }
  if (!missing(vars)) {
    vars.internal <- vars
  }
  if (!is.list(vars.internal)) {
    vars.internal <- list(vars.internal)
  }
  na_df <- nice_na_internal(data)
  if (!missing(vars) | !missing(scales)) {
    na_list <- lapply(vars.internal, function(x) {
      data <- data %>%
        select(all_of(x)) %>%
        nice_na_internal()
    })
    na_df$var <- "Total"
    na_df <- bind_rows(na_list, na_df)
  }
  na_df
}

nice_na_internal <- function(data) {
  data %>%
    summarize(
      var = paste0(first(names(.)), ":", last(names(.))),
      items = ncol(.),
      na = sum(is.na(.)),
      cells = prod(dim(.)),
      na_percent = round(na / cells * 100, 2),
      na_max = max(rowSums(is.na(.))),
      na_max_percent = round(na_max / ncol(.) * 100, 2),
      all_na = sum(is.na(rowMeans(select(., where(is.numeric)), na.rm = TRUE))))
}
