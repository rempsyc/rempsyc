test_that("find_mad", {
  expect_snapshot(find_mad(
    data = mtcars,
    col.list = names(mtcars),
    criteria = 3
  ))
  mtcars2 <- mtcars
  mtcars2$car <- row.names(mtcars)
  expect_snapshot(find_mad(
    data = mtcars2,
    col.list = names(mtcars),
    ID = "car",
    criteria = 3
  ))
})
