test_that("cormatrix_excel", {
  skip_if_not_installed("correlation")
  skip_if_not_installed("openxlsx2")

  expect_snapshot(suppressWarnings(cormatrix_excel(mtcars, select = c(
    "mpg", "cyl", "disp", "hp", "carb"),filename = "cormatrix1", verbose = FALSE)))
  expect_snapshot(suppressWarnings(cormatrix_excel(
    iris, p_adjust = "none", filename = "cormatrix2", verbose = FALSE)))
  expect_snapshot(suppressWarnings(cormatrix_excel(
    airquality, method = "spearman", filename = "cormatrix3", verbose = FALSE)))
  # expect_snapshot_file("cormatrix1.xlsx")
  # Not supported
  unlink("cormatrix1.xlsx")
  unlink("cormatrix2.xlsx")
  unlink("cormatrix3.xlsx")
})

