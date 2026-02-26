#' Insert Code Block Hints into a Quarto Lesson
#'
#' @description
#' Launches an RStudio Addin that interactively inserts a templated hint text
#' code block into the active Quarto lesson at the current cursor location.
#'
#' This tool supports multiple predefined hint templates, including:
#'
#' - "default". The default hint template. This template includes general guidance for writing hints.
#'
#' - "no_mod". A hint template for code blocks that are intended to be run without modification.
#'
#' **Note:** This Addin must be run inside the RStudio IDE.
#'
#' @section Usage:
#' Run interactively via the RStudio Addins menu or call `insert_hints()` in the console.
#'
#' @seealso
#' [Hints wiki page](https://github.com/epi-workbench/EWBTemplates/wiki/Hints)
#'
#' @family Insert Addins
#' @return Invisibly returns the inserted hint template text.
#'
#' @examples
#' if (interactive()) insert_hints()
insert_hints <- function() {

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
  # - A set of radio buttons allowing the user to choose a hint template
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Insert Hint Template"),
    miniUI::miniContentPanel(
      shiny::radioButtons(
        inputId = "template_choice",
        label = "Select a Hint Template:",
        choices = c(
          "Default Hint (with guidance)" = "default",
          "No Modification (hints for unmodified code blocks)" = "no_mod"
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
        "default" = hints_template_default(),
        "no_mod" = hints_template_no_mod()
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
  viewer <- shiny::dialogViewer("Insert Hint Template", width = 400, height = 300)

  # Run the gadget (UI + server) using the defined viewer
  shiny::runGadget(ui, server, viewer = viewer)
}

# =============================================================================
# Hint Templates
# - Create new template options below.
# - Add the new template option to the server logic above. Inside the switch()
#   function.
# - Document the new template option under "@description" above.
# - Create a unit test in test-insert_hints.R.
# =============================================================================

## Default Hint Template
hints_template_default <- function() {
  paste(
    "<!-- HINT:",
    "[TITLE=Writing Hints, POINTS=25]",
    "- Hints provide supportive nudges that guide learners toward the solution without giving away the answer.",
    "- Hints should guide, not give away. Whenever possible, frame hints as leading questions that encourage critical thinking and recall. However, when a concept is new or particularly complex, it's okay to be more direct.",
    "- Use questions when learners should be expected to reason or recall: 'Did you remember to group the data before summarizing?'",
    "- Use directives when the focus is syntax or when getting stuck would feel arbitrary: 'Use the n() function to count the number of rows in each group.'",
    "",
    "[TITLE=Adjust Hints, POINTS=25]",
    "- Adjust the depth and directness of hints based on the type and difficulty of the lesson:",
    "  - Intro-level exercises: Direct, supportive guidance - include syntax or function names.",
    "  - Intermediate lessons: Leading questions and strategic nudges.",
    "  - Labs: Clarifying process or logic - minimal syntax help.",
    "  - Culminating exercises: Minimal hints. Focus on breaking down the task, not how to code it.",
    "- When in doubt, ask: What would keep the learner making progress without short-circuiting the learning opportunity?",
    "",
    "[TITLE=Hint Titles, POINTS=25]",
    "- Hint titles should be brief and written in title case.",
    "- Ask yourself, 'Would this title help a learner pick the right hint to view?' If not, it might not be needed.",
    "- The final (or possibly only) hint containing the solution code should always have the title 'Solution'.",
    "",
    "[TITLE=Solution, POINTS=100]",
    "- The final hint will be the solution. It should remove the remainder of the points.",
    "- Wrap solution code with code fences:",
    '```',
    '- x <- "hint"',
    '```',
    "-->",
    sep = "\n"
  )
}

## Hint Template for Code Blocks Intended to be Run Without Modification
hints_template_no_mod <- function() {
  paste(
    "<!-- HINT:",
    "[POINTS=0]",
    "- This code block already contains the correct code. Please submit it without making any changes.",
    "- If you accidentally modified the code, click the reset button (\U0001F501) on the toolbar to restore the original version.",
    "- Want to experiment or try something different? Open the interactive code console (</>) to explore safely without affecting your submission.",
    "-->",
    sep = "\n"
  )
}
