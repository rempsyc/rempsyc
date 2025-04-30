#' @title Easily make nice APA tables
#'
#' @description Make nice APA tables easily through a wrapper
#' around the `flextable` package with sensical defaults and
#' automatic formatting features.
#'
#' @details The resulting `flextable` objects can be opened in
#' Word with `print(table, preview ="docx")`, or saved to
#' Word with the `flextable::save_as_docx()` function.
#'
#' @param data The data frame, to be converted to a flextable.
#' The data frame cannot have duplicate column names.
#' @param italics Which columns headers should be italic? Useful
#' for column names that should be italic but that are not picked
#' up automatically by the function. Select with numerical range, e.g., 1:3.
#' @param highlight Highlight rows with statistically significant
#' results? Requires a column named "p" containing p-values.
#' Can either accept logical (TRUE/FALSE) OR a numeric value for
#' a custom critical p-value threshold (e.g., 0.10 or 0.001).
#' @param stars Logical. Whether to add asterisks for significant p values.
#' @param col.format.p Applies p-value formatting to columns
#' that cannot be named "p" (for example for a data frame full
#' of p-values, also because it is not possible to have more
#' than one column named "p"). Select with numerical range, e.g., 1:3.
#' @param col.format.r Applies r-value formatting to columns
#' that cannot be named "r" (for example for a data frame full
#' of r-values, also because it is not possible to have more
#' than one column named "r"). Select with numerical range, e.g., 1:3.
#' @param col.format.ci Applies 95% confidence interval formatting
#' to selected columns (e.g., when reporting more than one interval).
#' @param format.custom Applies custom formatting to columns
#' selected via the `col.format.custom` argument. This is useful
#' if one wants custom formatting other than for p- or r-values.
#' It can also be used to transform (e.g., multiply) certain values
#' or print a specific symbol along the values for instance.
#' @param col.format.custom Which columns to apply the custom
#' function to. Select with numerical range, e.g., 1:3.
#' @param width Width of the table, in percentage of the
#' total width, when exported e.g., to Word. For full width,
#' use `width = 1`.
#' @param spacing Spacing of the rows (1 = single space, 2 = double space)
#' @param broom If providing a tidy table produced with the
#' `broom` package, which model type to use if one wants
#' automatic formatting (options are "t.test", "lm", "cor.test",
#' and "wilcox.test").
#' @param report If providing an object produced with the
#' `report` package, which model type to use if one wants
#' automatic formatting (options are "t.test", "lm", and "cor.test").
#' @param short Logical. Whether to return an abbreviated
#' version of the tables made by the `report` package.
#' @param title Optional, to add a table header, if desired.
#' @param note Optional, to add one or more table footnote (APA note),
#' if desired.
#' @param separate.header Logical, whether to separate headers based
#' on name delimiters (i.e., periods ".").
#'
#' @keywords APA style table
#' @return An APA-formatted table of class "flextable"
#' @examplesIf requireNamespace("flextable", quietly = TRUE) && requireNamespace("methods", quietly = TRUE)
#' # Make the basic table
#' my_table <- nice_table(
#'   mtcars[1:3, ],
#'   title = c("Table 1", "Motor Trend Car Road Tests"),
#'   note = c(
#'     "The data was extracted from the 1974 Motor Trend US magazine.",
#'     "* p < .05, ** p < .01, *** p < .001"
#'   )
#' )
#' my_table
#'
#' \donttest{
#' # Save table to word
#' mypath <- tempfile(fileext = ".docx")
#' flextable::save_as_docx(my_table, path = mypath)
#' }
#'
#' # Publication-ready tables
#' mtcars.std <- lapply(mtcars, scale)
#' model <- lm(mpg ~ cyl + wt * hp, mtcars.std)
#' stats.table <- as.data.frame(summary(model)$coefficients)
#' CI <- confint(model)
#' stats.table <- cbind(
#'   row.names(stats.table),
#'   stats.table, CI
#' )
#' names(stats.table) <- c(
#'   "Term", "B", "SE", "t", "p",
#'   "CI_lower", "CI_upper"
#' )
#' nice_table(stats.table, highlight = TRUE)
#'
#' # Test different column names
#' test <- head(mtcars)
#' names(test) <- c(
#'   "dR", "N", "M", "SD", "b", "np2",
#'   "ges", "p", "r", "R2", "sr2"
#' )
#' test[, 10:11] <- test[, 10:11] / 10
#' nice_table(test)
#'
#' # Custom cell formatting (such as p or r)
#' nice_table(test[8:11], col.format.p = 2:4, highlight = .001)
#'
#' nice_table(test[8:11], col.format.r = 1:4)
#'
#' # Apply custom functions to cells
#' fun <- function(x) {
#'   x + 11.1
#' }
#' nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
#'
#' fun <- function(x) {
#'   paste("x", x)
#' }
#' nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
#'
#' # Separate headers based on periods
#' header.data <- structure(
#'   list(
#'     Variable = c(
#'       "Sepal.Length",
#'       "Sepal.Width", "Petal.Length"
#'     ), setosa.M = c(
#'       5.01, 3.43,
#'       1.46
#'     ), setosa.SD = c(0.35, 0.38, 0.17), versicolor.M =
#'       c(5.94, 2.77, 4.26), versicolor.SD = c(0.52, 0.31, 0.47)
#'   ),
#'   row.names = c(NA, -3L), class = "data.frame"
#' )
#' nice_table(header.data,
#'   separate.header = TRUE,
#'   italics = 2:4
#' )
#'
#' @importFrom dplyr mutate %>% select matches
#' case_when relocate across contains select_if any_of
#' last_col
#' @importFrom rlang :=
#'
#' @seealso
#' Tutorial: \url{https://rempsyc.remi-theriault.com/articles/table}
#'

#' @export
nice_table <- function(data,
                       highlight = FALSE,
                       stars = TRUE,
                       italics,
                       col.format.p,
                       col.format.r,
                       col.format.ci,
                       format.custom,
                       col.format.custom,
                       width = NULL,
                       spacing = 2,
                       broom = NULL,
                       report = NULL,
                       short = FALSE,
                       title,
                       note,
                       separate.header) {
  rlang::check_installed(c("flextable", "methods"),
    version = c(get_dep_version("flextable"), NA),
    reason = "for this function."
  )

  if (!inherits(data, "data.frame")) {
    message("Non-dataframe detected. Attempting to coerce to dataframe")
  }

  dataframe <- as.data.frame(data)

  format_p_internal <- ifelse(isTRUE(stars), "format_p_stars", "format_p")

  #   _______________________________________
  #   Replace possible alternative names ####
  dataframe <- dataframe %>%
    rename_with(
      ~ case_when(
        . == "p.value" ~ "p",
        . == "pvalue" ~ "p",
        . == "chisq" ~ "chi2",
        . == "conf.low" ~ "CI_lower",
        . == "conf.high" ~ "CI_upper",
        . == "CI_low" ~ "CI_lower",
        . == "CI_high" ~ "CI_upper",
        . == "df_error" ~ "df",
        . == "Cohens_d" ~ "d",
        . == "Coefficient" ~ "b",
        . == "t.ratio" ~ "t",
        . == "Std_Coefficient" ~ "B",
        . == "r_rank_biserial" ~ "rrb",
        . == "Eta2" ~ "n2",
        . == "Eta2_partial" ~ "np2",
        . == "mu" ~ "Mu",
        . == "term" ~ "Term",
        . == "method" ~ "Method",
        . == "alternative" ~ "Alternative",
        TRUE ~ .
      )
    )

  #   __________________________________
  #   Broom integration            ####

  dataframe <- prepare_broom(dataframe, broom)

  #   __________________________________
  #   Report integration           ####

  dataframe <- prepare_report(dataframe, report, short)

  #   _________________________________
  #   Formatting                   ####

  if (!missing(separate.header)) {
    filtered.names <- grep("[.]", names(dataframe), value = TRUE)
    sh.pattern <- lapply(filtered.names, function(x) {
      gsub("[^\\.]*$", "", x)
    }) %>%
      unlist() %>%
      unique()
    unique.pattern <- length(sh.pattern)
  }

  dataframe <- prepare_flextable(
    dataframe, separate.header, col.format.ci, highlight,
    sh.pattern, unique.pattern
  )

  #   __________________________________
  #   Flextable                     ####

  nice.borders <- list("width" = 0.5, color = "black", style = "solid")

  table <- create_flextable(
    dataframe, highlight, width, spacing, note,
    separate.header, nice.borders
  )

  #   ___________________________________
  #   Column formatting              ####

  table <- format_columns(
    dataframe, table, italics, separate.header,
    highlight, sh.pattern, unique.pattern,
    format_p_internal
  )

  #   _____________________________________________
  #   Extra features                           ####

  table <- beautify_flextable(
    dataframe, table, separate.header, col.format.p, col.format.r,
    format.custom, col.format.custom, sh.pattern, unique.pattern,
    format_p_internal
  )

  #   ___________________________
  #   Final touch up (title) ####

  table <- finalize_table(table, title, nice.borders)

  # class(table) <- c("nice_table", class(table))
  # remove `nice_table` class because of name collision with printing method
  # of the `afex` package for `nice_table` objects

  table
}

#   ____________________________________________________________________________
#   Other functions                                                         ####

# format_CI
format_CI <- function(dataframe, CI_low_high = c("CI_lower", "CI_upper"),
                      col.name = "95% CI") {
  dataframe %>%
    mutate(across(all_of(CI_low_high), function(x) {
      x %>%
        as.numeric() %>%
        round(2) %>%
        formatC(2, format = "f")
    })) %>%
    mutate(!!col.name := paste0(
      "[", .[[CI_low_high[1]]],
      ", ", .[[CI_low_high[2]]], "]"
    )) %>%
    select(-all_of(CI_low_high))
}

# format_flex
format_flex <- function(table, j, digits = 2, value, fun) {
  if (missing(value)) {
    table <- table %>%
      flextable::italic(j = j, part = "header") %>%
      flextable::colformat_double(j = j, big.mark = ",", digits = digits)
  } else {
    rExpression <- paste0("flextable::as_paragraph(", value, ")")
    table <- table %>%
      flextable::compose(
        i = NULL, j = j, part = "header",
        value = eval(parse(text = rExpression))
      )
  }
  if (!missing(fun)) {
    table <- table %>%
      parse_formatter(column = j, fun = fun)
  }
  table
}

# parse_formatter
parse_formatter <- function(
    table,
    call = "table <- table %>% flextable::set_formatter",
    column, fun) {
  rExpression <- paste0(call, "(`", column, "` = ", fun, ")")
  eval(parse(text = rExpression))
}

# prepare_broom
prepare_broom <- function(dataframe, broom) {
  if (!is.null(broom)) {
    dataframe <- dataframe %>%
      rename_with(
        ~ case_when(
          . == "statistic" ~ "t",
          . == "std.error" ~ "SE",
          . == "parameter" ~ "df",
          TRUE ~ .
        )
      )
    if (broom == "t.test") {
      dataframe <- dataframe %>%
        relocate(estimate, .after = estimate2) %>%
        rename_with(
          ~ case_when(
            . == "estimate" ~ "M1 - M2",
            . == "estimate1" ~ "Mean 1",
            . == "estimate2" ~ "Mean 2",
            TRUE ~ .
          )
        ) %>%
        relocate(df, .before = p) %>%
        relocate(Method:Alternative)
    } else if (broom == "lm") {
      dataframe <- dataframe %>%
        rename_with(
          ~ case_when(
            . == "estimate" ~ "b",
            TRUE ~ .
          )
        )
    } else if (broom == "cor.test") {
      dataframe <- dataframe %>%
        rename_with(
          ~ case_when(
            . == "estimate" ~ "r",
            TRUE ~ .
          )
        ) %>%
        relocate(df, .before = p) %>%
        relocate(Method:Alternative, .before = r)
    } else if (broom == "wilcox.test") {
      dataframe <- dataframe %>%
        rename_with(
          ~ case_when(
            . == "t" ~ "W",
            TRUE ~ .
          )
        ) %>%
        relocate(Method:Alternative, .before = W)
    }
  }
  dataframe
}

# prepare_report
prepare_report <- function(dataframe, report, short) {
  if (!is.null(report) || any(class(dataframe) == "report_table")) {
    # t.test, aov, and wilcox need to be done separately
    # because they have no model_class attribute
    if ("Method" %in% names(dataframe)) {
      if (all(grepl("t-test", dataframe$Method))) {
        report <- "t.test"
      } else if (all(grepl("Wilcox", dataframe$Method))) {
        report <- "wilcox"
      }
    } else if ("Sum_Squares" %in% names(dataframe)) {
      report <- "aov"
    } else if (length(attr(dataframe, "model_class")) > 0) {
      if ("lm" %in% attr(dataframe, "model_class")) {
        report <- "lm"
      } else if (grepl("correlation", attr(dataframe, "title"))) {
        report <- "cor.test"
      }
    }
    dataframe <- dataframe %>%
      relocate(any_of(c("method", "alternative"))) %>%
      select(-any_of("CI"))
    if (report == "t.test") {
      dataframe <- dataframe %>%
        format_CI(col.name = "95% CI (t)") %>%
        relocate(`95% CI (t)`, .after = t)

      dataframe <- dataframe %>%
        format_CI(c("d_CI_low", "d_CI_high"),
          col.name = "95% CI (d)"
        )
      if (short == TRUE) {
        dataframe <- dataframe %>%
          select_if(!names(.) %in% c(
            "method", "alternative", "Mean_Group1",
            "Mean_Group2", "Difference", "95% CI (t)"
          ))
      }
    } else if (report == "lm") {
      dataframe <- dataframe %>%
        relocate(Fit, .after = Parameter)
      dataframe <- dataframe %>%
        format_CI(col.name = "95% CI (b)") %>%
        relocate(`95% CI (b)`, .after = b)

      dataframe <- dataframe %>%
        format_CI(c("Std_Coefficient_CI_low", "Std_Coefficient_CI_high"),
          col.name = "95% CI (B)"
        )
      if (short == TRUE) {
        dataframe <- select(dataframe, -c("Fit", "95% CI (b)"))
        dataframe <- dataframe[-(
          which(is.na(dataframe$Parameter))[1]:nrow(dataframe)), ]
      }
    } else if (report == "aov") {
      if ("Eta2_CI_low" %in% names(dataframe)) {
        dataframe <- dataframe %>%
          format_CI(c("Eta2_CI_low", "Eta2_CI_high"),
            col.name = "95% CI (n2)"
          )
      }
      if ("Eta2_partial_CI_low" %in% names(dataframe)) {
        dataframe <- dataframe %>%
          format_CI(c("Eta2_partial_CI_low", "Eta2_partial_CI_high"),
            col.name = "95% CI (np2)"
          )
      }
    } else if (report == "wilcox") {
      dataframe <- dataframe %>%
        format_CI(c("rank_biserial_CI_low", "rank_biserial_CI_high"),
          col.name = "95% CI (rrb)"
        )
    }
  }
  if (all(c("Cohens_d_CI_low", "Cohens_d_CI_high") %in% names(dataframe))) {
    dataframe <- dataframe %>%
      format_CI(c("Cohens_d_CI_low", "Cohens_d_CI_high"),
                col.name = "95% CI (d)"
      )
  }
  dataframe
}

# prepare_flextable
prepare_flextable <- function(dataframe, separate.header, col.format.ci,
                              highlight, sh.pattern, unique.pattern) {
  if (!missing(col.format.ci)) {
    if (!methods::is(col.format.ci, "list")) {
      col.format.ci <- list(col.format.ci)
    }
    for (i in col.format.ci) {
      ci.name <- paste0(sh.pattern[i], "95% CI")
      dataframe <- format_CI(
        dataframe, i,
        col.name =
          ci.name
      ) %>%
        relocate(all_of(ci.name), .after = select(
          ., contains(sh.pattern), -last_col()
        ) %>%
          select(last_col()) %>% names())
    }
  }
  if ("CI_lower" %in% names(dataframe) && "CI_upper" %in% names(dataframe)) {
    dataframe <- format_CI(dataframe)
  }
  if ("CI_lower_B" %in% names(dataframe) && "CI_upper_B" %in% names(dataframe)) {
    dataframe <- dataframe %>%
      rename("95% CI (b)" = "95% CI") %>%
      relocate("B", .after = last_col()) %>%
      format_CI(c("CI_lower_B", "CI_upper_B"),
        col.name = "95% CI (B)"
      )
  }
  if ("CI_lower_r" %in% names(dataframe) && "CI_upper_r" %in% names(dataframe)) {
    dataframe <- dataframe %>%
      rename("95% CI (sigma)" = "95% CI") %>%
      relocate("r", .after = last_col()) %>%
      format_CI(c("CI_lower_r", "CI_upper_r"),
        col.name = "95% CI (r)"
      )
  }
  if ("rmsea.ci.lower" %in% names(dataframe) && "rmsea.ci.upper" %in% names(dataframe)) {
    dataframe <- format_CI(dataframe, c(
      "rmsea.ci.lower", "rmsea.ci.upper"
    ), "90% CI (RMSEA)")
    if ("rmsea" %in% names(dataframe)) {
      relocate(dataframe, "90% CI (RMSEA)", .after = "rmsea")
    }
  }
  if (!missing(separate.header)) {
    CI_lower.sh <- paste0(sh.pattern, rep(
      "CI_lower",
      each = unique.pattern
    ))
    CI_upper.sh <- paste0(sh.pattern, rep(
      "CI_upper",
      each = unique.pattern
    ))
    CI.df <- data.frame(CI_lower.sh, CI_upper.sh)
    names(CI.df) <- NULL
    if (any(unlist(CI.df) %in% names(dataframe))) {
      for (i in seq(nrow(CI.df))) {
        ci.name <- paste0(sh.pattern[i], "95% CI")
        dataframe <- format_CI(
          dataframe,
          CI_low_high = unlist(CI.df[i, ]),
          col.name = ci.name
        ) %>%
          relocate(all_of(ci.name), .after = select(
            ., contains(sh.pattern[i]), -last_col()
          ) %>%
            select(last_col()) %>% names())
      }
    }
  }
  dataframe <- dataframe %>%
    mutate(across(contains("95% CI"), ~ ifelse(
      .x == "[ NA,  NA]", "", .x
    )))

  if ("p" %in% names(dataframe) && isTRUE(highlight) ||
    is.numeric(highlight)) {
    highlight <- ifelse(isTRUE(highlight), .05, highlight)
    dataframe <- dataframe %>%
      mutate(signif = ifelse(p < highlight, TRUE, FALSE))
  }
  if ("Predictor" %in% names(dataframe)) {
    dataframe$Predictor <- gsub(
      ":", " \u00D7 ", dataframe$Predictor
    )
  }
  if ("Term" %in% names(dataframe)) {
    dataframe$Term <- gsub(
      ":", " \u00D7 ", dataframe$Term
    )
  }
  if ("Model Number" %in% names(dataframe)) {
    dataframe <- dataframe %>%
      select(-all_of("Model Number"))
  }
  # Capitals
  cols.capitals <- c(
    "cfi", "tli", "nnfi", "rfi", "nfi", "pnfi", "ifi",
    "rni", "logl", "aic", "bic", "bic2", "rmsea", "rmr",
    "srmr", "crmr", "gfi", "agfi", "pgfi", "mfi", "ecvi"
  )
  dataframe <- dataframe %>%
    rename_with(.fn = toupper, .cols = any_of(cols.capitals))
  dataframe
}

# create_flextable
create_flextable <- function(dataframe, highlight, width, spacing, note,
                             separate.header, nice.borders) {
  table <- dataframe %>%
    {
      if ("p" %in% names(dataframe) && highlight == TRUE ||
        is.numeric(highlight)) {
        flextable::flextable(., col_keys = names(dataframe)[-length(dataframe)])
      } else {
        flextable::flextable(.)
      }
    }

  # Merge cells for repeated dependent variables...
  if ("Dependent Variable" %in% names(dataframe) &&
    any(duplicated(dataframe$`Dependent Variable`))) {
    model.row <- which(!duplicated(dataframe$`Dependent Variable`,
      fromLast = TRUE
    ))
    table <- table %>%
      flextable::merge_v(j = "Dependent Variable") %>%
      flextable::hline(i = model.row, border = nice.borders)
  }

  table <- table %>%
    flextable::hline_top(part = "head", border = nice.borders) %>%
    flextable::hline_bottom(part = "head", border = nice.borders) %>%
    flextable::hline_top(part = "body", border = nice.borders) %>%
    flextable::hline_bottom(part = "body", border = nice.borders) %>%
    flextable::align(align = "center", part = "all") %>%
    flextable::align(j = 1, align = "left", part = "body") %>%
    flextable::valign(valign = "center", part = "all") %>%
    flextable::line_spacing(space = spacing, part = "all") %>%
    flextable::fix_border_issues()

  if (!is.null(width)) {
    table <- table %>%
      flextable::set_table_properties(layout = "autofit", width = width)
  } else {
    table <- table %>%
      flextable::set_table_properties(layout = "autofit")
  }

  if (!missing(note)) {
    note.list <- as.list(note)
    table <- table %>%
      flextable::add_footer_lines("") %>%
      flextable::compose(i = 1, j = 1, value = flextable::as_paragraph(
        flextable::as_i("Note. "), note[[1]]
      ), part = "footer") %>%
      flextable::align(part = "footer", align = "left")
    if (length(note.list) > 1) {
      table <- table %>%
        flextable::add_footer_lines(note.list[-1])
    }
  }

  # Separate headers
  if (!missing(separate.header)) {
    table <- table %>%
      flextable::separate_header("span-top", split = "[.]")
  }

  table <- table %>%
    flextable::fontsize(part = "all", size = 12) %>%
    flextable::font(part = "all", fontname = "Times New Roman")
  table
}

format_columns <- function(dataframe, table, italics, separate.header,
                           highlight, sh.pattern, unique.pattern,
                           format_p_internal) {
  ##  ....................................
  ##  Special cases                  ####
  # Fix header with italics
  if (!missing(italics) & missing(separate.header)) {
    table <- table %>%
      flextable::italic(j = italics, part = "header")
  } else if (!missing(italics) & !missing(separate.header)) {
    level.number <- sum(charToRaw(names(
      dataframe[2]
    )) == charToRaw(".")) + 1
    table <- table %>%
      flextable::italic(j = italics, i = level.number, part = "header")
  }

  # Degrees of freedom
  cols.df <- "df"
  if (!missing(separate.header)) {
    cols.df.sh <- paste0(sh.pattern, rep(
      cols.df,
      each = unique.pattern
    ))
    cols.df <- c(cols.df, cols.df.sh)
  }

  for (i in cols.df) {
    if (i %in% names(dataframe)) {
      df.digits <- ifelse(any(dataframe[i] %% 1 == 0), 0, 2)
      table <- table %>%
        format_flex(j = i, digits = df.digits)
    }
  }

  ##  .....................................
  ##  2-digit columns                 ####

  # Italicize all these column names
  cols.2digits <- c("t", "SE", "SD", "F", "b", "M", "W", "d", "g", "Mu", "S", "z", "Z")
  if (!missing(separate.header)) {
    cols.2digits.sh <- paste0(sh.pattern, rep(
      cols.2digits,
      each = unique.pattern
    ))
    cols.2digits <- c(cols.2digits, cols.2digits.sh)
  }

  for (i in cols.2digits) {
    if (i %in% names(dataframe)) {
      table <- table %>%
        format_flex(j = i)
    }
  }

  ##  .....................................
  ##  0-digit columns                 ####
  cols.0digits <- c("N", "n")
  if (!missing(separate.header)) {
    cols.0digits.sh <- paste0(sh.pattern, rep(
      cols.0digits,
      each = unique.pattern
    ))
    cols.0digits <- c(cols.0digits, cols.0digits.sh)
  }

  for (i in cols.0digits) {
    if (i %in% names(dataframe)) {
      table <- table %>%
        format_flex(j = i, digits = 0)
    }
  }

  ##  .....................................
  ##  Formatting functions            ####
  compose.table0 <- data.frame(
    col = c("p", "r"),
    fun = c(format_p_internal, "format_r")
  )

  if (!missing(separate.header)) {
    cols.sh <- paste0(sh.pattern, rep(
      compose.table0$col,
      each = unique.pattern
    ))
    table0.sh <- data.frame(
      col = cols.sh,
      fun = rep(compose.table0$fun,
        each =
          length(cols.sh) / length(compose.table0$fun)
      )
    )
    compose.table0 <- rbind(compose.table0, table0.sh)
  }

  for (i in seq(nrow(compose.table0))) {
    if (compose.table0[i, "col"] %in% names(dataframe)) {
      table <- table %>%
        format_flex(
          j = compose.table0[i, "col"],
          fun = compose.table0[i, "fun"]
        )
    }
  }

  ##  .....................................
  ##  Special symbols                 ####
  compose.table1 <- data.frame(
    col = c(
      "95% CI (b)", "95% CI (B)", "95% CI (t)", "95% CI (d)",
      "95% CI (np2)", "95% CI (n2)", "95% CI (rrb)",
      "95% CI (sigma)", "95% CI (sigma2)", "95% CI (r)", "np2",
      "n2", "ges", "dR", "Predictor (+/-1 SD)", "M1 - M2", "tau",
      "rho", "rrb", "chi2", "chi2.df", "B", "sigma", "sigma2"
    ),
    value = c(
      '"95% CI (", flextable::as_i("b"), ")"', # small b
      '"95% CI (", flextable::as_i("b"), "*", ")"', # beta
      '"95% CI (", flextable::as_i("t"), ")"', # t
      '"95% CI (", flextable::as_i("d"), ")"', # d
      '"95% CI (", "\u03b7", flextable::as_sub("p"), flextable::as_sup("2"), ")"', # peta
      '"95% CI (", "\u03b7", flextable::as_sup("2"), ")"', # eta
      '"95% CI (", flextable::as_i("r"), flextable::as_i(flextable::as_sub("rb")), ")"', # rrb
      '"95% CI (", "\u03C3", ")"', # sigma
      '"95% CI (", "\u03C3", flextable::as_sup("2"), ")"', # sigma2
      '"95% CI (", flextable::as_i("r"), ")"', # r
      '"\u03b7", flextable::as_sub("p"), flextable::as_sup("2")', # eta
      '"\u03b7", flextable::as_sup("2")', # eta
      '"\u03b7", flextable::as_sub("G"), flextable::as_sup("2")', # eta
      'flextable::as_i("d"), flextable::as_sub("R")',
      '"Predictor (+/-1 ", flextable::as_i("SD"), ")"',
      'flextable::as_i("M"), flextable::as_sub("1"), " - ", flextable::as_i("M"), flextable::as_sub("2")',
      '"\u03C4"', # tau
      '"\u03C1"', # rho
      'flextable::as_i("r"), flextable::as_i(flextable::as_sub("rb"))',
      '"\u03C7", flextable::as_sup("2")', # Chi square
      '"\u03C7", flextable::as_sup("2"), "\u2215", flextable::as_i("df")', # Chi square
      'flextable::as_i("b"), "*"', # beta
      '"\u03C3"', # sigma
      '"\u03C3", flextable::as_sup("2")' # sigma
    )
  )
  for (i in seq(nrow(compose.table1))) {
    if (compose.table1[i, "col"] %in% names(dataframe)) {
      table <- table %>%
        format_flex(
          j = compose.table1[i, "col"],
          value = compose.table1[i, "value"]
        )
    }
  }
  # Values that can't be greater than 1, but not just italic formatting like r
  compose.table2 <- data.frame(
    col = c("R2", "sr2", "CFI", "TLI", "RMSEA", "SRMR"),
    value = c(
      'flextable::as_i("R"), flextable::as_sup("2")',
      'flextable::as_i("sr"), flextable::as_sup("2")',
      "CFI", "TLI", "RMSEA", "SRMR"
    )
  )

  if (!missing(separate.header)) {
    cols.sh <- paste0(sh.pattern, rep(
      compose.table2$col,
      each = unique.pattern
    ))
    table2.sh <- data.frame(
      col = cols.sh,
      value = rep(compose.table2$value,
        each =
          length(cols.sh) / length(compose.table2$value)
      )
    )
    compose.table2 <- rbind(compose.table2, table2.sh)
  }

  for (i in seq(nrow(compose.table2))) {
    if (compose.table2[i, "col"] %in% names(dataframe)) {
      table <- table %>%
        format_flex(
          j = compose.table2[i, "col"],
          value = compose.table2[i, "value"],
          fun = "format_r"
        )
    }
  }

  if ("p" %in% names(dataframe) && isTRUE(highlight) ||
    is.numeric(highlight)) {
    table <- table %>%
      flextable::bold(
        i = ~ signif == TRUE,
        j = table$col_keys
      ) %>%
      flextable::bg(
        i = ~ signif == TRUE,
        j = table$col_keys,
        bg = "#D9D9D9"
      )
  }

  # Set attributes for variables which digits should not be changed for later step
  attr(table, "dont_change") <- c(
    compose.table0$col, cols.df, cols.2digits, cols.0digits, compose.table2$col
  )
  table
}

beautify_flextable <- function(
    dataframe, table, separate.header, col.format.p, col.format.r,
    format.custom, col.format.custom, sh.pattern, unique.pattern,
    format_p_internal) {
  dont.change0 <- attr(table, "dont_change")
  dont.change <- paste0("^", dont.change0, "$", collapse = "|")

  if (!missing(separate.header)) {
    dont.change.sh <- paste0(sh.pattern, rep(
      dont.change0,
      each = unique.pattern
    ))
    dont.change.sh <- paste0("^", dont.change.sh, "$", collapse = "|")
    dont.change <- paste0(dont.change, "|", dont.change.sh)
  }

  table <- table %>%
    flextable::colformat_double(
      j = (select(dataframe, where(is.numeric)) %>%
        select(-matches(dont.change,
          ignore.case = FALSE
        )) %>% names()),
      big.mark = ",", digits = 2
    )
  if (!missing(col.format.p)) {
    table <- table %>%
      parse_formatter(
        column = table$col_keys[col.format.p],
        fun = format_p_internal
      )
  }
  if (!missing(col.format.r)) {
    table <- table %>%
      parse_formatter(
        column = table$col_keys[col.format.r],
        fun = "format_r"
      )
  }
  if (!missing(format.custom) & !missing(col.format.custom)) {
    # table %>%
    #   parse_formatter(column = table$col_keys[col.format.custom],
    #                   fun = "format.custom") -> table
    # Error in set_formatter: object 'format.custom' not found
    rExpression <- paste0(
      "table <- table %>% flextable::set_formatter(`",
      table$col_keys[col.format.custom], "` = ",
      format.custom, ")"
    )
    eval(parse(text = rExpression))
  }
  table
}

finalize_table <- function(table, title, nice.borders) {
  if (!missing(title)) {
    invisible.borders <- flextable::fp_border_default("width" = 0)
    italic.lvl <- ifelse(length(title) == 1, 1, 2)
    bold.decision <- ifelse(length(title) == 1, FALSE, TRUE)

    table <- table %>%
      flextable::add_header_lines(values = title) %>%
      flextable::align(
        part = "header", i = seq(length(title)),
        align = "left"
      ) %>%
      flextable::hline(
        part = "header", i = seq_len(length(title) - 1),
        border = invisible.borders
      ) %>%
      flextable::hline(
        part = "header", i = length(title),
        border = nice.borders
      ) %>%
      flextable::hline_top(border = invisible.borders, part = "header") %>%
      # flextable::border(part = "header", i = 1:length(title),
      #        border = invisible.borders) %>%
      flextable::italic(part = "header", i = italic.lvl) %>%
      flextable::bold(., part = "header", i = 1, bold = bold.decision)
  }
  table
}
