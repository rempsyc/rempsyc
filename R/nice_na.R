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
#' @param data The data frame.
#' @param vars Variable (or lists of variables) to check for NAs.
#' @param scales The scale names to check for NAs (single character string).
#' @keywords missing values NA guidelines
#' @return A dataframe, with:
#'  - `var`: variables selected
#'  - `items`: number of items for selected variables
#'  - `na`: number of missing cell values for those variables (e.g., 2 missing
#'  values for first participant + 2 missing values for second participant
#'  = total of 4 missing values)
#'  - `cells`: total number of cells (i.e., number of participants multiplied by
#'  number of variables, `items`)
#'  - `na_percent`: the percentage of missing values (number of missing cells,
#'  `na`, divided by total number of cells, `cells`)
#'  - `na_max`: The amount of missing values for the participant with the most
#'  missing values for the selected variables
#'  - `na_max_percent`: The amount of missing values for the participant with
#'  the most missing values for the selected variables, in percentage
#'  (i.e., `na_max` divided by the number of selected variables, `items`)
#'  - `all_na`: the number of participants missing 100% of items for that scale
#'  (the selected variables)
#'
#' @export
#' @references Parent, M. C. (2013). Handling item-level missing
#' data: Simpler is just as good. *The Counseling Psychologist*,
#' *41*(4), 568-600. https://doi.org/10.1177%2F0011000012445176
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
#'   ID = c("idz", NA),
#'   scale1_Q1 = fun(), scale1_Q2 = fun(), scale1_Q3 = fun(),
#'   scale2_Q1 = fun(), scale2_Q2 = fun(), scale2_Q3 = fun(),
#'   scale3_Q1 = fun(), scale3_Q2 = fun(), scale3_Q3 = fun()
#' )
#'
#' # One can list the scale names directly:
#' nice_na(df, scales = c("ID", "scale1", "scale2", "scale3"))
#'
#' @importFrom dplyr select all_of bind_rows summarize %>% first last

nice_na <- function(data, vars, scales) {
  classes <- lapply(data, class)
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
    ungroup() %>%
    summarize(
      var = paste0(first(names(.)), ":", last(names(.))),
      items = ncol(.),
      na = sum(is.na(.)),
      cells = prod(dim(.)),
      na_percent = round(na / cells * 100, 2),
      na_max = max(rowSums(is.na(.))),
      na_max_percent = round(na_max / ncol(.) * 100, 2)) %>%
    mutate(all_na = sum(apply(data, 1, function(x) sum(is.na(x))) == ncol(data)))

}
