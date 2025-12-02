test_that("plot_means_over_time", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("tidyr")
  skip_if_not_installed("Rmisc")

  # Create test data with time series variables
  data <- mtcars
  names(data)[6:3] <- paste0("T", 1:4, "_var")

  # Test basic functionality
  p1 <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl"
  )

  expect_s3_class(
    p1,
    c("gg", "ggplot2")
  )

  # Test with groups.order = "decreasing"
  p2 <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    groups.order = "decreasing"
  )

  expect_s3_class(
    p2,
    c("gg", "ggplot2")
  )

  # Test with groups.order = "increasing"
  p3 <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    groups.order = "increasing"
  )

  expect_s3_class(
    p3,
    c("gg", "ggplot2")
  )

  # Test with groups.order = "string.length"
  p4 <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    groups.order = "string.length"
  )

  expect_s3_class(
    p4,
    c("gg", "ggplot2")
  )

  # Test with custom group order
  p5 <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    groups.order = c("8", "4", "6")
  )

  expect_s3_class(
    p5,
    c("gg", "ggplot2")
  )

  # Test without error bars
  p6 <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    error_bars = FALSE
  )

  expect_s3_class(
    p6,
    c("gg", "ggplot2")
  )

  # Test with custom ytitle
  p7 <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    ytitle = "Custom Y Title"
  )

  expect_s3_class(
    p7,
    c("gg", "ggplot2")
  )

  # Test with custom legend.title
  p8 <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    legend.title = "Cylinders"
  )

  expect_s3_class(
    p8,
    c("gg", "ggplot2")
  )

  # Test with significance stars and bars
  p9 <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    significance_bars_x = c(3.15, 4.15),
    significance_stars = c("*", "***"),
    significance_stars_x = c(3.25, 4.5),
    significance_stars_y = list(
      c("4", "8", time = 3),
      c("4", "8", time = 4)
    )
  )

  expect_s3_class(
    p9,
    c("gg", "ggplot2")
  )

  # Test with print_table option
  capture.output({
    p10 <- plot_means_over_time(
      data = data,
      response = names(data)[6:3],
      group = "cyl",
      print_table = TRUE
    )
  })

  expect_s3_class(
    p10,
    c("gg", "ggplot2")
  )

  # Test with verbose option
  capture.output({
    p11 <- plot_means_over_time(
      data = data,
      response = names(data)[6:3],
      group = "cyl",
      verbose = TRUE
    )
  })

  expect_s3_class(
    p11,
    c("gg", "ggplot2")
  )

  # Test with different data set (using a simpler setup)
  test_data <- data.frame(
    id = 1:30,
    group = rep(c("A", "B", "C"), each = 10),
    T1_score = rnorm(30, mean = 10, sd = 2),
    T2_score = rnorm(30, mean = 12, sd = 2),
    T3_score = rnorm(30, mean = 14, sd = 2)
  )

  p12 <- plot_means_over_time(
    data = test_data,
    response = c("T1_score", "T2_score", "T3_score"),
    group = "group"
  )

  expect_s3_class(
    p12,
    c("gg", "ggplot2")
  )

  # Test output contains required ggplot components
  expect_true("GeomLine" %in% class(p1$layers[[1]]$geom))
  expect_true("GeomErrorbar" %in% class(p1$layers[[2]]$geom))
  expect_true("GeomPoint" %in% class(p1$layers[[3]]$geom))

  # Test plot without error bars has fewer layers
  expect_length(p6$layers, 2) # Should have line and point layers only

  # Verify plot data structure
  plot_data <- ggplot2::ggplot_build(p1)$data[[1]]
  expect_true(ncol(plot_data) > 0)
  expect_true(nrow(plot_data) > 0)
})

test_that("plot_means_over_time with ci_type parameter", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("tidyr")
  skip_if_not_installed("Rmisc")

  # Create test data with time series variables
  data <- mtcars
  names(data)[6:3] <- paste0("T", 1:4, "_var")

  # Test with ci_type = "within" (default)
  p_within <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    ci_type = "within"
  )

  expect_s3_class(
    p_within,
    c("gg", "ggplot2")
  )

  # Test with ci_type = "between"
  p_between <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    ci_type = "between"
  )

  expect_s3_class(
    p_between,
    c("gg", "ggplot2")
  )

  # Test verbose message for "within" ci_type
  output_within <- capture.output({
    verbose_within <- plot_means_over_time(
      data = data,
      response = names(data)[6:3],
      group = "cyl",
      ci_type = "within",
      verbose = TRUE
    )
  })

  expect_true(any(grepl("Morey", output_within)))

  # Test verbose message for "between" ci_type
  output_between <- capture.output({
    verbose_between <- plot_means_over_time(
      data = data,
      response = names(data)[6:3],
      group = "cyl",
      ci_type = "between",
      verbose = TRUE
    )
  })

  expect_true(any(grepl("between-subject", output_between)))

  # Test error for invalid ci_type
  expect_error(
    plot_means_over_time(
      data = data,
      response = names(data)[6:3],
      group = "cyl",
      ci_type = "invalid"
    ),
    "ci_type must be either"
  )
})

test_that("plot_means_over_time handles missing data", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("tidyr")
  skip_if_not_installed("Rmisc")

  # Create test data with time series variables and missing values
  data <- mtcars
  names(data)[6:3] <- paste0("T", 1:4, "_var")

  # Add missing values
  data_na <- data
  data_na[1:5, 3] <- NA
  data_na[10:15, 4] <- NA

  # Test with missing data and within-subject CIs (default)
  p_na_within <- plot_means_over_time(
    data = data_na,
    response = names(data_na)[6:3],
    group = "cyl"
  )

  expect_s3_class(
    p_na_within,
    c("gg", "ggplot2")
  )

  # Test with missing data and between-subject CIs
  p_na_between <- plot_means_over_time(
    data = data_na,
    response = names(data_na)[6:3],
    group = "cyl",
    ci_type = "between"
  )

  expect_s3_class(
    p_na_between,
    c("gg", "ggplot2")
  )

  # Test with heavily missing data
  data_heavy_na <- data
  data_heavy_na[1:10, 3] <- NA
  data_heavy_na[15:25, 4] <- NA
  data_heavy_na[5:12, 5] <- NA

  p_heavy_na <- plot_means_over_time(
    data = data_heavy_na,
    response = names(data_heavy_na)[6:3],
    group = "cyl"
  )

  expect_s3_class(
    p_heavy_na,
    c("gg", "ggplot2")
  )
})

test_that("plot_means_over_time with legend.position parameter", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("tidyr")
  skip_if_not_installed("Rmisc")

  # Create test data with time series variables
  data <- mtcars
  names(data)[6:3] <- paste0("T", 1:4, "_var")

  # Test with legend.position = "bottom"
  p_bottom <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    legend.position = "bottom"
  )

  expect_s3_class(
    p_bottom,
    c("gg", "ggplot2")
  )

  # Test with legend.position = "none"
  p_none <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    legend.position = "none"
  )

  expect_s3_class(
    p_none,
    c("gg", "ggplot2")
  )

  # Test with legend.position = "left"
  p_left <- plot_means_over_time(
    data = data,
    response = names(data)[6:3],
    group = "cyl",
    legend.position = "left"
  )

  expect_s3_class(
    p_left,
    c("gg", "ggplot2")
  )
})
