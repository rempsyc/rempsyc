test_that("plot_outliers", {
  skip_if_not_installed("ggplot2")

  x1 <- plot_outliers(
    airquality,
    group = "Month",
    response = "Ozone"
  )

  expect_s3_class(
    x1,
    c("gg", "ggplot2")
  )

  suppressMessages(suppressWarnings(ggplot2::ggsave("plot.jpg",
                  width = 7, height = 7, unit = "in",
                  dpi = 300, path = NULL
  )))

  # expect_snapshot_file("plot.jpg")
  # Not working...

  # Remove file
  unlink("plot.jpg")

  # Further customization
  x2 <- plot_outliers(
    airquality,
    response = "Ozone",
    method = "sd"
  )

  expect_s3_class(
    x2,
    c("gg", "ggplot2")
  )

})
