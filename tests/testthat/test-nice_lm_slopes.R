test_that("nice_lm_slopes", {
  skip_if_not_installed("effectsize")

  model <- lm(mpg ~ gear * wt, mtcars)
  expect_snapshot(nice_lm_slopes(model, predictor = "gear", moderator = "wt"))

  # Make and format multiple models
  model2 <- lm(qsec ~ gear * wt, mtcars)
  my.models <- list(model, model2)
  expect_snapshot(nice_lm_slopes(my.models, predictor = "gear", moderator = "wt"))
})

test_that("nice_lm_slopes with factor moderator shows appropriate error", {
  skip_if_not_installed("effectsize")
  
  # Factor moderators should give helpful error message
  model_factor <- lm(Sepal.Length ~ Sepal.Width * Species, iris)
  expect_error(
    nice_lm_slopes(model_factor, predictor = "Sepal.Width", moderator = "Species"),
    "must be numeric/continuous for simple slopes analysis"
  )
  expect_error(
    nice_lm_slopes(model_factor, predictor = "Sepal.Width", moderator = "Species"),
    "Factor moderators are not supported"
  )
  expect_error(
    nice_lm_slopes(model_factor, predictor = "Sepal.Width", moderator = "Species"),
    "consider using nice_contrasts"
  )
})
