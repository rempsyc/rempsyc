test_that("winsorize_mad", {
  expect_snapshot(winsorize_mad(mtcars$qsec, criteria = 2))
})
