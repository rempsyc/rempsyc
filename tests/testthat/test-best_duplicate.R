test_that("best_duplicate", {
  df1 <- data.frame(
    id = c(1, 2, 3, 1, 3),
    item1 = c(NA, 1, 1, 2, 3),
    item2 = c(NA, 1, 1, 2, 3),
    item3 = c(NA, 1, 1, 2, 3)
  )
  expect_snapshot(best_duplicate(df1, id = "id"))
})
