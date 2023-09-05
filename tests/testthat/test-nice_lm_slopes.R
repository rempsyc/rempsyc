test_that("nice_lm_slopes", {
  skip_if_not_installed("effectsize")

  model <- lm(mpg ~ gear * wt, mtcars)
  expect_snapshot(nice_lm_slopes(model, predictor = "gear", moderator = "wt"))

  # Make and format multiple models
  model2 <- lm(qsec ~ gear * wt, mtcars)
  my.models <- list(model, model2)
  expect_snapshot(nice_lm_slopes(my.models, predictor = "gear", moderator = "wt"))
})
