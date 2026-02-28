# ewb 0.0.9011

- Added Positron snippet files (`CSTs.code-snippets` and `hints.code-snippets`) to `inst/extdata/snippets/`.

  - Users can copy these files into their project's `.vscode/` folder to enable tab-completion for CSTs and hints in Positron.

  - Added a new vignette (`vignette("setting-up-positron-snippets", package = "ewb")`) with step-by-step setup instructions.

- Updated `convert_knitr_images()` to provide more informative feedback.

  - The function now prints a message listing the number of converted blocks and the names of the affected image files.

  - If no knitr image blocks are found, the function informs the user rather than silently completing.

  - The function now invisibly returns the `output_file` path when writing to disk.

# ewb 0.0.9010

- Updated all `test_that()` calls across ewb (including CST templates, helper functions, and internal tests) to use the explicit `desc =` argument.

  - For example: `test_that(desc = "checks object creation", { ... })`
  
  - This change prevents `test_that()` descriptions from cluttering the RStudio Document Outline, improving navigation and readability in lesson and test files.
  
  - No functional changes to CST behavior or output.

# ewb 0.0.9009

- Added the `insert_cst_blanks()` function.

  - `insert_cst_blanks()` is an RStudio addin that inserts a templated **Code Submission Test (CST)** at the current cursor position.  
  - The inserted test uses **testthat** to check whether any scaffolding blanks (`____`) remain in `learner_code`. If so, the test fails with a clear message; otherwise it succeeds.  
  - A companion helper, `cst_blanks_template()`, returns the template as a character string without inserting it, making it easier to write unit tests or reuse the template programmatically.

# ewb 0.0.9008

- Add the `insert_coding_exercise()` function.
  - This RStudio Addin interactively inserts a complete exercise template into the active Quarto lesson at the current cursor location. The template includes:
    - an exercise code block
    - a solution code block
    - a hidden code block
    - a test code block
    - a hint block
  - The hidden code block contains only example learner code (no CSTs). CSTs are included exclusively in the test block. This design:
    - keeps lesson files shorter
    - makes CSTs easier to locate in the file outline
    - **avoids inconsistencies that could arise from duplicating CSTs across multiple blocks**
    
- Update the `insert_hidden_code_block()` function.
  - We added a line for `expected_code` to the CST in the no modification code blocks template. This makes it easier to test submitted code that spans multiple lines.
  - The failure message in the in the no modification code blocks template is now spread across multiple lines to make it easier to read.

# ewb 0.0.9007

- Update the `insert_hidden_code_block()` function.

  - Remove the CST from the "no modification"" hidden code block template that checks for unmodified partial code scaffolding (`____`). This CST was unnecessary because no modification code blocks contain the complete solution by definition.
  
  - Remove example incorrect simulated learner responses from the "no modification" hidden code block template. Since any deviation from the provided code should already trigger the CST, explicit checks for specific incorrect responses are unnecessary. The template only needs to verify that the correct code passes.
  
  - Replace all references to "student" with "learner".
  
  - We prefer **"learner"** over **"student"** or **"member"**:
  
    - The term "learner" is inclusive and reflects the diverse audience of Epi-Workbench, which includes health professionals and the general public.
    - Unlike "student," it does not imply a formal school setting, grading, or enrollment.
    - Unlike "member," it conveys an active process of gaining knowledge rather than a passive association with a group.
    
  - Update `test_that()` descriptions. They should be concise statements of the CST's purpose. Guidance for learners will be provided in failure messages only.

# ewb 0.0.9006

- Update the `insert_hidden_code_block()` function.

  - Fix typos in the hidden code block for loading packages template. The previous simulated student submissions didn't apply to loading packages.
  
  - Add code for detaching packages during interactive testing to the hidden code block for loading packages template.

# ewb 0.0.9005

- Added `convert_knitr_images()` function to convert R code blocks using `knitr::include_graphics()` into standard markdown image syntax (e.g., `![filename](link)`) for easier portability and readability in Quarto and markdown documents.

# ewb 0.0.9004

- The `insert_hints()` function now has the ability to insert multiple different hint templates via the `templates` argument.

- Made the `insert_hints()` Addin interactive using `shiny::miniUI` and `rstudioapi::dialogViewer()`, allowing users to select a hint template from a dropdown menu within RStudio.

- Updated `insert_hidden_code_block()` RStudio Addin to interactively insert templated CST code blocks into Quarto lessons. Includes support for "default", "no_mod", and "load_package" templates.

# ewb 0.0.9003

- Update the example hint syntax.

- Update the code scaffolding inside of hidden code blocks.
  
  - Change "Tests" to "Code Submission Tests (CSTs)".
  
  - Add an example CST to check that `____` was replaced with something.
  
- Add the the 'Insert Addins' @family to:

  - insert_hidden_code_block.R
  
  - insert_hints.R
  
  - insert_initial_code_block.R
  
  - insert_lesson_yaml_header.R
  
  - insert_noeval_code_block.R
  
  - insert_solution_code_block.R
  
  - insert_test_code_block.R
  
- Add links to GitHub Wiki documentation to:

  - insert_hidden_code_block.R
  
  - insert_hints.R
  
  - insert_initial_code_block.R
  
  - insert_lesson_yaml_header.R
  
  - insert_noeval_code_block.R
  
  - insert_solution_code_block.R
  
  - insert_test_code_block.R

# ewb 0.0.9002

- Update the code scaffolding inside of hidden code blocks.

# ewb 0.0.9001

- Add RStudio add-ins for inserting YAML headers to EWB lesson files.

- Add RStudio add-ins for inserting solution, hidden, test, and noeval code blocks to EWB lesson files.

- Add RStudio add-ins for inserting code block hints to EWB lesson files.

- Update the Quarto coding lesson template used by `new_quarto_lesson_coding()`.

- Add the Quarto Course Overview template used by `new_quarto_course_overview()`

# ewb 0.0.9000

- This is the first committed version of the ewb package.

- This is a development version of the package and subject to major changes.

- This version of the the ewb package will not be made available on
CRAN.

- This version contains:

  - A table of EWB brand standard colors.

  - A collection of EWB brand standard logos.

  - A template for creating EWB coding lessons.

  - A convenience function, `color_plots()`, for visualizing color palettes
  like the EWB brand standard color palette created in the `ewb`
  package.
