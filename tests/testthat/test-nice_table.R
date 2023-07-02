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
  expect_snapshot(my_table)

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
  expect_snapshot(nice_table(stats.table, highlight = TRUE))

  # Test different column names
  test <- head(mtcars)
  names(test) <- c(
    "dR", "N", "M", "SD", "b", "np2",
    "ges", "p", "r", "R2", "sr2"
  )
  test[, 10:11] <- test[, 10:11] / 10
  expect_snapshot(nice_table(test))

  # Custom cell formatting (such as p or r)
  expect_snapshot(nice_table(test[8:11], col.format.p = 2:4, highlight = .001))

  expect_snapshot(nice_table(test[8:11], col.format.r = 1:4))

  # Apply custom functions to cells
  fun <<- function(x) {
    x + 11.1
  }
  expect_snapshot(nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun"))

  fun <<- function(x) {
    paste("x", x)
  }
  expect_snapshot(nice_table(test[8:11], col.format.custom = 2:4, format.custom = "fun"))

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
  expect_snapshot(nice_table(header.data,
             separate.header = TRUE,
             italics = 2:4
  ))

})
