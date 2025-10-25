test_that("nice_t_test", {
  skip_if_not_installed("effectsize")
  skip_if_not_installed("methods")

  expect_snapshot(nice_t_test(
    data = mtcars,
    response = "mpg",
    group = "am",
    verbose = FALSE
  ))

  # Multiple dependent variables at once
  expect_snapshot(nice_t_test(
    data = mtcars,
    response = names(mtcars)[1:7],
    group = "am",
    verbose = FALSE
  ))

  # Can be passed some of the regular arguments
  # of base [t.test()]

  # Student t-test (instead of Welch)
  expect_snapshot(nice_t_test(
    data = mtcars,
    response = "mpg",
    group = "am",
    var.equal = TRUE,
    verbose = FALSE
  ))

  # One-sided instead of two-sided
  expect_snapshot(nice_t_test(
    data = mtcars,
    response = "mpg",
    group = "am",
    alternative = "less",
    verbose = FALSE
  ))

  # One-sample t-test
  expect_snapshot(nice_t_test(
    data = mtcars,
    response = "mpg",
    mu = 10,
    verbose = FALSE
  ))

  # Paired t-test instead of independent samples
  expect_snapshot(nice_t_test(
    data = ToothGrowth,
    response = "len",
    group = "supp",
    paired = TRUE,
    verbose = FALSE
  ))
})

test_that("nice_t_test paired with grouped data", {
  skip_if_not_installed("effectsize")
  skip_if_not_installed("methods")
  skip_if_not_installed("dplyr")
  skip_if_not_installed("tidyr")

  # Test paired t-test with long-format data in grouped scenario
  # This tests the fix for the issue where paired t-tests failed
  # when used with dplyr::group_by() and pivot_longer()
  
  set.seed(123)
  df_long <- data.frame(
    country = rep(c("CHN", "USA"), each = 20),
    stimuli = rep(1:4, each = 5, times = 2),
    quality = rnorm(40, 5, 1),
    status = rnorm(40, 4, 1)
  )

  result <- df_long %>%
    tidyr::pivot_longer(cols = c(quality, status), 
                       names_to = "item", 
                       values_to = "quality_status") %>%
    dplyr::group_by(country, stimuli) %>%
    dplyr::summarise(
      eff = nice_t_test(
        data = dplyr::pick("quality_status", "item"),
        response = "quality_status",
        group = "item",
        paired = TRUE,
        verbose = FALSE
      ),
      .groups = "drop"
    ) %>%
    tidyr::unnest_wider(eff)

  # Check that results are returned
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 8) # 2 countries * 4 stimuli
  expect_true("t" %in% names(result))
  expect_true("p" %in% names(result))
  expect_true("d" %in% names(result))
  
  # Check that all p-values are numeric and between 0 and 1
  expect_true(all(result$p >= 0 & result$p <= 1))
  
  # Check that degrees of freedom are correct (n-1 for paired test)
  expect_true(all(result$df == 4)) # 5 pairs - 1
})
