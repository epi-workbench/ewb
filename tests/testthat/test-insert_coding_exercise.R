# ===========================================================================
# Unit tests for the insert_coding_exercise() function.
# ===========================================================================


# =============================================================================
# Reusable Code Block Text Chunks
# Many of the code block templates below have large chunks of text in common.
# We will extract that text out into reusable chunks in this section to:
# 1. Make the templates below easier to read.
# 2. Make the templates below easier to maintain.
#
# These don't need to be documented in @description, because they aren't
# exposed to users and they aren't intended to be used on their own.
# =============================================================================

exercise_code_block <- paste(
  "```{r}",
  "",
  "```",
  "",
  sep = "\n"
)

solution_code_block <- paste(
  "```{r, type=solution}",
  "",
  "```",
  "",
  sep = "\n"
)

hidden_code_block_begin <- paste(
  "```{r, type=hide}",
  "# Hidden Block for Local Testing Only",
  "# -----------------------------------------------------------------------------",
  "",
  sep = "\n"
)

setup_learner_environment <- paste(
  "# Setup the simulated learner environment",
  "learner_env <- new.env()",
  "rm(list = ls(envir = learner_env), envir = learner_env)",
  "",
  sep = "\n"
)

set_active_submission <- paste(
  "# Set the active submission",
  "learner_code <- correct",
  "",
  sep = "\n"
)

evaluate_learner_submission_coding_exercise <- paste(
  "# Gracefully evaluate code (prevents early error from stopping tests)",
  "try(eval(parse(text = learner_code), envir = learner_env), silent = TRUE)",
  sep = "\n"
)

test_code_block_begin <- paste(
  "```{r, type=test}"
)

start_csts_coding_exercise <- paste(
  "# 1 - Check that `____` was replaced with something",
  'test_that(desc = "All blanks `____` were replaced", {',
  '  if (grepl("____", learner_code, fixed = TRUE)) {',
  '    fail("It looks like your submission still contains `____`. Please replace `____` to complete the code.")',
  '  } else {',
  '    succeed()',
  '  }',
  '})',
  "",
  sep = "\n"
)

code_block_end <- "```"

# =============================================================================
# Code Block Templates
# =============================================================================

# Default Template
# ---------------------------------------------------------------------------

expected_block <- paste(
  exercise_code_block,
  solution_code_block,
  hidden_cb_begin,
  setup_learner_environment,
  "# Simulated learner submissions",
  "correct <- '[INSERT]'",
  "wrong_1 <- '[INSERT]'",
  "",
  set_active_submission,
  evaluate_learner_submission_coding_exercise,
  code_block_end,
  "",
  test_code_block_begin,
  start_csts_coding_exercise,
  '# 2 - Check ...',
  'test_that(desc = "Concise statement of the test\'s purpose", {',
  '  if (condition 1) {',
  '    fail("Meaningful failure message")',
  '  } else {',
  '    succeed()',
  '  }',
  '})',
  code_block_end,
  "",
  # Modify in insert_hints.R
  hints_template_default(),
  sep = "\n"
)

test_that("coding_exercise_default() returns expected text", {
  expect_equal(coding_exercise_default(), expected_block)
})

# Template for Code Blocks Intended to be Run Without Modification
# ---------------------------------------------------------------------------

expected_block <- paste(
  exercise_code_block,
  solution_code_block,
  hidden_cb_begin,
  setup_learner_environment,
  "# Simulated learner submissions",
  "correct <- 'x <- 2'",
  "",
  set_active_submission,
  evaluate_learner_submission_coding_exercise,
  code_block_end,
  "",
  test_code_block_begin,
  '# 1 - Check to make sure the code is submitted without modification',
  '# Since the learner is only expected to click submit and not modify the',
  '# scaffolded code, a single exact match test is sufficient.',
  'test_that(desc = "Submit code without modification", {',
  '',
  '# Be mindful of invisible differences in whitespace when you paste code here.',
  "expected_code <- 'x <- 2'",
  '',
  '  if (trimws(learner_code) != trimws(expected_code)) {',
  '    fail(paste0(',
  '      "This code block already contains the correct code.\\n",',
  '      "Please submit it without making any changes.\\n",',
  '      "If you accidentally modified the code, click the reset button (\U0001F501) on ",',
  '      "the toolbar to restore the original version.\\n",',
  '      "Want to experiment or try something different? Open the interactive ",',
  '      "code console (</>) to explore safely without affecting your submission."',
  '    ))',
  '  } else {',
  '    succeed()',
  '  }',
  '})',
  code_block_end,
  "",
  # Modify in insert_hints.R
  hints_template_no_mod(),
  sep = "\n"
)

test_that("coding_exercise_no_mod() returns expected text", {
  expect_equal(coding_exercise_no_mod(), expected_block)
})

# Template for Code Blocks For Loading Packages
# ---------------------------------------------------------------------------

expected_block <- paste(
  exercise_code_block,
  solution_code_block,
  hidden_cb_begin,
  setup_learner_environment,
  "# Simulated learner submissions",
  "correct <- 'library(dplyr, warn.conflicts = FALSE)'",
  "correct_without_warn_conflicts <- 'library(dplyr)'",
  "correct_quoted_pkg <- 'library(\"dplyr\")'",
  "wrong_no_change <- 'library(____, warn.conflicts = FALSE)'",
  "wrong_missing_pkg <- 'library(ggplot2)'",
  "wrong_fn <- 'paste(dplyr)'",
  "wrong_require <- 'require(dplyr)' # Not best practice, but it works",
  "",
  "# Code for detaching packages during interactive testing",
  "# detach(\"package:dplyr\", unload = TRUE)",
  "",
  set_active_submission,
  evaluate_learner_submission_coding_exercise,
  code_block_end,
  "",
  test_code_block_begin,
  start_csts_coding_exercise,
  "# 2 - Check that dplyr was loaded",
  "# Calling `library(dplyr)` loads the package into the namespace of the R session,",
  "# not into a specific environment like `learner_env`. So checking `learner_env`",
  "# directly for loaded packages won't work the way checking for an object would.",
  "# However, if the learner correctly submits `library(dplyr)`, it will be loaded",
  "# into the session, and we can check for that using the CST below.",
  "test_that(desc = \"Did you load `dplyr`?\", {",
  "  if (!(\"dplyr\" %in% tolower((.packages())))) {",
  "    fail(\"Did you correctly load the `dplyr` package using the `library()` function?\")",
  "  } else {",
  "    succeed()",
  "  }",
  "})",
  code_block_end,
  sep = "\n"
)

test_that("coding_exercise_load_package() returns expected text", {
  expect_equal(coding_exercise_load_package(), expected_block)
})
