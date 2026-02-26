#' Insert a YAML Header into a Quarto Lesson
#'
#' @description This add-in inserts the standard YAML header used for
#'   Epi-Workbench lessons at the current cursor location in RStudio.
#'
#' @family Insert Addins
#'
#' @references For more information on lesson types see: https://github.com/epi-workbench/EWBTemplates/wiki
#'
#' @return Invisibly returns the YAML header text as a single character
#'   string.
#' @export
#'
#' @examples
#' if (interactive()) insert_lesson_yaml_header()
insert_lesson_yaml_header <- function() {
  header <- lesson_yaml_header()
  if (rstudioapi::isAvailable()) {
    rstudioapi::insertText(text = header)
  }
  invisible(header)
}

#' @rdname insert_lesson_yaml_header
#' @export
lesson_yaml_header <- function() {
  paste(
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
}
