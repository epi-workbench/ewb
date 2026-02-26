#' Launch the Insert-CST Gadget (RStudio Addin)
#'
#' @description Launches a small UI to select from available Code Submission Test
#' (CST) insertion templates (e.g., `insert_cst_blanks()`) and inserts the chosen
#' template at the current cursor location in the active RStudio document.
#'
#' @details
#' - Designed as a thin wrapper around existing insertion helpers.
#' - New templates can be registered by adding an entry to `cst_templates()` (see below).
#' - Requires the RStudio IDE.
#'
#' @return Invisibly returns the selected template's function name (character).
#'
#' @examples
#' \dontrun{
#'   insert_cst()  # Launch the gadget
#' }
#'
#' @section Extending:
#' Add a new template by defining a function that performs the insertion
#' (e.g., `insert_cst_mytemplate()`), then register it in `cst_templates()`.
#'
#' @importFrom rstudioapi isAvailable
#' @importFrom shiny shinyApp observeEvent req reactive
#' @importFrom miniUI miniPage gadgetTitleBar miniContentPanel
#' @export
insert_cst <- function() {
  if (!rstudioapi::isAvailable()) {
    stop("This addin requires the RStudio IDE.", call. = FALSE)
  }

  # Build a named list of available templates
  templates <- cst_templates()

  # ---- UI ----
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Insert CST Template"),
    miniUI::miniContentPanel(
      shiny::tags$div(
        style = "margin: 8px 12px;",
        shiny::selectInput(
          inputId = "template",
          label   = "Choose a template:",
          choices = stats::setNames(names(templates), vapply(templates, `[[`, "", "label"))
        ),
        shiny::uiOutput("desc"),
        shiny::hr(),
        shiny::actionButton("preview_btn", "Preview"),
        shiny::actionButton("insert_btn",  "Insert")
      )
    )
  )

  # ---- Server ----
  server <- function(input, output, session) {
    # Description/preview text (if provided by the template)
    output$desc <- shiny::renderUI({
      key <- input$template
      if (is.null(key) || !nzchar(key)) return(NULL)
      entry <- templates[[key]]
      shiny::tagList(
        shiny::tags$p(shiny::tags$strong("Description:")),
        shiny::tags$p(if (!is.null(entry$description)) entry$description else "-"),
        shiny::tags$details(
          open = FALSE,
          shiny::tags$summary("Show raw preview"),
          shiny::tags$pre(
            style = "white-space: pre-wrap;",
            if (!is.null(entry$preview)) entry$preview() else "No preview available."
          )
        )
      )
    })

    # Preview just shows the preview pane (no-op beyond rendering)
    shiny::observeEvent(input$preview_btn, {
      shiny::req(input$template)
      # No side effects-preview is rendered reactively above.
    })

    # Insert: call the registered function
    shiny::observeEvent(input$insert_btn, {
      shiny::req(input$template)
      entry <- templates[[input$template]]
      if (is.null(entry) || is.null(entry$fun)) {
        shiny::showNotification("Template not found or not callable.", type = "error")
        return(invisible())
      }
      # Call the insertion helper (expected to handle the insertion at the cursor)
      entry$fun()
      shiny::stopApp(invisible(input$template))
    })

    # Close (titlebar 'Done' / 'Cancel')
    shiny::observeEvent(input$done,  shiny::stopApp(invisible(input$template)))
    shiny::observeEvent(input$cancel, shiny::stopApp(invisible(NULL)))
  }

  shiny::shinyApp(ui, server)
}

#' Registry of available CST insertion templates
#'
#' @description Internal helper returning a named list of template entries.
#' Each entry should include:
#' - label: user-facing label in the dropdown
#' - description: short text describing the template
#' - preview: a function returning a character preview of what will be inserted
#' - fun: a zero-argument function that performs the insertion (e.g., calls `insert_cst_blanks()`)
#'
#' @keywords internal
#' @noRd
cst_templates <- function() {
  # Safely get a preview string from a function, falling back if it errors / missing
  safe_preview <- function(f, fallback = "No preview available.") {
    if (is.null(f)) return(fallback)
    out <- tryCatch(f(), error = function(e) fallback)
    if (is.null(out) || !is.character(out)) fallback else out
  }

  # Example: register your existing template function(s) here.
  # You can add more entries in the same format.
  templates <- list(
    blanks = list(
      label       = "Check that all blanks `____` were replaced",
      description = "Check that all blanks `____` were replaced.",
      preview     = function() cst_blanks_template(),
      fun         = function() {
        # Call the real inserter (already implemented elsewhere in your package)
        insert_cst_blanks()
      }
    )
    # , another_template = list(...)
  )

  # Name each entry with its key for easy lookup by selectInput
  # (names shown in selectInput are labels; the values are these keys)
  if (length(templates)) names(templates) <- names(templates) else templates
  # Make sure previews are safe (not strictly necessary, but helpful)
  for (nm in names(templates)) {
    templates[[nm]]$preview <- local({
      p <- templates[[nm]]$preview
      function() safe_preview(p)
    })
  }
  templates
}
