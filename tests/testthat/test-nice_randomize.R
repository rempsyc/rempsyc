test_that("nice_randomize", {
  # Specify design, number of conditions, number of
  # participants, and names of conditions:
  set.seed(100)
  expect_snapshot(nice_randomize(
    design = "between", Ncondition = 4, n = 8,
    condition.names = c("BP", "CX", "PZ", "ZL")
  ))

  # Within-Group Design
  set.seed(100)
  expect_snapshot(nice_randomize(
    design = "within", Ncondition = 4, n = 6,
    condition.names = c("SV", "AV", "ST", "AT")
  ))

  # Make a quick runsheet
  set.seed(100)
  expect_snapshot(nice_randomize(
    design = "within", Ncondition = 4, n = 128,
    condition.names = c("SV", "AV", "ST", "AT"),
    col.names = c(
      "id", "Condition", "Date/Time",
      "SONA ID", "Age/Gd.", "Handedness",
      "Tester", "Notes"
    )
  ))
})
