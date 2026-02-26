# ===========================================================================
# Unit tests for the noeval_code_block_template() function.
# ===========================================================================

expected_block <- paste(
  "```{r, type=noeval}",
  "",
  "```",
  sep = "\n"
)

test_that("noeval_code_block_template() returns expected text", {
  expect_equal(noeval_code_block_template(), expected_block)
})
