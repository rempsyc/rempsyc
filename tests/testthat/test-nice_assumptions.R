test_that("nice_assumptions", {
  skip_if_not_installed("lmtest")
  model <- lm(mpg ~ wt * cyl + gear, data = mtcars)
  nice_assumptions(model)

  # Multiple dependent variables at once
  model2 <- lm(qsec ~ disp + drat * carb, mtcars)
  my.models <- list(model, model2)
  expect_snapshot(nice_assumptions(my.models))
})
