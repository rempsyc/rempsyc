test_that("nice_table", {
  skip_if_not_installed("flextable")
  skip_if_not_installed("methods")

  my_table <- nice_table(
    mtcars[1:3, ],
    title = c("Table 1", "Motor Trend Car Road Tests"),
    note = c(
      "The data was extracted from the 1974 Motor Trend US magazine.",
      "* p < .05, ** p < .01, *** p < .001"
    )
  )
  # Test that nice_table returns a proper flextable object (not snapshot due to cross-environment differences)
  expect_s3_class(my_table, "flextable")
  expect_true("col_keys" %in% names(my_table))
  expect_true("header" %in% names(my_table))
  expect_true("body" %in% names(my_table))
  expect_equal(length(my_table$col_keys), 11) # mtcars has 11 columns
  expect_equal(nrow(my_table$body$dataset), 3) # 3 rows of mtcars data

  flextable::save_as_docx(my_table, path = "my_table.docx")

  # expect_snapshot_file("my_table.docx")
  # Not supported

  # Remove file
  unlink("my_table.docx")

  # Publication-ready tables
  mtcars.std <- lapply(mtcars, scale)
  model <- lm(mpg ~ cyl + wt * hp, mtcars.std)
  stats.table <- as.data.frame(summary(model)$coefficients)
  CI <- confint(model)
  stats.table <- cbind(
    row.names(stats.table),
    stats.table, CI
  )
  names(stats.table) <- c(
    "Term", "B", "SE", "t", "p",
    "CI_lower", "CI_upper"
  )
  # Publication-ready tables - test flextable class and properties
  stats_table <- nice_table(stats.table, highlight = TRUE)
  expect_s3_class(stats_table, "flextable")
  expect_true("col_keys" %in% names(stats_table))
  expect_true("95% CI" %in% stats_table$col_keys) # CI formatting creates this column
  expect_equal(nrow(stats_table$body$dataset), 5) # 5 rows in model coefficients

  # Test different column names
  test <- head(mtcars)
  names(test) <- c(
    "dR", "N", "M", "SD", "b", "np2",
    "ges", "p", "r", "R2", "sr2"
  )
  test[, 10:11] <- test[, 10:11] / 10
  test_table <- nice_table(test)
  expect_s3_class(test_table, "flextable")
  expect_equal(length(test_table$col_keys), 11) # 11 columns
  expect_equal(nrow(test_table$body$dataset), 6) # 6 rows (head of mtcars)

  # Custom cell formatting (such as p or r) - test flextable class
  p_format_table <- nice_table(test[8:11], col.format.p = 2:4, highlight = .001)
  expect_s3_class(p_format_table, "flextable")
  expect_equal(length(p_format_table$col_keys), 4) # 4 columns
  expect_equal(nrow(p_format_table$body$dataset), 6) # 6 rows
  
  r_format_table <- nice_table(test[8:11], col.format.r = 1:4)
  expect_s3_class(r_format_table, "flextable")
  expect_equal(length(r_format_table$col_keys), 4) # 4 columns
  expect_equal(nrow(r_format_table$body$dataset), 6) # 6 rows

  # Apply custom functions to cells - test flextable class
  fun <<- function(x) {
    x + 11.1
  }
  custom_table1 <- nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
  expect_s3_class(custom_table1, "flextable")
  expect_equal(length(custom_table1$col_keys), 4) # 4 columns
  
  fun <<- function(x) {
    paste("x", x)
  }
  custom_table2 <- nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun")
  expect_s3_class(custom_table2, "flextable")
  expect_equal(length(custom_table2$col_keys), 4) # 4 columns

  # Separate headers based on periods
  header.data <- structure(
    list(
      Variable = c(
        "Sepal.Length",
        "Sepal.Width", "Petal.Length"
      ), setosa.M = c(
        5.01, 3.43,
        1.46
      ), setosa.SD = c(0.35, 0.38, 0.17), versicolor.M =
        c(5.94, 2.77, 4.26), versicolor.SD = c(0.52, 0.31, 0.47)
    ),
    row.names = c(NA, -3L), class = "data.frame"
  )
  
  # Test that nice_table returns a proper flextable object (not snapshot due to cross-environment differences)
  result_table <- nice_table(header.data,
    separate.header = TRUE,
    italics = 2:4
  )
  expect_s3_class(result_table, "flextable")
  expect_true("col_keys" %in% names(result_table))
  expect_true("header" %in% names(result_table))
  expect_true("body" %in% names(result_table))
  expect_equal(result_table$col_keys, c("Variable", "setosa.M", "setosa.SD", "versicolor.M", "versicolor.SD"))
  expect_equal(nrow(result_table$header$dataset), 2) # separate.header = TRUE creates 2 header rows
  expect_equal(nrow(result_table$body$dataset), 3) # 3 rows of data
})

test_that("nice_table with variable labels", {
  skip_if_not_installed("flextable")
  skip_if_not_installed("methods")
  
  # Create test data with variable labels
  test_data <- head(mtcars[c("mpg", "cyl", "wt")])
  attr(test_data$mpg, "label") <- "Miles per Gallon"
  attr(test_data$cyl, "label") <- "Number of Cylinders"
  attr(test_data$wt, "label") <- "Weight (1000 lbs)"
  
  # Test with use.labels = TRUE
  labeled_table <- nice_table(test_data, use.labels = TRUE)
  expect_s3_class(labeled_table, "flextable")
  expect_equal(labeled_table$col_keys, c("Miles per Gallon", "Number of Cylinders", "Weight (1000 lbs)"))
  expect_equal(nrow(labeled_table$body$dataset), 6) # 6 rows (head of mtcars)
  
  # Test with use.labels = FALSE (default) - should use original names
  unlabeled_table <- nice_table(test_data, use.labels = FALSE)
  expect_s3_class(unlabeled_table, "flextable")
  expect_equal(unlabeled_table$col_keys, c("mpg", "cyl", "wt"))
  expect_equal(nrow(unlabeled_table$body$dataset), 6) # 6 rows (head of mtcars)
  
  # Test with mixed labels (some columns have labels, others don't)
  mixed_data <- head(mtcars[c("mpg", "cyl", "hp")])
  attr(mixed_data$mpg, "label") <- "Miles per Gallon"
  attr(mixed_data$cyl, "label") <- "Number of Cylinders"
  # hp has no label
  
  mixed_table <- nice_table(mixed_data, use.labels = TRUE)
  expect_s3_class(mixed_table, "flextable")
  expect_equal(mixed_table$col_keys, c("Miles per Gallon", "Number of Cylinders", "hp"))
  expect_equal(nrow(mixed_table$body$dataset), 6) # 6 rows (head of mtcars)
  
  # Test with no labels at all
  no_labels_data <- head(mtcars[c("mpg", "cyl", "wt")])
  no_labels_table <- nice_table(no_labels_data, use.labels = TRUE)
  expect_s3_class(no_labels_table, "flextable")
  expect_equal(no_labels_table$col_keys, c("mpg", "cyl", "wt"))
  expect_equal(nrow(no_labels_table$body$dataset), 6) # 6 rows (head of mtcars)
  
  # Test that default behavior is unchanged (use.labels = FALSE by default)
  default_table <- nice_table(test_data)
  expect_s3_class(default_table, "flextable")
  expect_equal(default_table$col_keys, c("mpg", "cyl", "wt"))
  expect_equal(nrow(default_table$body$dataset), 6) # 6 rows (head of mtcars)
})
