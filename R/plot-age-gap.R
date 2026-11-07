#' Plot the age gap between a player and the opponents
#'
#' Makes a scatter plot of the matches of a player, like the plot of the New
#' York Times, without annotations. Each point is one match. The x-axis is
#' the age of the player, the y-axis is the age of the player minus the age of
#' the opponent, and the color and the shape show if the player won or lost.
#' A point above the line at 0 is a match against a younger opponent.
#'
#' @param matches A data frame from [get_player_matches()].
#' @return A `ggplot` object. Print it to see the plot, or save it with
#'   [ggplot2::ggsave()].
#' @examples
#' \dontrun{
#' serena <- get_player_matches("serena williams")
#' plot_age_gap(serena)
#' }
#' @export
plot_age_gap <- function(matches) {
  check_matches(matches)
  matches$result <- factor(matches$result, levels = c("win", "loss"))
  aesthetics <- aes(
    x = .data$player_age, y = .data$age_diff,
    color = .data$result, shape = .data$result
  )
  ggplot(matches, aesthetics) +
    geom_hline(yintercept = 0, color = "gray60") +
    geom_point(size = 2, alpha = 0.8) +
    result_scales() +
    age_axis() +
    age_gap_labels(matches) +
    age_gap_theme()
}

#' Stop if the table of matches cannot be plotted
#' @param matches Object given to `plot_age_gap()`.
#' @noRd
check_matches <- function(matches) {
  needed <- c("player", "player_age", "age_diff", "result")
  ok <- is.data.frame(matches) && all(needed %in% names(matches)) &&
    nrow(matches) > 0
  if (!ok) {
    stop("`matches` must be a data frame from `get_player_matches()`.", call. = FALSE)
  }
  invisible(matches)
}

#' Colors and shapes for wins and losses
#' @noRd
result_scales <- function() {
  list(
    scale_color_manual(values = c(win = "#2a78d6", loss = "#4a3aa7")),
    scale_shape_manual(values = c(win = 16, loss = 17))
  )
}

#' X-axis with a tick every 2 years, like the plot of the New York Times
#' @noRd
age_axis <- function() {
  scale_x_continuous(breaks = function(limits) {
    seq(floor(limits[1] / 2) * 2, ceiling(limits[2] / 2) * 2, by = 2)
  })
}

#' Title of the plot, e.g. "Serena Williams's Professional Matches, Age 14 to 40"
#' @param matches Table of matches.
#' @noRd
age_gap_title <- function(matches) {
  ages <- floor(range(matches$player_age))
  paste0(
    matches$player[1], "'s Professional Matches, Age ", ages[1], " to ", ages[2]
  )
}

#' Title, axis names and legend names of the plot
#' @param matches Table of matches.
#' @noRd
age_gap_labels <- function(matches) {
  labs(
    title = age_gap_title(matches),
    subtitle = "Above 0: older than the opponent. Below 0: younger.",
    x = paste0(matches$player[1], "'s age (years)"),
    y = "Age difference from opponent (years)",
    color = "Match result", shape = "Match result",
    caption = "Source: Tennis Abstract"
  )
}

#' Theme of the plot: white background, light grid, legend on top
#' @noRd
age_gap_theme <- function() {
  theme_minimal(base_size = 12) +
    theme(
      panel.background = element_rect(fill = "white", color = NA),
      plot.background = element_rect(fill = "white", color = NA),
      panel.grid.minor = element_blank(),
      legend.position = "top"
    )
}
