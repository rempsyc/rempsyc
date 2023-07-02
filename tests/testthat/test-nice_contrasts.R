test_that("nice_contrasts", {
  skip_if_not_installed("bootES")
  skip_if_not_installed("emmeans")

  # Basic example
  set.seed(100)
  expect_snapshot(nice_contrasts(
    data = mtcars,
    response = "mpg",
    group = "cyl",
    bootstraps = 200
  ))

  set.seed(100)
  expect_snapshot(nice_contrasts(
    data = mtcars,
    response = "disp",
    group = "gear",
    bootstraps = 200
  ))

  # Multiple dependent variables
  set.seed(100)
  expect_snapshot(nice_contrasts(
    data = mtcars,
    response = c("mpg", "disp", "hp"),
    group = "cyl",
    bootstraps = 200
  ))

  # Adding covariates
  set.seed(100)
  expect_snapshot(nice_contrasts(
    data = mtcars,
    response = "mpg",
    group = "cyl",
    covariates = c("disp", "hp"),
    bootstraps = 200
  ))

})
