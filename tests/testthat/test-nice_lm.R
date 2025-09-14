test_that("nice_lm", {
  skip_if_not_installed("effectsize")

  model <- lm(mpg ~ cyl + wt * hp, mtcars)
  expect_snapshot(nice_lm(model))

  model2 <- lm(qsec ~ disp + drat * carb, mtcars)
  my.models <- list(model, model2)
  expect_snapshot(nice_lm(my.models))
})

test_that("nice_lm with factor covariates", {
  skip_if_not_installed("effectsize")

  # Test with multi-level factor (issue #31)
  model_factor <- lm(Sepal.Length ~ Sepal.Width * Petal.Width + Species + Petal.Width, iris)
  result <- nice_lm(model_factor)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 5) # Should have 5 rows for 5 coefficients
  expect_true("Speciesversicolor" %in% result$Predictor)
  expect_true("Speciesvirginica" %in% result$Predictor)
  # Both species levels should have same sr2 value (same factor)
  species_rows <- result[result$Predictor %in% c("Speciesversicolor", "Speciesvirginica"), ]
  expect_equal(species_rows$sr2[1], species_rows$sr2[2])

  # Test with multiple models including factors
  model_simple <- lm(Sepal.Length ~ Sepal.Width + Petal.Width, iris)
  models_list <- list(model_simple, model_factor)
  result_multiple <- nice_lm(models_list)
  expect_s3_class(result_multiple, "data.frame")
  expect_equal(nrow(result_multiple), 7) # 2 + 5 coefficients
})
