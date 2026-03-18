test_that("nice_t_test", {
  skip_if_not_installed("effectsize")
  skip_if_not_installed("methods")

  result <- nice_t_test(
    data = mtcars,
    response = "mpg",
    group = "am",
    verbose = FALSE
  )
  expect_s3_class(result, "data.frame")
  expect_equal(
    names(result),
    c("Dependent Variable", "t", "df", "p", "d", "CI_lower", "CI_upper")
  )
  expect_equal(nrow(result), 1)
  expect_equal(result$`Dependent Variable`, "mpg")
  expect_equal(result$t, -3.767123, tolerance = 1e-6)
  expect_equal(result$df, 18.33225, tolerance = 1e-5)
  expect_lt(abs(result$p - 0.001373638), 1e-9)
  expect_equal(result$d, -1.477947, tolerance = 1e-6)

  result_multi <- nice_t_test(
    data = mtcars,
    response = names(mtcars)[1:7],
    group = "am",
    verbose = FALSE
  )
  expect_s3_class(result_multi, "data.frame")
  expect_equal(nrow(result_multi), 7)
  expect_equal(
    result_multi$`Dependent Variable`,
    c("mpg", "cyl", "disp", "hp", "drat", "wt", "qsec")
  )
  expect_equal(result_multi$t[1], -3.767123, tolerance = 1e-6)
  expect_equal(result_multi$CI_lower[2], 0.4315895, tolerance = 1e-6)
  expect_equal(result_multi$CI_upper[6], 2.7329219, tolerance = 1e-6)

  result_equal_var <- nice_t_test(
    data = mtcars,
    response = "mpg",
    group = "am",
    var.equal = TRUE,
    verbose = FALSE
  )
  expect_equal(result_equal_var$df, 30)
  expect_equal(result_equal_var$t, -4.106127, tolerance = 1e-6)

  result_one_sided <- nice_t_test(
    data = mtcars,
    response = "mpg",
    group = "am",
    alternative = "less",
    verbose = FALSE
  )
  expect_lt(abs(result_one_sided$p - 0.0006868192), 1e-10)

  result_one_sample <- nice_t_test(
    data = mtcars,
    response = "mpg",
    mu = 10,
    verbose = FALSE
  )
  expect_equal(result_one_sample$df, 31)
  expect_equal(result_one_sample$d, 1.674251, tolerance = 1e-6)

  result_paired <- nice_t_test(
    data = ToothGrowth,
    response = "len",
    group = "supp",
    paired = TRUE,
    verbose = FALSE
  )
  expect_equal(result_paired$`Dependent Variable`, "len")
  expect_equal(result_paired$t, 3.302585, tolerance = 1e-6)
  expect_equal(result_paired$CI_upper, 0.9883437, tolerance = 1e-6)
})
