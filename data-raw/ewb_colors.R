# =============================================================================
# Colors data
# This is the code to create a data frame containing colors consistent with
# Epi-Workbench brand standards.
# Created: 2025-02-24
# =============================================================================

library(dplyr, warn.conflicts = FALSE)

ewb_colors <- tibble::tribble(
  ~group, ~subgroup,   ~hex,      ~description,
  "ewb",  "primary",   "#4E5F72", "Dark Blue",
  "ewb",  "primary",   "#FFD662", "Yellow",

  "ewb",  "secondary", "#28A745", "Green",
  "ewb",  "secondary", "#6C757D", "Gray",

  "ewb",  "accent",    "#FD7E14", "Orange"
)

# Make subgroup a factor for plots
ewb_colors <- ewb_colors |>
  dplyr::mutate(subgroup = factor(
    subgroup,
    c("primary", "secondary", "accent"),
    c("Primary", "Secondary", "Accent")
  ))

# Add the simulated data to the data directory.
usethis::use_data(ewb_colors, overwrite = TRUE)
