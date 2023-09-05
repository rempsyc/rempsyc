test_that("nice_contrasts", {
  skip_if_not_installed("bootES")
  skip_if_not_installed("emmeans")

  # Basic example
  set.seed(100)
  expect_snapshot(nice_contrasts(
    data = mtcars,
    response = "mpg",
    group = "cyl",
    bootstraps = 1000
  ))

  set.seed(100)
  expect_snapshot(nice_contrasts(
    data = mtcars,
    response = "disp",
    group = "gear",
    bootstraps = 2500
  ))

  # Multiple dependent variables
  set.seed(100)
  expect_snapshot(nice_contrasts(
    data = mtcars,
    response = c("mpg", "disp", "hp"),
    group = "cyl",
    bootstraps = 800
  ))

  # Adding covariates
  set.seed(100)
  expect_snapshot(nice_contrasts(
    data = mtcars,
    response = "mpg",
    group = "cyl",
    covariates = c("disp", "hp"),
    bootstraps = 500
  ))

  # Several groups
  mtcars2 <- mtcars
  mtcars2$carb <- as.factor(mtcars2$carb)

  model <- lm(mpg ~ carb + wt * hp, mtcars2)
  set.seed(100)
  expect_snapshot(nice_contrasts(
    data = mtcars,
    response = "mpg",
    group = "carb",
    bootstraps = 2500
  ))
})
