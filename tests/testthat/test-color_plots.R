# =============================================================================
# Unit tests for the color_plots() function.
# =============================================================================

# -----------------------------------------------------------------------------
# Generate test data
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# The color_plots() function expects the object passed to the df argument to be
# a data frame.
# -----------------------------------------------------------------------------

test_that("The color_plots() function works as expected", {
  p <- color_plots(ewb_colors, "ewb")
  vdiffr::expect_doppelganger("Default color_plots plot", p)
})

# =============================================================================
# Clean up
# =============================================================================
rm(ewb_colors)
