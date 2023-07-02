test_that("nice_assumptions", {
  skip_if_not_installed("lmtest")
  model <- lm(mpg ~ wt * cyl + gear, data = mtcars)
  nice_assumptions(model)

  # Multiple dependent variables at once
  model2 <- lm(qsec ~ disp + drat * carb, mtcars)
  my.models <- list(model, model2)
  expect_snapshot(nice_assumptions(my.models))

  # Sample size too big for Shapiro
  dd <- data.frame(x = 1:5001)
  dd$y <- 1 + 0.5*dd$x + rnorm(length(dd$x))
  m1 <- lm(y ~ x, data = dd)
  expect_message(nice_assumptions(m1))

  # Sample size too small for Shapiro
  dd <- data.frame(x = 1:3)
  dd$y <- 1 + 0.5*dd$x + rnorm(length(dd$x))
  m1 <- lm(y ~ x, data = dd)
  expect_message(nice_assumptions(m1))

})
