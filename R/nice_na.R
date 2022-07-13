#' @title Report missing values according to guidelines
#'
#' @description Nicely reports NA values according to existing guidelines. This function reports both absolute and percentage values of specified column lists. Some authors recommend reporting item-level missing item per scale, as well as participant’s maximum number of missing items by scale. For example, Parent (2013) writes:
#'
#' *I recommend that authors (a) state their tolerance level for missing data by scale or subscale (e.g., “We calculated means for all subscales on which participants gave at least 75% complete data”) and then (b) report the individual missingness rates by scale per data point (i.e., the number of missing values out of all data points on that scale for all participants) and the maximum by participant (e.g., “For Attachment Anxiety, a total of 4 missing data points out of 100 were observed, with no participant missing more than a single data point”).*
#'
#' See: Parent, M. C. (2013). Handling item-level missing data: Simpler is just as good. The *Counseling Psychologist*, *41*(4), 568-600. https://doi.org/10.1177%2F0011000012445176
#'
#' @param data The data frame.
#' @param vars Variable (or list of variables) to check for NAs.
#' @keywords missing values, NA, guidelines
#' @export
#' @examples
#' # Use whole data frame
#' nice_na(airquality)
#'
#' # Use selected columns
#' nice_na(airquality,
#'           vars = list(c("Ozone", "Solar.R", "Wind"),
#'                       c("Temp", "Month", "Day")))
#'
#' # This might make more sense with questionnaire items
#' set.seed(50)
#' df <- data.frame(scale1_Q1 = sample(c(NA, 1:6), replace = TRUE),
#'                  scale1_Q2 = sample(c(NA, 1:6), replace = TRUE),
#'                  scale1_Q3 = sample(c(NA, 1:6), replace = TRUE),
#'                  scale2_Q1 = sample(c(NA, 1:6), replace = TRUE),
#'                  scale2_Q2 = sample(c(NA, 1:6), replace = TRUE),
#'                  scale2_Q3 = sample(c(NA, 1:6), replace = TRUE),
#'                  scale3_Q1 = sample(c(NA, 1:6), replace = TRUE),
#'                  scale3_Q2 = sample(c(NA, 1:6), replace = TRUE),
#'                  scale3_Q3 = sample(c(NA, 1:6), replace = TRUE)
#' )
#' list.variables <- list(paste0("scale1_Q", 1:3),
#'                        paste0("scale2_Q", 1:3),
#'                        paste0("scale3_Q", 1:3))
#' nice_na(df, list.variables)
#'
#'
#' @importFrom dplyr select all_of bind_rows summarize %>% first last

nice_na <- function(data, vars) {
  if(missing(vars)) {vars <- names(data)}
  if(!is.list(vars)) {vars <- list(vars)}
  na_df <- nice_na_internal(data)
  if(length(vars) > 1) {
    na_list <- lapply(vars, function(x) {
      data <- data %>%
        select(all_of(x)) %>%
        nice_na_internal
    })
    na_df$var <- "Total"
    na_df <- bind_rows(na_list, na_df)
  }
  na_df
}

nice_na_internal <- function(data) {
  data %>%
    summarize(var = paste0(first(names(.)), ":", last(names(.))),
              na = sum(is.na(.)),
              cells = prod(dim(.)),
              na_percent = round(na/cells * 100, 2),
              na_max = max(rowSums(is.na(.))),
              na_max_percent = round(na_max/ncol(.) * 100, 2))
}
