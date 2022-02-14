#' @title Make nice APA tables easily
#'
#' @description Make nice APA tables easily through a wrapper around the `flextable` package with sensical defaults and automatic formatting features.
#' @param dataframe The dataframe
#' @keywords APA style table
#' @export
#' @examples
#' # Make the basic table
#' my_table <- nice_table(head(mtcars))
#' my_table
#'
#' # Save table to word
#' save_as_docx(my_table, path = "nicetablehere.docx")
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
#'
#' nice_table(stats.table, highlight = TRUE)
#'
#' # Test different column names
#' test <- head(mtcars)
#' names(test) <- c("dR", "df", "M", "SD", "b", "np2",
#'                  "ges", "p", "r", "R2", "sr2")
#' test[, 10:11] <- test[, 10:11]/10
#'
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
#' # For the example below, I have to use a unicode
#' # character code instead of the multiplication symbol
#' # because of package documentation restrictions but you
#' # can use special characters directly.
#' fun <- function(x) {paste("\u00d7", x)}
#' nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")

nice_table <- function (dataframe, italics = NULL, highlight = FALSE, col.format.p = NULL,
                       col.format.r, format.custom, col.format.custom) {
  dataframe
  library(flextable)
  library(dplyr)
  if("CI_lower" %in% names(dataframe) & "CI_upper" %in% names(dataframe)) {
    dataframe[,c("CI_lower", "CI_upper")] <- lapply(lapply(dataframe[,c("CI_lower", "CI_upper")], as.numeric), round, 2)
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
    {if(highlight == TRUE | is.numeric(highlight)) flextable(., col_keys = names(dataframe)[-length(dataframe)])
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
    set_table_properties(layout = "autofit") -> table
  if(!missing(italics)) {
    table %>%
      italic(j = italics, part = "header") -> table
  }
  format.p <- function(p, precision = 0.001) {
    digits <- -log(precision, base = 10)
    p <- formatC(p, format = 'f', digits = digits)
    p[p == formatC(0, format = 'f', digits = digits)] <- paste0('< ', precision)
    sub("0", "", p)
  }
  format.r <- function(r, precision = 0.01) {
    digits <- -log(precision, base = 10)
    r <- formatC(r, format = 'f', digits = digits)
    sub("0", "", r)}
  if("p" %in% names(dataframe)) {
    table %>%
      italic(j = "p", part = "header") %>%
      set_formatter(p = function(x) {
        format.p(x)}) -> table
  }
  if("r" %in% names(dataframe)) {
    table %>%
      italic(j = "r", part = "header") %>%
      set_formatter(r = function(x)
        format.r(x)) -> table
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
              value = as_paragraph("β")) %>%
      colformat_double(j = "B", big.mark=",", digits = 2) -> table
  }
  if("R2" %in% names(dataframe)) {
    table %>%
      compose(i = 1, j = "R2", part = "header",
              value = as_paragraph(as_i("R"), as_sup("2"))) %>%
      set_formatter(R2 = function(x)
        format.r(x)) -> table
  }
  if("sr2" %in% names(dataframe)) {
    table %>%
      compose(i = 1, j = "sr2", part = "header",
              value = as_paragraph(as_i("sr"), as_sup("2"))) %>%
      set_formatter(sr2 = function(x)
        format.r(x)) -> table
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
                                            ignore.case =F)) %>% names),
                     big.mark=",", digits = 2) -> table
  if(!missing(col.format.p)) {
    rExpression = paste0("table <- table %>% set_formatter(table,`", table$col_keys[col.format.p], "` = ", "format.p", ")")
    eval(parse(text = rExpression))
  }
  if(!missing(col.format.r)) {
    rExpression = paste0("table <- table %>% set_formatter(table,`", table$col_keys[col.format.r], "` = ", "format.r", ")")
    eval(parse(text = rExpression))
  }
  if(!missing(format.custom) & !missing(col.format.custom)) {
    rExpression = paste0("table <- table %>% set_formatter(table,`", table$col_keys[col.format.custom], "` = ", format.custom, ")")
    eval(parse(text = rExpression))
  }
  table
}
