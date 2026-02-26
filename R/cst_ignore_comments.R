# ===========================================================================
# Snippet of code for ignoring comments in CSTs
# This was previously part of insert_hidden_code_block.R. Specifically, the
# hidden_code_block_no_mod() function.
# We took it out because, while it can be helpful when there are comments,
# it can also create issues too.
# Additionally, our current thinking is that we want to keep template code
# blocks, including no modification blocks, as simple/pure as possible. So,
# the code below would only be added to a no mod block when it's necessary
# because of code comments. Not every no mod code block.
# We are keeping the code below around in case we need it later.
# ===========================================================================

cst_ignore_comments <- paste(
  '  # Remove comments from each line, collapse to a single string, and trim',
  '  learner_code_split <- unlist(strsplit(learner_code, "\\n"))',
  '  learner_code_no_comments <- gsub("#.*", "", learner_code_split)',
  '  learner_code_no_comments <- trimws(paste(learner_code_no_comments, collapse = " "))',
  '',
  sep = "\n"
)
