test_that("scale_mad", {
  expect_snapshot(scale_mad(mtcars$mpg))
})
