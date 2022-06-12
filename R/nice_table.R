#' @title Easily make nice APA tables
#'
#' @description Make nice APA tables easily through a wrapper around the `flextable` package with sensical defaults and automatic formatting features.
#'
#' @param data The data frame, to be converted to a flextable. The data frame cannot have duplicate column names.
#' @param italics Which columns headers should be italic? Useful for column names that should be italic but that are not picked up automatically by the function. Select with numerical range, e.g., 1:3.
#' @param highlight Highlight rows with statistically significant results? Requires a column named "p" containing p-values. Can either accept logical (TRUE/FALSE) OR a numeric value for a custom critical p-value threshold (e.g., 0.10 or 0.001).
#' @param col.format.p Applies p-value formatting to columns that cannot be named "p" (for example for a data frame full of p-values, also because it is not possible to have more than one column named "p"). Select with numerical range, e.g., 1:3.
#' @param col.format.r Applies r-value formatting to columns that cannot be named "r" (for example for a data frame full of r-values, also because it is not possible to have more than one column named "r"). Select with numerical range, e.g., 1:3.
#' @param format.custom Applies custom formatting to columns selected via the `col.format.custom` argument. This is useful if one wants custom formatting other than for p- or r-values. It can also be used to transform (e.g., multiply) certain values or print a specific symbol along the values for instance.
#' @param col.format.custom Which columns to apply the custom function to. Select with numerical range, e.g., 1:3.
#' @param width Width of the table, in percentage of the total width, when exported e.g., to Word.
#' @param broom If providing a tidy table produced with the `broom` package, which model type to use if one wants automatic formatting (options are "t.test", "lm", "cor.test", and "wilcox.test").
#' @param report If providing an object produced with the `report` package, which model type to use if one wants automatic formatting (options are "t.test", "lm", and "cor.test").
#' @param short Logical. Whether to return an abbreviated version of the tables made by the `report` package.
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
#' names(test) <- c("dR", "N", "M", "SD", "b", "np2",
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
#' @importFrom dplyr mutate %>% select matches case_when relocate across contains select_if
#' @importFrom flextable "flextable" theme_booktabs hline_top hline_bottom fontsize font align height hrule set_table_properties italic set_formatter colformat_double compose bold bg as_paragraph as_i as_sub as_sup
#' @importFrom rlang :=
#'
#' @seealso
#' Tutorial: \url{https://remi-theriault.com/blog_table}
#'

#' @export
nice_table <- function (data,
                        highlight = FALSE,
                        italics,
                        col.format.p,
                        col.format.r,
                        format.custom,
                        col.format.custom,
                        width = 1,
                        broom = "",
                        report = "",
                        short = FALSE) {
  dataframe <- data

  #   ____________________________________________________________________________
  #   Broom integration                                                       ####

  if(!missing(broom)) {
    dataframe %>%
      rename_with(
        ~ case_when(
          . == "p.value" ~ "p",
          . == "conf.low" ~ "CI_lower",
          . == "conf.high" ~ "CI_upper",
          . == "statistic" ~ "t",
          . == "std.error" ~ "SE",
          . == "parameter" ~ "df",
          . == "term" ~ "Term",
          . == "method" ~ "Method",
          . == "alternative" ~ "Alternative",
          TRUE ~ .)) -> dataframe
  }
  if(broom == "t.test") {
    dataframe %>%
      relocate(estimate, .after = estimate2) %>%
      rename_with(
        ~ case_when(
          . == "estimate" ~ "M1 - M2",
          . == "estimate1" ~ "Mean 1",
          . == "estimate2" ~ "Mean 2",
          TRUE ~ .)) %>%
      relocate(df, .before = p) %>%
      relocate(Method:Alternative) -> dataframe
  }
  if(broom == "lm") {
    dataframe %>%
      rename_with(
        ~ case_when(
          . == "estimate" ~ "b",
          TRUE ~ .)) -> dataframe
  }
  if(broom == "cor.test") {
    dataframe %>%
      rename_with(
        ~ case_when(
          . == "estimate" ~ "r",
          TRUE ~ .)) %>%
      relocate(df, .before = p) %>%
      relocate(Method:Alternative, .before = r) -> dataframe
  }
  if(broom == "wilcox.test") {
    dataframe %>%
      rename_with(
        ~ case_when(
          . == "t" ~ "W",
          TRUE ~ .)) %>%
      relocate(Method:Alternative, .before = W) -> dataframe
  }

  #   ____________________________________________________________________________
  #   Report integration                                                      ####

  if(!missing(report)) {
    dataframe %>%
      rename_with(
        ~ case_when(
          . == "CI_low" ~ "CI_lower",
          . == "CI_high" ~ "CI_upper",
          . == "df_error" ~ "df",
          TRUE ~ .)) %>%
      select(-CI) -> dataframe
  }
  if(report == "cor.test") {
    dataframe %>%
      relocate(Method:Alternative) -> dataframe
  }
  if(report == "t.test") {
    dataframe %>%
      rename_with(
        ~ case_when(
          . == "Cohens_d_CI_low" ~ "d_CI_low",
          . == "Cohens_d_CI_high" ~ "d_CI_high",
          . == "Cohens_d" ~ "d",
          TRUE ~ .)) %>%
      relocate(Method:Alternative) -> dataframe

    dataframe %>%
      format_CI(col.name = "95% CI (t)") %>%
      relocate(`95% CI (t)`, .after = t) -> dataframe

    dataframe %>%
      format_CI(c("d_CI_low", "d_CI_high"),
                col.name = "95% CI (d)") -> dataframe

    if(short == TRUE) {
      dataframe <- dataframe %>%
        select_if(!names(.) %in% c("Method", "Alternative", "Mean_Group1",
                                   "Mean_Group2", "Difference", "95% CI (t)"))
    }

  }
  if(report == "lm") {
    dataframe %>%
      rename_with(
        ~ case_when(
          . == "Coefficient" ~ "b",
          . == "Std_Coefficient" ~ "B",
          TRUE ~ .)) %>%
      relocate(Fit, .after = Parameter) -> dataframe

    dataframe %>%
      format_CI(col.name = "95% CI (b)") %>%
      relocate(`95% CI (b)`, .after = b) -> dataframe

    dataframe %>%
      format_CI(c("Std_Coefficient_CI_low", "Std_Coefficient_CI_high"),
                col.name = "95% CI (B)") -> dataframe

    if(short == TRUE) {
      dataframe <- select(dataframe, -c("Fit", "95% CI (b)"))
      dataframe <- dataframe[-(
        which(is.na(dataframe$Parameter)):nrow(dataframe)),]
    }
  }

  #   ____________________________________________________________________________
  #   Formatting                                                              ####

  if("CI_lower" %in% names(dataframe) & "CI_upper" %in% names(dataframe)) {
    dataframe <- format_CI(dataframe)
  }
  dataframe %>%
    mutate(across(contains("95% CI"), ~ ifelse(.x == "[ NA,  NA]", "", .x))) -> dataframe
  if(highlight == TRUE) {
    dataframe %>%
      mutate(signif = ifelse(p < .05, TRUE, FALSE)) -> dataframe
  }
  if(is.numeric(highlight)) {
    dataframe %>%
      mutate(signif = ifelse(p < highlight, TRUE, FALSE)) -> dataframe
  }
  nice.borders <- list("width" = 0.5, color = "black", style = "solid")

  #   ____________________________________________________________________________
  #   Flextable                                                               ####

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
    hrule(rule = "exact", part = "all") -> table

  if(!missing(width)) {
    table %>%
    set_table_properties(layout = "autofit", width = width) -> table
  } else {
    table %>%
      set_table_properties(layout = "autofit") -> table
  }

  #   ____________________________________________________________________________
  #   Column formatting                                                       ####

  ##  ............................................................................
  ##  Special cases                                                           ####
  if(!missing(italics)) {
    table %>%
      italic(j = italics, part = "header") -> table
  }
  if("df" %in% names(dataframe)) {
    df.digits <- ifelse(any(dataframe$df %% 1 == 0), 0, 2)
    table %>%
      format_flex(j = "df", digits = df.digits) -> table
  }

  ##  ............................................................................
  ##  2-digit columns                                                         ####
  cols.2digits <- c("t", "SE", "SD", "F", "b", "M", "W", "d")
  for(i in cols.2digits) {
    if(i %in% names(dataframe)) {
      table %>%
        format_flex(j = i) -> table
    }
  }

  ##  ............................................................................
  ##  0-digit columns                                                         ####
  cols.0digits <- c("N", "n", "z")
  for(i in cols.0digits) {
    if(i %in% names(dataframe)) {
      table %>%
        format_flex(j = i, digits = 0) -> table
    }
  }

  ##  ............................................................................
  ##  Formatting functions                                                    ####
  compose.table0 <- data.frame(
    col = c("r", "p"),
    fun = c("format_r", "format_p"))
  for(i in seq(nrow(compose.table0))) {
    if(compose.table0[i, "col"] %in% names(dataframe)) {
      table %>%
        format_flex(j = compose.table0[i, "col"],
                    fun = compose.table0[i, "fun"]) -> table
    }
  }

  ##  ............................................................................
  ##  Special symbols                                                         ####
  compose.table1 <- data.frame(
    col = c("95% CI (b)", "95% CI (B)", "95% CI (t)", "95% CI (d)", "B",
            "np2", "ges", "dR", "Predictor (+/-1 SD)", "M1 - M2"),
    value = c('"95% CI (", as_i("b"), ")"',
              '"95% CI (", "\u03B2", ")"',
              '"95% CI (", as_i("t"), ")"',
              '"95% CI (", as_i("d"), ")"',
              '"\u03B2"',
              '"\u03b7", as_sub("p"), as_sup("2")',
              '"\u03b7", as_sub("G"), as_sup("2")',
              'as_i("d"), as_sub("R")',
              '"Predictor (+/-1 ", as_i("SD"), ")"',
              'as_i("M"), as_sub("1"), " - ", as_i("M"), as_sub("2")'))
  for(i in seq(nrow(compose.table1))) {
    if(compose.table1[i, "col"] %in% names(dataframe)) {
      table %>%
        format_flex(j = compose.table1[i, "col"],
                    value = compose.table1[i, "value"]) -> table
    }
  }
  compose.table2 <- data.frame(
    col = c("R2", "sr2"),
    value = c('as_i("R"), as_sup("2")', 'as_i("sr"), as_sup("2")'))
  for(i in seq(nrow(compose.table2))) {
    if(compose.table2[i, "col"] %in% names(dataframe)) {
      table %>%
        format_flex(j = compose.table2[i, "col"],
                    value = compose.table2[i, "value"],
                    fun = "format_r") -> table
    }
  }
  if(!missing(highlight)) {
    table %>%
      bold(i = ~ signif == TRUE,
           j = table$col_keys) %>%
      bg(i = ~ signif == TRUE,
         j = table$col_keys,
         bg = "#D9D9D9") -> table
  }

  #   ____________________________________________________________________________
  #   Extra features                                                          ####

  table %>%
    colformat_double(j = (select(dataframe, where(is.numeric)) %>%
                            select(-matches("^p$|^r$|^t$|^SE$|^SD$|^F$|^df$|
                            ^b$|^M$|^N$|^n$|^Z$|^z$|^W$|^R2$|^sr2$",
                                            ignore.case = FALSE)) %>% names),
                     big.mark=",", digits = 2) -> table
  if(!missing(col.format.p)) {
    table %>%
      parse_formatter(column = table$col_keys[col.format.p],
                      fun = "format_p") -> table
  }
  if(!missing(col.format.r)) {
    table %>%
      parse_formatter(column = table$col_keys[col.format.r],
                      fun = "format_r") -> table
  }
  if(!missing(format.custom) & !missing(col.format.custom)) {
    # table %>%
    #   parse_formatter(column = table$col_keys[col.format.custom],
    #                   fun = "format.custom") -> table
    # Error in set_formatter: object 'format.custom' not found
    rExpression <- paste0("table <- table %>% set_formatter(`",
                          table$col_keys[col.format.custom], "` = ",
                          format.custom, ")")
    eval(parse(text = rExpression))
  }
  table
}

#   ____________________________________________________________________________
#   Other functions                                                         ####

format_CI <- function(dataframe, CI_low_high = c("CI_lower", "CI_upper"),
                      col.name = "95% CI") {
  dataframe %>%
    mutate(across(all_of(CI_low_high), function(x) {
      x %>% as.numeric %>% round(2) %>% formatC(2, format="f")
    })) %>%
    mutate(!!col.name := paste0("[", .[[CI_low_high[1]]],
                                ", ", .[[CI_low_high[2]]], "]")) %>%
    select(-all_of(CI_low_high))
}

format_flex <- function(table, j, digits = 2, value, fun) {
  if(missing(value)) {
    table %>%
      italic(j = j, part = "header") %>%
      colformat_double(j = j, big.mark = ",", digits = digits) -> table
  }
  if(!missing(value)) {
    rExpression <- paste0("as_paragraph(", value, ")")
    table %>%
      compose(i = 1, j = j, part = "header",
              value = eval(parse(text = rExpression))) -> table
  }
  if(!missing(fun)) {
    table %>%
      parse_formatter(column = j, fun = fun) -> table
  }
  table
}

parse_formatter <- function(table, call = "table <- table %>% set_formatter",
                            column, fun) {
  rExpression <- paste0(call, "(`", column, "` = ", fun, ")")
  eval(parse(text = rExpression))
}
