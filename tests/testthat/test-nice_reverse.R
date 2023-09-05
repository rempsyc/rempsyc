test_that("nice_reverse", {
  # Reverse score of 5 with a maximum score of 5
  expect_snapshot(nice_reverse(5, 5))

  # Reverse several scores at once
  expect_snapshot(nice_reverse(1:5, 5))

  # Reverse scores with maximum = 4 and minimum = 0
  expect_snapshot(nice_reverse(1:4, 4, min = 0))

  # Reverse scores with maximum = 3 and minimum = -3
  expect_snapshot(nice_reverse(-3:3, 3, min = -3))
})
