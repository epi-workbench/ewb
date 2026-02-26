# ===========================================================================
# Unit tests for the lesson_yaml_header() function.
# ===========================================================================

expected_header <- paste(
  "---",
  "title: \"Add Lesson Title Here\"",
  "author: \"Your Name\"",
  "date: \"yyyy-mm-dd\"",
  "date-modified: \"yyyy-mm-dd\"",
  "type: \"Coding Exercise\"",
  "category: \"Programming Concepts\"",
  "subcategory: \"R Programming\"",
  "tags:",
  "  - placeholder",
  "---",
  sep = "\n"
)

test_that("lesson_yaml_header() returns expected text", {
  expect_equal(lesson_yaml_header(), expected_header)
})

