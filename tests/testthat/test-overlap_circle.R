test_that("overlap_circle", {
  skip_if_not_installed("VennDiagram")

  .old_wd <- setwd(tempdir())

  # Saving to file (PDF or PNG)
  x1 <- overlap_circle(3.5)
  ggplot2::ggsave(x1,
    file = "plot.jpg", width = 7,
    height = 7, unit = "in", dpi = 300
  )

  expect_s3_class(x1, "gList")

  ggplot2::ggsave("plot.jpg",
    width = 7, height = 7, unit = "in",
    dpi = 300, path = NULL
  )

  # expect_snapshot_file("plot.jpg")
  # Not working...

  # Score of 1 (0% overlap)
  x2 <- overlap_circle(1)

  expect_s3_class(x2, "gList")

  # Score of 3.5 (25% overlap)
  x3 <- overlap_circle(3.5)

  expect_s3_class(x3, "gList")

  # Score of 6.84 (81.8% overlap)
  x4 <- overlap_circle(6.84)

  expect_s3_class(x4, "gList")

  # Changing labels
  x5 <- overlap_circle(3.12, categories = c("Humans", "Animals"))

  expect_s3_class(x5, "gList")

  # Remove files
  unlink("plot.jpg")
  unlink("Rplots.pdf")

  setwd(.old_wd)
})
