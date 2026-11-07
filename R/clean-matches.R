match_columns <- c(
  "player", "date", "tournament", "surface", "result", "score", "opponent",
  "player_age", "opponent_age", "age_diff"
)

#' Get one field of every match as a character vector
#' @param rows List of matches from `parse_career_js()`.
#' @param i Position of the field in a match (1-based).
#' @noRd
match_field <- function(rows, i) {
  vapply(rows, function(row) row[[i]], character(1))
}

#' Table with the fields that the plot needs
#'
#' The field `opponent_info` is the date of birth of the opponent in files of
#' female players, and the age of the opponent in files of male players.
#'
#' @inheritParams match_field
#' @noRd
match_table <- function(rows) {
  col <- function(i) match_field(rows, i)
  data.frame(
    date = as.Date(col(1), format = "%Y%m%d"),
    tournament = col(2), surface = col(3),
    result = ifelse(col(5) == "W", "win", "loss"),
    score = col(10), opponent = col(12), opponent_info = col(17)
  )
}

#' Tell if the opponent field has dates of birth (female files) or ages
#' @param opponent_info Character vector of the opponent field.
#' @noRd
has_birth_dates <- function(opponent_info) {
  opponent_info <- opponent_info[nzchar(opponent_info)]
  length(opponent_info) > 0 && all(grepl("^[0-9]{8}$", opponent_info))
}

#' Age of the opponent in years on the date of the match
#' @param opponent_info Character vector of the opponent field.
#' @param date Dates of the matches.
#' @noRd
opponent_age_years <- function(opponent_info, date) {
  if (has_birth_dates(opponent_info)) {
    age_in_years(as.Date(opponent_info, format = "%Y%m%d"), date)
  } else {
    suppressWarnings(as.numeric(opponent_info))
  }
}

#' Add the ages of the player and the opponent, and their difference
#' @param matches Table from `match_table()`.
#' @param player_dob Date of birth of the player.
#' @noRd
add_ages <- function(matches, player_dob) {
  matches$player_age <- age_in_years(player_dob, matches$date)
  matches$opponent_age <-
    opponent_age_years(matches$opponent_info, matches$date)
  matches$age_diff <- matches$player_age - matches$opponent_age
  matches
}

#' Make the clean table of matches from the text of a career JS file
#'
#' A walkover (`W/O`) is a match that the players did not play, so it is
#' removed. A match without an age for the opponent is removed too.
#'
#' @param js_text Text of the career JS file.
#' @param player_dob Date of birth of the player, a `Date`.
#' @param player_name Name of the player, for example `"Serena Williams"`.
#' @return A data frame with one row for each match.
#' @noRd
clean_career_matches <- function(js_text, player_dob, player_name) {
  matches <- match_table(parse_career_js(js_text))
  matches <- matches[matches$score != "W/O", ]
  matches <- add_ages(matches, player_dob)
  matches <- matches[!is.na(matches$age_diff), ]
  matches$player <- player_name
  rownames(matches) <- NULL
  matches[, match_columns]
}
