tennis_abstract_url <- "https://www.tennisabstract.com"

#' URL of the JavaScript file with the career matches of a player
#' @param player Player name in the Tennis Abstract format, e.g. `"SerenaWilliams"`.
#' @noRd
career_js_url <- function(player) {
  paste0(tennis_abstract_url, "/jsmatches/", player, "Career.js")
}

#' URL of the page of a player, which has the name and date of birth
#' @param player Player name in the Tennis Abstract format, e.g. `"SerenaWilliams"`.
#' @noRd
player_page_url <- function(player) {
  paste0(tennis_abstract_url, "/cgi-bin/player.cgi?p=", player)
}
