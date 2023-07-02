test_that("nice_lm_contrasts", {
  skip_if_not_installed("bootES")
  skip_if_not_installed("modelbased")

  mtcars2 <- mtcars
  mtcars2$cyl <- as.factor(mtcars2$cyl)
  mtcars2$carb <- as.factor(mtcars2$carb)

  # Basic
  model <- lm(mpg ~ cyl + wt * hp, mtcars2)
  set.seed(100)
  expect_snapshot(nice_lm_contrasts(model, group = "cyl", data = mtcars2, bootstraps = 500))

  # Several models
  model2 <- lm(qsec ~ cyl, data = mtcars2)
  my.models <- list(model, model2)

  set.seed(100)
  expect_snapshot(nice_lm_contrasts(my.models, group = "cyl", data = mtcars2, bootstraps = 500))

  # Several groups
  model <- lm(mpg ~ carb + wt * hp, mtcars2)
  set.seed(100)
  expect_snapshot(nice_lm_contrasts(model, group = "carb", data = mtcars2, bootstraps = 2500))

})
