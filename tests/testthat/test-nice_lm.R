test_that("nice_lm", {
  skip_if_not_installed("effectsize")

  model <- lm(mpg ~ cyl + wt * hp, mtcars)
  expect_snapshot(nice_lm(model))

  model2 <- lm(qsec ~ disp + drat * carb, mtcars)
  my.models <- list(model, model2)
  expect_snapshot(nice_lm(my.models))
})
