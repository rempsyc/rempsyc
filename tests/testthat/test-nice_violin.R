test_that("nice_violin", {
  skip_if_not_installed("ggplot2")
  skip_if_not_installed("boot")
  skip_if_not_installed("ggsignif")
  skip_if_not_installed("ggrepel")

  # Make the basic plot
  x1 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len"
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
  unlink("niceviolinplothere.tiff")

  # Change x- and y- axes labels
  x2 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len",
    ytitle = "Length of Tooth",
    xtitle = "Vitamin C Dosage"
  )

  expect_s3_class(
    x2,
    c("gg", "ggplot2")
  )

  # See difference between two groups
  x3 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len",
    comp1 = "0.5",
    comp2 = "2"
  )

  expect_s3_class(
    x3,
    c("gg", "ggplot2")
  )

  x4 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len",
    comp1 = 2,
    comp2 = 3
  )

  expect_s3_class(
    x4,
    c("gg", "ggplot2")
  )

  # Compare all three groups
  x5 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len",
    signif_annotation = c("*", "**", "***"),
    # manually enter the number of stars
    signif_yposition = c(30, 35, 40),
    # What height (y) should the stars appear?
    signif_xmin = c(1, 2, 1),
    # Where should the left-sided brackets start (x)?
    signif_xmax = c(2, 3, 3)
  ) # Where should the right-sided brackets end (x)?

  expect_s3_class(
    x5,
    c("gg", "ggplot2")
  )

  # Set the colours manually
  x6 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len",
    colours = c("darkseagreen", "cadetblue", "darkslateblue")
  )

  expect_s3_class(
    x6,
    c("gg", "ggplot2")
  )

  # Changing the names of the x-axis labels
  x7 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len",
    xlabels = c("Low", "Medium", "High")
  )

  expect_s3_class(
    x7,
    c("gg", "ggplot2")
  )

  # Removing the x-axis or y-axis titles
  x8 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len",
    ytitle = NULL,
    xtitle = NULL
  )

  expect_s3_class(
    x8,
    c("gg", "ggplot2")
  )

  # Removing the x-axis or y-axis labels (for whatever purpose)
  x9 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len",
    has.ylabels = FALSE,
    has.xlabels = FALSE
  )

  expect_s3_class(
    x9,
    c("gg", "ggplot2")
  )

  # Set y-scale manually
  x10 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len",
    ymin = 5,
    ymax = 35,
    yby = 5
  )

  expect_s3_class(
    x10,
    c("gg", "ggplot2")
  )

  # Plotting individual observations
  x11 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len",
    obs = TRUE
  )

  expect_s3_class(
    x11,
    c("gg", "ggplot2")
  )

  # Micro-customizations
  x12 <- nice_violin(
    data = ToothGrowth,
    group = "dose",
    response = "len",
    CIcap.width = 0,
    alpha = 1,
    border.colour = "black"
  )

  expect_s3_class(
    x12,
    c("gg", "ggplot2")
  )

})
