# =============================================================================
# Unit tests for the convert_knitr_images() function.
#
# Documentation for testing snapshots:
#  https://testthat.r-lib.org/articles/snapshotting.html
#  https://testthat.r-lib.org/reference/expect_snapshot_file.html
# =============================================================================

# When the code is run, does it create the converted Quarto file?
# Does the converted Quarto file include correct markdown image syntax?

# First store the output of convert_knitr_images() as a tempfile.
# See https://testthat.r-lib.org/reference/expect_snapshot_file.html
test_that("The convert_knitr_images() function creates the converted Quarto file", {
  local_edition(3)  # Use snapshot testing edition 3 for this test
  # Save path to the example.qmd input file
  example_input_file <- testthat::test_path("testdata", "example.qmd")

  # Create a temporary file path for the converted output
  temp_file <- tempfile(fileext = ".qmd")

  # Run the function
  convert_knitr_images(input_file = example_input_file, output_file = temp_file)

  # Compare the function result to the expected result
  expect_snapshot_file(temp_file, "test-convert_knitr_images.qmd")
})

