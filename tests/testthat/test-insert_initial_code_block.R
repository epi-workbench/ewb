# ===========================================================================
# Unit tests for the initial_code_block_template() function.
# ===========================================================================

expected_block <- paste(
  "```{r, type=initial}",
  "",
  "```",
  sep = "\n"
)

test_that("initial_code_block_template() returns expected text", {
  expect_equal(initial_code_block_template(), expected_block)
})
