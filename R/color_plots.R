#' Plot Color Palettes
#'
#' @description This function helps visualize color palettes like the EWB brand
#' standard color palette created in the `EWBTemplates` package.
#'
#' @description
#' This function expects to be passed a data frame containing color palette
#' information. It expects the data frame to have at least one row and at least
#' 4 columns. It expects those columns to include:
#'
#' \describe{
#'   \item{group}{
#'   A name describing a brand or project associated with the color palette
#'   (e.g., "ewb").
#'   }
#'   \item{subgroup}{
#'   Optional names given to describe color categories (e.g., primary,
#'   secondary, accent).
#'   }
#'   \item{hex}{Hexidecimal code for each color.}
#'   \item{description}{
#'   A descriptive name for each color (e.g., black, blue, dark green).
#'   }
#' }
#'
#' @param df A data frame with the characteristics outlined in the
#' `description` section of the documentation.
#' @param .group A name describing a brand or project associated with the color
#' palette to be plotted.
#'
#' @returns A ggplot2 plot.
#' @export
#'
#' @examples
#' data(ewb_colors)
#' color_plots(ewb_colors, "ewb")
color_plots <- function(df, .group) {
  # ------------------------------------------------------------------
  # Prevents R CMD check: "no visible binding for global variable ‘.’"
  # ------------------------------------------------------------------
  group = subgroup = row_number = hex = description = x = NULL

  # Prep the data from plotting
  df <- df |>
    dplyr::filter(group == .group) |>
    dplyr::group_by(subgroup) |>
    dplyr::mutate(x = dplyr::row_number()) |>
    dplyr::ungroup() |>
    dplyr::mutate(hex = factor(hex, hex, hex))

  # Create the plot
  ggplot2::ggplot(df, ggplot2::aes(x = x, y = 1, fill = hex)) +
    ggplot2::geom_raster() +
    ggplot2::geom_text(ggplot2::aes(label = description), color = "white") +
    ggplot2::facet_wrap(ggplot2::vars(subgroup), ncol = 1) +
    ggplot2::scale_fill_manual("Hexidecimal code", values = as.character(df$hex)) +
    ggplot2::theme(
      # Remove background
      panel.background = ggplot2::element_rect(fill = "transparent"),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      plot.background  = ggplot2::element_rect(fill = "transparent"),

      # Remove x axis
      axis.title.x = ggplot2::element_blank(),
      axis.text.x  = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),

      # Remove y axis
      axis.title.y = ggplot2::element_blank(),
      axis.text.y  = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),

      # Facet labels
      strip.background = ggplot2::element_rect(color = "black", fill = "transparent")
    )
}

# For testing
# data(ewb_colors)
# color_plots(ewb_colors, "ewb")
