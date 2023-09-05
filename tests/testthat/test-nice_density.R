test_that("nice_density", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("ggrepel")

  # Make the basic plot
  x1 <- nice_density(
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

  # expect_snapshot_file("plot.jpg")
  # Not working...

  # Remove file
  unlink("plot.jpg")

  # Further customization
  x2 <- nice_density(
    data = iris,
    variable = "Sepal.Length",
    group = "Species",
    colours = c("#00BA38", "#619CFF", "#F8766D"),
    xtitle = "Sepal Length",
    ytitle = "Density (vs. Normal Distribution)",
    groups.labels = c(
      "(a) Setosa",
      "(b) Versicolor",
      "(c) Virginica"
    ),
    grid = FALSE,
    shapiro = TRUE,
    title = "Density (Sepal Length)",
    histogram = TRUE
  )

  expect_s3_class(
    x2,
    c("gg", "ggplot2")
  )
})
