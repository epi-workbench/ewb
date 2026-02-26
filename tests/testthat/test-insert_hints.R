# ===========================================================================
# Unit tests for the hints_template() function.
# ===========================================================================

# Default Hint Template
# ---------------------------------------------------------------------------

expected_text <- paste(
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

test_that("hints_template_default() returns the expected text", {
  expect_equal(hints_template_default(), expected_text)
})

# Hint Template for Code Blocks Intended to be Run Without Modification
# ---------------------------------------------------------------------------

expected_text <- paste(
  "<!-- HINT:",
  "[POINTS=0]",
  "- This code block already contains the correct code. Please submit it without making any changes.",
  "- If you accidentally modified the code, click the reset button (\U0001F501) on the toolbar to restore the original version.",
  "- Want to experiment or try something different? Open the interactive code console (</>) to explore safely without affecting your submission.",
  "-->",
  sep = "\n"
)

test_that("hints_template_default() returns the expected text", {
  expect_equal(hints_template_no_mod(), expected_text)
})
