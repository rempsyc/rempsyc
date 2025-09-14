test_that("grouped_bar_chart", {
  skip_if_not_installed("ggplot2")

  # Create test data
  iris2 <- iris
  iris2$plant <- c(
    rep("yes", 45),
    rep("no", 45),
    rep("maybe", 30),
    rep("NA", 30)
  )

  # Test basic functionality with proportions (default)
  p1 <- grouped_bar_chart(
    data = iris2,
    response = "plant",
    group = "Species"
  )

  expect_s3_class(
    p1,
    c("gg", "ggplot2")
  )

  # Test with counts instead of proportions
  p2 <- grouped_bar_chart(
    data = iris2,
    response = "plant",
    group = "Species",
    proportion = FALSE
  )

  expect_s3_class(
    p2,
    c("gg", "ggplot2")
  )

  # Test with custom label
  p3 <- grouped_bar_chart(
    data = iris2,
    response = "plant",
    group = "Species",
    label = "Plant Response"
  )

  expect_s3_class(
    p3,
    c("gg", "ggplot2")
  )

  # Test with print_table option
  capture.output({
    p4 <- grouped_bar_chart(
      data = iris2,
      response = "plant",
      group = "Species",
      print_table = TRUE
    )
  })

  expect_s3_class(
    p4,
    c("gg", "ggplot2")
  )

  # Test with different group variable
  mtcars_test <- mtcars
  mtcars_test$cyl_factor <- as.factor(mtcars_test$cyl)
  mtcars_test$transmission <- ifelse(mtcars_test$am == 0, "automatic", "manual")

  p5 <- grouped_bar_chart(
    data = mtcars_test,
    response = "transmission",
    group = "cyl_factor"
  )

  expect_s3_class(
    p5,
    c("gg", "ggplot2")
  )

  # Test with custom group parameter
  p6 <- grouped_bar_chart(
    data = iris2,
    response = "plant",
    group = "Species",
    label = "Custom Label"
  )

  expect_s3_class(
    p6,
    c("gg", "ggplot2")
  )

  # Test both proportion and count modes with the same data
  p7_prop <- grouped_bar_chart(
    data = iris2,
    response = "plant",
    group = "Species",
    proportion = TRUE
  )

  p7_count <- grouped_bar_chart(
    data = iris2,
    response = "plant",
    group = "Species",
    proportion = FALSE
  )

  expect_s3_class(
    p7_prop,
    c("gg", "ggplot2")
  )

  expect_s3_class(
    p7_count,
    c("gg", "ggplot2")
  )

  # Test output contains required ggplot components
  expect_true("GeomBar" %in% class(p1$layers[[1]]$geom))
  expect_true("GeomText" %in% class(p1$layers[[2]]$geom))

  # Verify plot data structure
  plot_data <- ggplot2::ggplot_build(p1)$data[[1]]
  expect_true(ncol(plot_data) > 0)
  expect_true(nrow(plot_data) > 0)
})
