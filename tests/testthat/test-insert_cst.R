# tests/testthat/test-insert_cst.R
test_that("cst_templates registry is well-formed", {
  reg <- cst_templates()
  expect_true(is.list(reg))
  expect_true("blanks" %in% names(reg))
  expect_true(is.list(reg$blanks))
  expect_true(is.character(reg$blanks$label))
  expect_true(is.function(reg$blanks$fun))
})

test_that("insert_cst_blanks is available", {
  # Only check presence, not execution (IDE dependent)
  expect_true(exists("insert_cst_blanks"))
})
