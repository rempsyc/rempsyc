test_that("nice_lm_contrasts", {
  skip_if_not_installed("bootES")
  skip_if_not_installed("emmeans")

  model <- lm(mpg ~ as.factor(cyl) + wt * hp, mtcars)
  set.seed(100)
  expect_snapshot(nice_lm_contrasts(model, group = "cyl", data = mtcars, bootstraps = 500))

  model2 <- lm(qsec ~ as.factor(cyl), data = mtcars)
  my.models <- list(model, model2)

  set.seed(100)
  expect_snapshot(nice_lm_contrasts(my.models, group = "cyl", data = mtcars, bootstraps = 500))

})
