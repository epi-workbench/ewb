# =============================================================================
# Unit tests for the ewb_colors() function.
# =============================================================================

testthat::test_that("Dimensions of ewb_colors are as expected", {
  testthat::expect_equal(nrow(ewb_colors), 5L)
  testthat::expect_equal(ncol(ewb_colors), 4L)
})

testthat::test_that("The column names of ewb_colors are as expected", {
  testthat::expect_equal(names(ewb_colors), c("group", "subgroup", "hex", "description" ))
})

testthat::test_that("The values of ewb_colors are as expected", {
  testthat::expect_equal(ewb_colors$group, rep("ewb", 5))
  testthat::expect_equal(
    as.character(ewb_colors$subgroup),
    c("Primary", "Primary", "Secondary", "Secondary", "Accent")
  )
  testthat::expect_equal(
    ewb_colors$hex,
    c("#4E5F72", "#FFD662", "#28A745", "#6C757D", "#FD7E14")
  )
  testthat::expect_equal(
    ewb_colors$description,
    c("Dark Blue", "Yellow", "Green", "Gray", "Orange")
  )
})
