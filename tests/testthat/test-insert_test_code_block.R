# ===========================================================================
# Unit tests for the test_code_block_template() function.
# ===========================================================================

expected_block <- paste(
  "```{r, type=test}",
  "",
  "```",
  sep = "\n"
)

test_that("test_code_block_template() returns expected text", {
  expect_equal(test_code_block_template(), expected_block)
})
