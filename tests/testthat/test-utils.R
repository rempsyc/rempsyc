test_that("apply_variable_labels works correctly", {
  # Test with fully labeled data
  test_data <- head(mtcars[c("mpg", "cyl", "wt")])
  attr(test_data$mpg, "label") <- "Miles per Gallon"
  attr(test_data$cyl, "label") <- "Number of Cylinders"
  attr(test_data$wt, "label") <- "Weight (1000 lbs)"
  
  labeled_data <- apply_variable_labels(test_data)
  expect_equal(names(labeled_data), c("Miles per Gallon", "Number of Cylinders", "Weight (1000 lbs)"))
  
  # Test with mixed labels
  mixed_data <- head(mtcars[c("mpg", "cyl", "hp")])
  attr(mixed_data$mpg, "label") <- "Miles per Gallon"
  attr(mixed_data$cyl, "label") <- "Number of Cylinders"
  # hp has no label
  
  mixed_result <- apply_variable_labels(mixed_data)
  expect_equal(names(mixed_result), c("Miles per Gallon", "Number of Cylinders", "hp"))
  
  # Test with no labels
  no_labels_data <- head(mtcars[c("mpg", "cyl", "wt")])
  no_labels_result <- apply_variable_labels(no_labels_data)
  expect_equal(names(no_labels_result), c("mpg", "cyl", "wt"))
  
  # Test with empty/NA labels
  empty_data <- head(mtcars[c("mpg", "cyl")])
  attr(empty_data$mpg, "label") <- ""
  attr(empty_data$cyl, "label") <- NA
  
  empty_result <- apply_variable_labels(empty_data)
  expect_equal(names(empty_result), c("mpg", "cyl"))
})

test_that("assign_variable_labels works correctly", {
  test_data <- head(mtcars[c("mpg", "cyl", "wt")])
  
  labels <- c("mpg" = "Miles per Gallon", "cyl" = "Number of Cylinders")
  labeled_data <- assign_variable_labels(test_data, labels)
  
  expect_equal(attr(labeled_data$mpg, "label"), "Miles per Gallon")
  expect_equal(attr(labeled_data$cyl, "label"), "Number of Cylinders")
  expect_null(attr(labeled_data$wt, "label"))
  
  # Test with NULL labels
  unlabeled_data <- assign_variable_labels(test_data, NULL)
  expect_identical(unlabeled_data, test_data)
  
  # Test error with unnamed labels
  expect_error(assign_variable_labels(test_data, c("Label 1", "Label 2")))
})