#' Write a player name the way Tennis Abstract does
#'
#' Tennis Abstract joins the words of a name and starts each word with a
#' capital letter, for example `"SerenaWilliams"`. This function turns
#' `"serena williams"`, `"Serena Williams"` and `"SerenaWilliams"` into that
#' form. A name with one word is kept as it is, apart from the first letter,
#' because the capital letters inside it cannot be found again.
#'
#' @param player_name A character string with the name of a player.
#' @return A character string, for example `"SerenaWilliams"`.
#' @noRd
normalize_player_name <- function(player_name) {
  check_player_name(player_name)
  words <- strsplit(trimws(player_name), "\\s+")[[1]]
  if (length(words) > 1) {
    words <- tolower(words)
  }
  paste0(toupper(substring(words, 1, 1)), substring(words, 2), collapse = "")
}

#' Stop if the player name is not one non-empty string
#' @noRd
check_player_name <- function(player_name) {
  ok <- is.character(player_name) && length(player_name) == 1 &&
    !is.na(player_name) && nzchar(trimws(player_name))
  if (!ok) {
    stop("`player_name` must be one non-empty character string.", call. = FALSE)
  }
  invisible(player_name)
}
