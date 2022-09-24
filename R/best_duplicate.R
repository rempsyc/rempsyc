#' @title Choose the best duplicate
#'
#' @description Chooses the best duplicate, based on the
#' duplicate with the fewer number of NA values. In case of ties,
#' it picks the first duplicate, as it is the one most likely to
#' be valid and authentic, given practice effects.
#'
#' @param data The data frame.
#' @param id The ID variable for which to check for duplicates.
#' @keywords duplicates
#' @return A dataframe, containing only the "best" duplicates.
#' @export
#' @examples
#' df1 <- data.frame(
#'    id = c(1, 2, 3, 1, 3),
#'    item1 = c(NA, 1, 1, 2, 3),
#'    item2 = c(NA, 1, 1, 2, 3),
#'    item3 = c(NA, 1, 1, 2, 3)
#' )
#'
#' best_duplicate(df1, id = "id")
#'
#' @importFrom dplyr mutate group_by group_by slice_min distinct %>% ungroup

best_duplicate <- function(data, id) {

  og.names <- names(data)
  dups <- data %>%
    extract_duplicates(id)
  dups.n <- sum(duplicated(dups[[id]]))

  good.dups <- dups %>%
    group_by(.data[[id]]) %>%
    slice_min(.data$count_na) %>%
    distinct(.data[[id]], .keep_all = TRUE) %>%
    ungroup() %>%
    select(all_of(og.names))

  good.data <- distinct(data, .data[[id]], .keep_all = TRUE)
  match.index <- good.data[[id]] %in% good.dups[[id]]
  good.data[match.index, ] <- good.dups

  dup.msg <- " duplicates removed)"
  dup.msg <- c(dup.msg, ifelse(dups.n != 69, "", " 69... nice"))
  message("(", dups.n, dup.msg, sep = "")
  good.data

}
