#' @title Easily make nice APA tables
#'
#' @description Make nice APA tables easily through a wrapper around the `flextable` package with sensical defaults and automatic formatting features.
#'
#' @param dataframe The data frame, to be converted to a flextable. The data frame cannot have duplicate column names.
#' @param italics Which columns headers should be italic? Useful for column names that should be italic but that are not picked up automatically by the function. Select with numerical range, e.g., 1:3.
#' @param highlight Highlight rows with statistically significant results? Requires a column named "p" containing p-values. Can either accept logical (TRUE/FALSE) OR a numeric value for a custom critical p-value threshold (e.g., 0.10 or 0.001).
#' @param col.format.p Applies p-value formatting to columns that cannot be named "p" (for example for a data frame full of p-values, also because it is not possible to have more than one column named "p"). Select with numerical range, e.g., 1:3.
#' @param col.format.r Applies r-value formatting to columns that cannot be named "r" (for example for a data frame full of r-values, also because it is not possible to have more than one column named "r"). Select with numerical range, e.g., 1:3.
#' @param format.custom Applies custom formatting to columns selected via the `col.format.custom` argument. This is useful if one wants custom formatting other than for p- or r-values. It can also be used to transform (e.g., multiply) certain values or print a specific symbol along the values for instance.
#' @param col.format.custom Which columns to apply the custom function to. Select with numerical range, e.g., 1:3.
#' @param width Width of the table, in percentage of the total width, when exported e.g., to Word.
#'
#' @keywords APA style table
#' @examples
#' # Make the basic table
#' my_table <- nice_table(head(mtcars))
#' my_table
#'
#' \dontrun{
#' # Save table to word
#' save_as_docx(my_table, path = "nicetablehere.docx")
#' }
#'
#' # Publication-ready tables
#' mtcars.std <- lapply(mtcars, scale)
#' model <- lm(mpg ~ cyl + wt * hp, mtcars.std)
#' stats.table <- as.data.frame(summary(model)$coefficients)
#' CI <- confint(model)
#' stats.table <- cbind(row.names(stats.table),
#'                      stats.table, CI)
#' names(stats.table) <- c("Term", "B", "SE", "t", "p",
#'                         "CI_lower", "CI_upper")
#' nice_table(stats.table, highlight = TRUE)
#'
#' # Test different column names
#' test <- head(mtcars)
#' names(test) <- c("dR", "df", "M", "SD", "b", "np2",
#'                  "ges", "p", "r", "R2", "sr2")
#' test[, 10:11] <- test[, 10:11]/10
#' nice_table(test)
#'
#' # Custom cell formatting (such as p or r)
#' nice_table(test[8:11], col.format.p = 2:4, highlight = .001)
#'
#' nice_table(test[8:11], col.format.r = 1:4)
#'
#' # Apply custom functions to cells
#' fun <- function(x) {x+11.1}
#' nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
#'
#' fun <- function(x) {paste("x", x)}
#' nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
#'
#' @importFrom dplyr mutate %>% select matches
#' @importFrom flextable "flextable" theme_booktabs hline_top hline_bottom fontsize font align height hrule set_table_properties italic set_formatter colformat_double compose bold bg as_paragraph as_i as_sub as_sup

#' @export
nice_table <- function (dataframe, italics = NULL, highlight = FALSE, col.format.p = NULL,
                       col.format.r, format.custom, col.format.custom, width = 1) {
  dataframe
  if("CI_lower" %in% names(dataframe) & "CI_upper" %in% names(dataframe)) {
    dataframe[,c("CI_lower", "CI_upper")] <- lapply(lapply(
      dataframe[,c("CI_lower", "CI_upper")], as.numeric), round, 2)
    dataframe["95% CI"] <- apply(dataframe[,c("CI_lower", "CI_upper")], 1, function(x) paste0("[", x[1], ", ", x[2], "]"))
    dataframe <- select(dataframe, -c("CI_lower", "CI_upper"))
  }
  if(highlight == TRUE) {
    dataframe %>%
      mutate(signif = ifelse(p < .05, TRUE, FALSE)) -> dataframe
  }
  if(is.numeric(highlight)) {
    dataframe %>%
      mutate(signif = ifelse(p < highlight, TRUE, FALSE)) -> dataframe
  }
  nice.borders <- list("width" = 0.5, color = "black", style = "solid")
  dataframe %>%
    {if(highlight == TRUE | is.numeric(highlight))
      flextable(., col_keys = names(dataframe)[-length(dataframe)])
      else flextable(.)} %>%
    theme_booktabs %>%
    hline_top(part="head", border = nice.borders) %>%
    hline_bottom(part="head", border = nice.borders) %>%
    hline_top(part="body", border = nice.borders) %>%
    hline_bottom(part="body", border = nice.borders) %>%
    fontsize(part = "all", size = 12) %>%
    font(part = "all", fontname = "Times New Roman") %>%
    align(align = "center", part = "all") %>%
    #line_spacing(space = 2, part = "all") %>%
    height(height = 0.55, part = "body") %>%
    height(height = 0.55, part = "head") %>%
    hrule(rule = "exact", part = "all") %>%
    set_table_properties(layout = "autofit", width = width) -> table
  if(!missing(italics)) {
    table %>%
      italic(j = italics, part = "header") -> table
  }
  if("p" %in% names(dataframe)) {
    table %>%
      italic(j = "p", part = "header") %>%
      set_formatter(p = function(x) {
        format_p(x)}) -> table
  }
  if("r" %in% names(dataframe)) {
    table %>%
      italic(j = "r", part = "header") %>%
      set_formatter(r = function(x)
        format_r(x)) -> table
  }
  if("t" %in% names(dataframe)) {
    table %>%
      italic(j = "t", part = "header") %>%
      colformat_double(j = "t", big.mark=",", digits = 2) -> table
  }
  if("SE" %in% names(dataframe)) {
    table %>%
      italic(j = "SE", part = "header") %>%
      colformat_double(j = "SE", big.mark=",", digits = 2) -> table
  }
  if("SD" %in% names(dataframe)) {
    table %>%
      italic(j = "SD", part = "header") %>%
      colformat_double(j = "SD", big.mark=",", digits = 2) -> table
  }
  if("F" %in% names(dataframe)) {
    table %>%
      italic(j = "F", part = "header") %>%
      colformat_double(j = "F", big.mark=",", digits = 2) -> table
  }
  if("df" %in% names(dataframe)) {
    table %>%
      italic(j = "df", part = "header") %>%
      colformat_double(j = "df", big.mark=",", digits = 0) -> table
  }
  if("b" %in% names(dataframe)) {
    table %>%
      italic(j = "b", part = "header") %>%
      colformat_double(j = "b", big.mark=",", digits = 2) -> table
  }
  if("M" %in% names(dataframe)) {
    table %>%
      italic(j = "M", part = "header") %>%
      colformat_double(j = "M", big.mark=",", digits = 2) -> table
  }
  if("B" %in% names(dataframe)) {
    table %>%
      compose(i = 1, j = "B", part = "header",
              value = as_paragraph("\u03B2")) %>%
      colformat_double(j = "B", big.mark=",", digits = 2) -> table
  }
  if("R2" %in% names(dataframe)) {
    table %>%
      compose(i = 1, j = "R2", part = "header",
              value = as_paragraph(as_i("R"), as_sup("2"))) %>%
      set_formatter(R2 = function(x)
        format_r(x)) -> table
  }
  if("sr2" %in% names(dataframe)) {
    table %>%
      compose(i = 1, j = "sr2", part = "header",
              value = as_paragraph(as_i("sr"), as_sup("2"))) %>%
      set_formatter(sr2 = function(x)
        format_r(x)) -> table
  }
  if("np2" %in% names(dataframe)) {
    table %>%
      compose(i = 1, j = "np2", part = "header",
              value = as_paragraph("\u03b7", as_sub("p"), as_sup("2"))) %>%
      colformat_double(j = "np2", big.mark=",", digits = 2) -> table
  }
  if("ges" %in% names(dataframe)) {
    table %>%
      compose(i = 1, j = "ges", part = "header",
              value = as_paragraph("\u03b7", as_sub("G"), as_sup("2"))) %>%
      colformat_double(j = "ges", big.mark=",", digits = 2) -> table
  }
  if("dR" %in% names(dataframe)) {
    table %>%
      compose(i = 1, j = "dR", part = "header",
              value = as_paragraph(as_i("d"), as_sub("R"))) %>%
      colformat_double(j = "dR", big.mark=",", digits = 2) -> table
  }
  if("d" %in% names(dataframe)) {
    table %>%
      italic(j = "d", part = "header") %>%
      colformat_double(j = "d", big.mark=",", digits = 2) -> table
  }
  if(!missing(highlight)) {
    table %>%
      bold(i = ~ signif == TRUE,
           j = table$col_keys) %>%
      bg(i = ~ signif == TRUE,
         j = table$col_keys,
         bg = "#D9D9D9") -> table
  }
  table %>%
    colformat_double(j = (select(dataframe, where(is.numeric)) %>%
                            select(-matches("^p$|^r$|^t$|^SE$|^SD$|^F$|^df$|
                                    ^b$|^M$|^B$|^R2$|^sr2$|^np2$|^dR$",
                                            ignore.case = FALSE)) %>% names),
                     big.mark=",", digits = 2) -> table
  if(!missing(col.format.p)) {
    rExpression <- paste0("table <- table %>% set_formatter(table,`",
                          table$col_keys[col.format.p], "` = ", "format_p", ")")
    eval(parse(text = rExpression))
  }
  if(!missing(col.format.r)) {
    rExpression <- paste0("table <- table %>% set_formatter(table,`",
                          table$col_keys[col.format.r], "` = ", "format_r", ")")
    eval(parse(text = rExpression))
  }
  if(!missing(format.custom) & !missing(col.format.custom)) {
    rExpression <- paste0("table <- table %>% set_formatter(table,`",
                          table$col_keys[col.format.custom], "` = ", format.custom, ")")
    eval(parse(text = rExpression))
  }
  table
}
