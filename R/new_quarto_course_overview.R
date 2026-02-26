#' Create a Blank Quarto File - Course Overview Template
#'
#' @param file_name What do you want to name the new Quarto file you're creating
#'   from the template Quarto file? If a name isn't provided, then the template
#'   name will be used by default.
#'
#' @param file_loc Where do you want the new template Quarto file to be stored?
#'   The default location is the value returned by `here::here()`.
#'
#' @param template_name The name of the Quarto skeleton file = "course_overview". You
#'   should only have change this value if you change the name of the skeleton
#'   file.
#'
#' @param interactive If TRUE, an interactive text editor will pop up on screen
#'  allowing users to make edits to the new Quarto file before saving it. This
#'  accomplished via a call to `utils::file.edit`.
#'
#' @return A message to the console.
#' @export
#'
#' @examples
#'
#' # With defaults
#' # new_quarto_course_overview()
#'
#' # Set a new file name
#' # new_quarto_course_overview("test_qmd_file")
#'
#' # Set new file location other than here::here()
#' # No forward slash at the end
#' # new_quarto_lesson_coding(file_loc = "/Users/bradcannell/Desktop")
new_quarto_course_overview <- function(
    file_name     = NULL,
    file_loc      = here::here(),
    template_name = "course_overview",
    interactive   = FALSE) {

  # ===========================================================================
  # Set up file names and paths
  # ===========================================================================

  # If a file name isn't provided, then the template name will be used by
  # default.
  if (is.null(file_name)) {
    file_name <- template_name
  }

  # Path to the template file inside the templates package
  template_name_qmd  <- paste0(template_name, ".qmd")
  template_file_path <- paste0("extdata/_extensions/", template_name, "/", template_name_qmd)

  # Path to the new qmd file
  file_name_qmd  <- paste0(file_name, ".qmd")
  file_name_path <- paste0(file_loc, "/", file_name_qmd)

  # ===========================================================================
  # Error checks
  # ===========================================================================

  # Make sure a qmd file by the same name doesn't already exist. We don't want
  # to overwrite the file and potentially erase important code.
  if (file.exists(file_name_path)) {
    stop(file_name_path, " already exists. Please choose a new file name.")
  }

  # ===========================================================================
  # Read information about the template file from _extension.yml for reporting
  # ===========================================================================

  yml_text <- readLines(
    system.file(
      paste0("extdata/_extensions/", template_name, "/_extension.yml"),
      package = "EWBTemplates"
    )
  )

  yml_title <- gsub(
    x = yml_text[grepl(x = yml_text, pattern = "title:")],
    pattern = "title: ",
    replacement = ""
  )

  yml_version <- gsub(
    x = yml_text[grepl(x = yml_text, pattern = "version:")],
    pattern = "version: ",
    replacement = ""
  )

  # ===========================================================================
  # Create new qmd file based on template file
  # ===========================================================================

  # Copy template file from the templates package to the location specified
  # in file_loc
  file.copy(
    from      = system.file(template_file_path, package = "EWBTemplates"),
    to        = file_name_path,
    overwrite = FALSE,
    copy.mode = TRUE
  )

  # ===========================================================================
  # Create message for user
  # ===========================================================================

  if (file.exists(file_name_path)) {
    message(
      "The qmd template file, ", yml_title, " version ", yml_version,
      ", was successfully copied from the templates package as ",
      file_name_path, "."
    )
  } else {
    message("New file appears not to have been created.")
  }

  # ===========================================================================
  # Optionally open the new file in the editor
  # ===========================================================================
  if (interactive == TRUE) utils::file.edit(file_name_path)
}

# For testing
# new_quarto_course_overview(
#   file_name = "test_qmd_file",
#   file_loc  = "/Users/bradcannell/Desktop/"
# )
