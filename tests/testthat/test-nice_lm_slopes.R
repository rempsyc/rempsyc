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

test_that("nice_lm_slopes works with continuous moderator despite factor covariates", {
  skip_if_not_installed("effectsize")
  
  # Should work when moderator is continuous even if model has factor covariates with >2 levels
  model_with_factors <- lm(Sepal.Length ~ Sepal.Width * Petal.Width + Species, iris)
  result <- nice_lm_slopes(model_with_factors, predictor = "Sepal.Width", moderator = "Petal.Width")
  
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)  # LOW, MEAN, HIGH conditions
  expect_true(all(c("Dependent Variable", "Predictor (+/-1 SD)", "df", "b", "t", "p", "sr2", "CI_lower", "CI_upper") %in% names(result)))
  
  # Check that the simple slopes analysis worked correctly
  expect_true(all(result$`Dependent Variable` == "Sepal.Length"))
  expect_true(grepl("LOW-Petal.Width", result$`Predictor (+/-1 SD)`[1]))
  expect_true(grepl("MEAN-Petal.Width", result$`Predictor (+/-1 SD)`[2]))  
  expect_true(grepl("HIGH-Petal.Width", result$`Predictor (+/-1 SD)`[3]))
})
