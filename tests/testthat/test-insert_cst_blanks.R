# ===========================================================================
# Unit tests for the cst_blanks_template() function.
# ===========================================================================

test_that("returns the exact expected template", {
  expected <- paste0(
    "# 1 - Check that all blanks `____` were replaced\n",
    "test_that(desc = \"All blanks `____` were replaced\", {\n",
    "  if (grepl(\"____\", learner_code, fixed = TRUE)) {\n",
    "    fail(\"It looks like your submission still contains `____`. Please replace `____` to complete the code.\")\n",
    "  } else {\n",
    "    succeed()\n",
    "  }\n",
    "})\n"
  )

  out <- cst_blanks_template()
  expect_type(out, "character")
  expect_identical(out, expected)
})


# ===========================================================================
# Unit tests for the insert_cst_blanks() function.
# ===========================================================================

test_that("inserts via rstudioapi when available, returns invisibly", {
  skip_on_cran()

  inserted_text <- NULL

  testthat::with_mocked_bindings(
    {
      expect_invisible(insert_cst_blanks())
      expect_type(inserted_text, "character")
      expect_identical(inserted_text, cst_blanks_template())
    },
    .package    = "rstudioapi",
    isAvailable = function(...) TRUE,
    insertText  = function(text, ...) { inserted_text <<- text; invisible(NULL) }
  )
})

test_that("does not attempt insertion if rstudioapi not available", {
  skip_on_cran()

  called_insert <- FALSE

  testthat::with_mocked_bindings(
    {
      expect_invisible(insert_cst_blanks())
      expect_false(called_insert)
    },
    .package    = "rstudioapi",
    isAvailable = function(...) FALSE,
    insertText  = function(...) { called_insert <<- TRUE; stop("Should not be called") }
  )
})
