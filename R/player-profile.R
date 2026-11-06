#' Read a JavaScript variable from the text of a player page
#'
#' The page of a player has lines such as `var dob = 19810926;` and
#' `var fullname = 'Serena Williams';`.
#'
#' @param page_text Text of the player page.
#' @param name Name of the variable, e.g. `"dob"`.
#' @return The value as a string, without quotes, or `NA` if not found.
#' @noRd
page_variable <- function(page_text, name) {
  pattern <- paste0("var ", name, " = '?(.*?)'?;")
  hit <- regmatches(page_text, regexec(pattern, page_text, perl = TRUE))[[1]]
  if (length(hit) == 0) NA_character_ else hit[2]
}

#' Read the full name and the date of birth from the text of a player page
#'
#' @inheritParams page_variable
#' @return A list with the full `name` and the date of birth `dob` (a `Date`).
#' @noRd
parse_player_profile <- function(page_text) {
  name <- page_variable(page_text, "fullname")
  dob <- as.Date(page_variable(page_text, "dob"), format = "%Y%m%d")
  if (is.na(name) || is.na(dob)) {
    stop("Could not read the name and the date of birth from the player page.",
         call. = FALSE)
  }
  list(name = name, dob = dob)
}

#' Download the page of a player and read the name and the date of birth
#'
#' @param player Player name in the Tennis Abstract format, e.g. `"SerenaWilliams"`.
#' @return A list with the full `name` and the date of birth `dob`.
#' @noRd
fetch_player_profile <- function(player) {
  url <- player_page_url(player)
  response <- stop_if_http_error(http_get(url), url)
  parse_player_profile(response$body)
}
