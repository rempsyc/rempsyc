test_that("nice_var", {
  expect_snapshot(nice_var(
    data = iris,
    variable = "Sepal.Length",
    group = "Species"
  ))

  # Try on multiple variables
  expect_snapshot(nice_var(
    data = iris,
    variable = names(iris[1:4]),
    group = "Species"
  ))
})
