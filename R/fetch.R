#' Download a web page
#'
#' This is the only function of the package that uses the network for the
#' career files, so the tests replace it with a function that does not.
#'
#' @param url Address of the page.
#' @return A list with the HTTP `status` (a number) and the `body` (text).
#' @noRd
http_get <- function(url) {
  req <- httr2::req_error(httr2::request(url), is_error = \(resp) FALSE)
  response <- tryCatch(
    httr2::req_perform(req),
    error = function(e) stop_unreachable(url, e)
  )
  body <- httr2::resp_body_string(response, encoding = "UTF-8")
  list(status = httr2::resp_status(response), body = body)
}

#' Stop with a message when the page cannot be reached
#' @param url Address of the page.
#' @param error Error from the failed request.
#' @noRd
stop_unreachable <- function(url, error) {
  stop("Could not reach ", url, ": ", conditionMessage(error), call. = FALSE)
}

#' Stop with a message if the HTTP status is an error
#' @param response List from `http_get()`.
#' @param url Address of the page, for the message.
#' @noRd
stop_if_http_error <- function(response, url) {
  if (response$status >= 400) {
    stop("Tennis Abstract answered with HTTP status ", response$status,
         " for ", url, ".", call. = FALSE)
  }
  invisible(response)
}

#' Download the text of the career JS file of a player
#'
#' Tennis Abstract answers with "404 Not Found" for a player that it does not
#' know, which gives the error message about the spelling of the name.
#'
#' @param player Player name in the Tennis Abstract format, e.g.
#'   `"SerenaWilliams"`.
#' @return The text of the file, as one string.
#' @noRd
fetch_career_js <- function(player) {
  url <- career_js_url(player)
  response <- http_get(url)
  if (response$status == 404) {
    stop("No career data found for \"", player, "\" on tennisabstract.com. ",
         "Check the spelling of the name.", call. = FALSE)
  }
  stop_if_http_error(response, url)$body
}
