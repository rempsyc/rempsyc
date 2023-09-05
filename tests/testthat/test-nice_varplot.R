test_that("nice_varplot", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("ggrepel")

  set.seed(100)
  x1 <- nice_varplot(
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

  set.seed(100)
  # Further customization
  x2 <- nice_varplot(
    data = iris,
    variable = "Sepal.Length",
    group = "Species",
    colours = c(
      "#00BA38",
      "#619CFF",
      "#F8766D"
    ),
    ytitle = "Sepal Length",
    groups.labels = c(
      "(a) Setosa",
      "(b) Versicolor",
      "(c) Virginica"
    )
  )

  expect_s3_class(
    x2,
    c("gg", "ggplot2")
  )
})
