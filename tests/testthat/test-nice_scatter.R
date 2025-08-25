test_that("nice_scatter", {
  skip_if_not_installed("ggplot2")

  # Make the basic plot
  x1 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg"
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

  # Change x- and y- axis labels
  x2 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    ytitle = "Miles/(US) gallon",
    xtitle = "Weight (1000 lbs)"
  )

  expect_s3_class(
    x2,
    c("gg", "ggplot2")
  )

  # Have points "jittered", loess method
  x3 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    has.jitter = TRUE,
    method = "loess"
  )

  expect_s3_class(
    x3,
    c("gg", "ggplot2")
  )

  # Change the transparency of the points
  x4 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    alpha = 1
  )

  expect_s3_class(
    x4,
    c("gg", "ggplot2")
  )

  # Remove points
  x5 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    has.points = FALSE,
    has.jitter = FALSE
  )

  expect_s3_class(
    x5,
    c("gg", "ggplot2")
  )

  # Add confidence band
  x6 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    has.confband = TRUE
  )

  expect_s3_class(
    x6,
    c("gg", "ggplot2")
  )

  # Set x- and y- scales manually
  x7 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    xmin = 1,
    xmax = 6,
    xby = 1,
    ymin = 10,
    ymax = 35,
    yby = 5
  )

  expect_s3_class(
    x7,
    c("gg", "ggplot2")
  )

  # Change plot colour
  x8 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    colours = "blueviolet"
  )

  expect_s3_class(
    x8,
    c("gg", "ggplot2")
  )

  # Add correlation coefficient to plot and p-value
  x9 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    has.r = TRUE,
    has.p = TRUE
  )

  expect_s3_class(
    x9,
    c("gg", "ggplot2")
  )

  # Change location of correlation coefficient or p-value
  x10 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    has.r = TRUE,
    r.x = 4,
    r.y = 25,
    has.p = TRUE,
    p.x = 5,
    p.y = 20
  )

  expect_s3_class(
    x10,
    c("gg", "ggplot2")
  )

  # Plot by group
  x11 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    group = "cyl"
  )

  expect_s3_class(
    x11,
    c("gg", "ggplot2")
  )

  # Use full range on the slope/confidence band
  x12 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    group = "cyl",
    has.fullrange = TRUE
  )

  expect_s3_class(
    x12,
    c("gg", "ggplot2")
  )

  # Remove lines
  x13 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    group = "cyl",
    has.line = FALSE
  )

  expect_s3_class(
    x13,
    c("gg", "ggplot2")
  )

  # Change order of labels on the legend
  x14 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    group = "cyl",
    groups.order = c(8, 4, 6)
  )

  expect_s3_class(
    x14,
    c("gg", "ggplot2")
  )

  # Change legend labels
  x15 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    group = "cyl",
    groups.labels = c("Weak", "Average", "Powerful")
  )
  # Warning: This applies after changing order of level

  expect_s3_class(
    x15,
    c("gg", "ggplot2")
  )

  # Add a title to legend
  x16 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    group = "cyl",
    legend.title = "cylinders"
  )

  expect_s3_class(
    x16,
    c("gg", "ggplot2")
  )

  # Plot by group + manually specify colours
  x17 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    group = "cyl",
    colours = c("burlywood", "darkgoldenrod", "chocolate")
  )

  expect_s3_class(
    x17,
    c("gg", "ggplot2")
  )

  # Plot by group + use different line types for each group
  x18 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    group = "cyl",
    has.linetype = TRUE
  )

  expect_s3_class(
    x18,
    c("gg", "ggplot2")
  )

  # Plot by group + use different point shapes for each group
  x19 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    group = "cyl",
    has.shape = TRUE
  )

  expect_s3_class(
    x19,
    c("gg", "ggplot2")
  )

  # Test ID display functionality
  x20 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    has.ids = TRUE
  )

  expect_s3_class(
    x20,
    c("gg", "ggplot2")
  )

  # Test group correlations
  x21 <- nice_scatter(
    data = mtcars,
    predictor = "wt",
    response = "mpg",
    group = "cyl",
    has.group.r = TRUE,
    has.group.p = TRUE
  )

  expect_s3_class(
    x21,
    c("gg", "ggplot2")
  )

  # Test with custom ID column (using car names)
  mtcars_with_names <- mtcars
  mtcars_with_names$car_name <- rownames(mtcars)
  
  x22 <- nice_scatter(
    data = mtcars_with_names,
    predictor = "wt",
    response = "mpg",
    has.ids = TRUE,
    id.column = "car_name"
  )

  expect_s3_class(
    x22,
    c("gg", "ggplot2")
  )
})
