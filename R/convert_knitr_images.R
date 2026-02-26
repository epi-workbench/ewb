#' Convert `knitr::include_graphics()` Code Blocks to Markdown Image Syntax
#'
#' @description
#' This function reads a markdown or Quarto file and searches for R code blocks
#' that use `knitr::include_graphics()` to render images. It replaces those code
#' blocks with standard markdown image syntax, e.g., `![filename](link)`.
#'
#' @param input_file A character string specifying the path to the input markdown (`.md` or `.qmd`) file.
#' @param output_file Optional. A character string specifying the path to write the modified file.
#' If `NULL`, the modified lines are returned as a character vector instead of being written to disk.
#'
#' @return If `output_file` is `NULL`, returns a character vector containing the modified file content.
#' Otherwise, the function writes the modified content to the specified output file and returns nothing.
#'
#' @examples
#' \dontrun{
#' convert_knitr_images("example.qmd", "converted.qmd")
#' }
#'
#' @export
convert_knitr_images <- function(input_file, output_file = NULL) {
  # Read the lines of the file
  lines <- readLines(input_file, warn = FALSE)

  # Initialize storage for the output
  output_lines <- character(0)
  in_code_block <- FALSE
  block_buffer <- character(0)

  for (line in lines) {
    # Detect code block start
    if (grepl("^```\\{r.*\\}", line)) {
      in_code_block <- TRUE
      block_buffer <- c(block_buffer, line)
      next
    }

    # Accumulate code block lines
    if (in_code_block) {
      block_buffer <- c(block_buffer, line)
      if (grepl("^```\\s*$", line)) {
        # End of code block
        block_text <- paste(block_buffer, collapse = "\n")

        # Check for knitr::include_graphics
        if (grepl("knitr::include_graphics\\(", block_text)) {
          matches <- gregexpr('knitr::include_graphics\\(("|\')([^"\']+)("|\')\\)', block_text, perl = TRUE)
          replacement_lines <- regmatches(block_text, matches)[[1]]

          for (match in replacement_lines) {
            image_file <- sub('.*\\(("|\')([^"\']+)("|\')\\).*', '\\2', match)
            image_md <- sprintf("![%s](Replace_with_link)", image_file)
            output_lines <- c(output_lines, image_md)
          }
        } else {
          output_lines <- c(output_lines, block_buffer)
        }

        # Reset for next block
        in_code_block <- FALSE
        block_buffer <- character(0)
      }
    } else {
      # Not in code block
      output_lines <- c(output_lines, line)
    }
  }

  # Write to file or return
  if (!is.null(output_file)) {
    writeLines(output_lines, output_file)
  } else {
    return(output_lines)
  }
}
