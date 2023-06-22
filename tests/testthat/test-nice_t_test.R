test_that("nice_t_test", {
  skip_if_not_installed("effectsize")
  skip_if_not_installed("methods")

  expect_snapshot(nice_t_test(
    data = mtcars,
    response = "mpg",
    group = "am"
  ))

  # Multiple dependent variables at once
  expect_snapshot(nice_t_test(
    data = mtcars,
    response = names(mtcars)[1:7],
    group = "am"
  ))

  # Can be passed some of the regular arguments
  # of base [t.test()]

  # Student t-test (instead of Welch)
  expect_snapshot(nice_t_test(
    data = mtcars,
    response = "mpg",
    group = "am",
    var.equal = TRUE
  ))

  # One-sided instead of two-sided
  expect_snapshot(nice_t_test(
    data = mtcars,
    response = "mpg",
    group = "am",
    alternative = "less"
  ))

  # One-sample t-test
  expect_snapshot(nice_t_test(
    data = mtcars,
    response = "mpg",
    mu = 10
  ))

  # Paired t-test instead of independent samples
  # Requires data in "long" format
  expect_snapshot(nice_t_test(
    data = ToothGrowth,
    response = "len",
    group = "supp",
    paired = TRUE
  ))

})