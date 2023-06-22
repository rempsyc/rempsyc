test_that("nice_normality", {
  skip_if_not_installed("ggplot2")

  x1 <- nice_normality(
    data = iris,
    variable = "Sepal.Length",
    group = "Species"
  )

  expect_s3_class(
    x1,
    c("gg", "ggplot2")
  )

  ggplot2::ggsave("plot.jpg",
                  width = 7, height = 7, unit = "in",
                  dpi = 300, path = NULL
  )

  expect_snapshot_file("plot.jpg")

  # Remove file
  unlink("plot.jpg")

  # Further customization
  x2 <- nice_normality(
    data = iris,
    variable = "Sepal.Length",
    group = "Species",
    colours = c(
      "#00BA38",
      "#619CFF",
      "#F8766D"
    ),
    groups.labels = c(
      "(a) Setosa",
      "(b) Versicolor",
      "(c) Virginica"
    ),
    grid = FALSE,
    shapiro = TRUE
  )

  expect_s3_class(
    x2,
    c("gg", "ggplot2")
  )

})
