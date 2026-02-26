# =============================================================================
# Unit tests for the new_quarto_lesson_coding() function.
#
# Documentation for testing snapshots:
#  https://testthat.r-lib.org/articles/snapshotting.html
#  https://testthat.r-lib.org/reference/expect_snapshot_file.html
# =============================================================================

# When the code is run, does it create the expected Quarto file?

# First store the output of new_quarto_lesson_coding() as a tempfile.
# See https://testthat.r-lib.org/reference/expect_snapshot_file.html
test_that("The new_quarto_lesson_coding() function creates the expected Quarto file", {
  local_edition(3)  # Use snapshot testing edition 3 for this test
  temp_file <- tempfile()
  file_nm <- basename(temp_file)
  temp_dir <- dirname(temp_file)
  new_quarto_lesson_coding(file_name = file_nm, file_loc = temp_dir)
  new_temp_file_path <- paste0(temp_dir, "/", file_nm, ".qmd")
  expect_snapshot_file(new_temp_file_path, "test-new_quarto_lesson_coding.qmd")
})
