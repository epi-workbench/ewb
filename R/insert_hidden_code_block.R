#' Insert an Hidden Code Block into a Quarto Lesson
#'
#' @description
#' Launches an RStudio Addin that interactively inserts a hidden code block
#' template into the active Quarto lesson at the current cursor location.
#'
#' This tool supports multiple predefined templates for Code Submission Tests
#' (CSTs), including:
#'
#' - `"default"`. General-purpose CSTs with guidance for customization.
#'
#' - `"no_mod"`: CSTs for unmodified scaffolded code blocks. These should only
#'   be used when:
#'     - The exercise code block includes clear, minimal code that does not need
#'       to be modified by the learner.
#'     - The instructions explicitly tell the learner to submit the code
#'       without making any changes.
#'     - The scaffolded code is written carefully to match the CST exactly.
#'
#' - `"load_package"`: CSTs that check whether packages are loaded correctly
#'   using `library()`.
#'
#' The inserted hidden block includes simulated submissions, CST scaffolding,
#' and a reminder to structure tests clearly and meaningfully.
#'
#' **Note:** This Addin must be run inside the RStudio IDE.
#'
#' @section Usage:
#' Run interactively via the RStudio Addins menu or call `insert_hidden_code_block()` in the console.
#'
#' @seealso
#' [Writing CSTs wiki page](https://github.com/epi-workbench/EWBTemplates/wiki/Writing-CSTs)
#'
#' @family Insert Addins
#' @return Invisibly returns the inserted template text.
#' @export
#'
#' @examples
#' if (interactive()) insert_hints()
insert_hidden_code_block <- function() {

  # Ensure the RStudio API is available (needed to insert text into editor)
  if (!rstudioapi::isAvailable()) {
    stop("This Addin must be run within RStudio.")
  }

  # ----------------------------------------------------------------------------
  # UI DEFINITION
  # ----------------------------------------------------------------------------
  # Use miniUI to create a compact gadget interface that displays inside RStudio.
  # The gadget includes:
  # - A title bar with "Done" and "Cancel" buttons
  # - A set of radio buttons allowing the user to choose a code block template
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Insert Hidden Code Block Template"),
    miniUI::miniContentPanel(
      shiny::radioButtons(
        inputId = "template_choice",
        label = "Select a Template:",
        choices = c(
          "Default (with guidance)" = "default",
          "No Modification (CSTs for unmodified code blocks)" = "no_mod",
          "Load Package (CSTs for loading packages with `library()`)" = "load_package"
        ),
        selected = "default"
      )
    )
  )

  # ----------------------------------------------------------------------------
  # SERVER LOGIC
  # ----------------------------------------------------------------------------
  # This defines how the gadget responds to user input
  server <- function(input, output, session) {

    # When the user clicks the "Done" button:
    shiny::observeEvent(input$done, {

      # Select the appropriate template text based on user choice
      hint_text <- switch(
        input$template_choice,
        "default" = hidden_code_block_default(),
        "no_mod" = hidden_code_block_no_mod(),
        "load_package" = hidden_code_block_load_package()
      )

      # Insert the selected template text at the current cursor location
      rstudioapi::insertText(text = hint_text)

      # Close the gadget
      shiny::stopApp()
    })

    # If the user clicks "Cancel", close the gadget without doing anything
    shiny::observeEvent(input$cancel, {
      shiny::stopApp()
    })
  }

  # ----------------------------------------------------------------------------
  # LAUNCH THE GADGET
  # ----------------------------------------------------------------------------
  # Use dialogViewer() to open the UI as a native RStudio pop-up (rather than browser tab)
  viewer <- shiny::dialogViewer("Insert Hint Template", width = 600, height = 300)

  # Run the gadget (UI + server) using the defined viewer
  shiny::runGadget(ui, server, viewer = viewer)
}

# =============================================================================
# Reusable Code Block Text Chunks
# Many of the code block templates below have large chunks of text in common.
# We will extract that text out into reusable chunks in this section to:
# 1. Make the templates below easier to read.
# 2. Make the templates below easier to maintain.
# 3. Allows us to more easily see the differences between the templates.
#
# These don't need to be documented in @description, because they aren't
# exposed to users and they aren't intended to be used on their own.
# =============================================================================

hidden_cb_begin <- paste(
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

evaluate_learner_submission <- paste(
  "# Gracefully evaluate code (prevents early error from stopping tests)",
  "try(eval(parse(text = learner_code), envir = learner_env), silent = TRUE)",
  "",
  sep = "\n"
)

start_csts <- paste(
  "# Code Submission Tests (CSTs)",
  "# -----------------------------------------------------------------------------",
  "",
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

hidden_cb_end <- "```"

# =============================================================================
# Code Block Templates
# - Create new template options below.
# - Add the new template option to the server logic above. Inside the switch()
#   function.
# - Document the new template option under "@description" above.
# - Create a unit test in test-insert_hidden_code_block.R.
# =============================================================================

# Default Template
# ---------------------------------------------------------------------------
hidden_code_block_default <- function() {
  paste(
    hidden_cb_begin,
    setup_learner_environment,
    "# Simulated learner submissions",
    "correct <- '[INSERT]'",
    "wrong_1 <- '[INSERT]'",
    "",
    set_active_submission,
    evaluate_learner_submission,
    start_csts,
    '# 2 - Check ...',
    'test_that(desc = "Concise statement of the test\'s purpose", {',
    '  if (condition 1) {',
    '    fail("Meaningful failure message")',
    '  } else {',
    '    succeed()',
    '  }',
    '})',
    hidden_cb_end,
    sep = "\n"
  )
}

# Template for Code Blocks Intended to be Run Without Modification
# ---------------------------------------------------------------------------
hidden_code_block_no_mod <- function() {
  paste(
    hidden_cb_begin,
    setup_learner_environment,
    "# Simulated learner submissions",
    "correct <- 'x <- 2'",
    "",
    set_active_submission,
    evaluate_learner_submission,
    "# Code Submission Tests (CSTs)",
    "# -----------------------------------------------------------------------------",
    "",
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
    hidden_cb_end,
    sep = "\n"
  )
}

# Template for Code Blocks For Loading Packages
# ---------------------------------------------------------------------------
hidden_code_block_load_package <- function() {
  paste(
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
    evaluate_learner_submission,
    start_csts,
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
    hidden_cb_end,
    sep = "\n"
  )
}
