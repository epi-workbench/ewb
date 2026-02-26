# ===========================================================================
# Unit tests for the solution_code_block_template() function.
# ===========================================================================

expected_block <- paste(
  "```{r, type=solution}",
  "",
  "```",
  sep = "\n"
)

test_that("solution_code_block_template() returns expected text", {
  expect_equal(solution_code_block_template(), expected_block)
})
