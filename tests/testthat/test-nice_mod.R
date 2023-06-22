test_that("nice_mod", {
  skip_if_not_installed("effectsize")

  expect_snapshot(nice_mod(
    data = mtcars,
    response = "mpg",
    predictor = "gear",
    moderator = "wt"
  ))

  # Multiple dependent variables at once
  expect_snapshot(nice_mod(
    data = mtcars,
    response = c("mpg", "disp", "hp"),
    predictor = "gear",
    moderator = "wt"
  ))

  # Add covariates
  expect_snapshot(nice_mod(
    data = mtcars,
    response = "mpg",
    predictor = "gear",
    moderator = "wt",
    covariates = c("am", "vs")
  ))

  # Three-way interaction
  expect_snapshot(nice_mod(
    data = mtcars,
    response = "mpg",
    predictor = "gear",
    moderator = "wt",
    moderator2 = "am"
  ))

})
