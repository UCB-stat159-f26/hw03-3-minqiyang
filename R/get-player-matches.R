#' Get the career matches of a tennis player
#'
#' Downloads the career matches of a player from
#' [tennisabstract.com](https://www.tennisabstract.com) and returns them as a
#' clean data frame, ready for `plot_age_gap()`.
#'
#' The name can be written as `"serena williams"`, `"Serena Williams"` or
#' `"SerenaWilliams"`. Walkovers (`W/O`) are removed, because the players did
#' not play these matches. For female players the age of the opponent is
#' derived from her date of birth. For male players the file has this age.
#'
#' @param player_name Name of the player, a character string.
#' @return A data frame with one row for each match and these columns:
#'   * `player`: full name of the player.
#'   * `date`: date of the match.
#'   * `tournament`, `surface`, `score`, `opponent`: details of the match.
#'   * `result`: `"win"` or `"loss"`, for the player.
#'   * `player_age`, `opponent_age`: ages in years on the date of the match.
#'   * `age_diff`: `player_age - opponent_age`.
#'
#'   If the player is not on Tennis Abstract, the function stops with an error
#'   about the spelling of the name.
#' @examples
#' \dontrun{
#' serena <- get_player_matches("serena williams")
#' rafa <- get_player_matches("Rafael Nadal")
#' }
#' @export
get_player_matches <- function(player_name) {
  player <- normalize_player_name(player_name)
  career_js <- fetch_career_js(player)
  profile <- fetch_player_profile(player)
  clean_career_matches(career_js, profile$dob, profile$name)
}
