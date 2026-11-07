#' Make the request for a page
#'
#' Tennis Abstract answers with HTTP 429 (too many requests) or 503 when it
#' gets many requests in a short time. The request is also tried again when
#' the connection fails. It is tried up to 4 times, after a wait of 2, 4 and 8
#' seconds, or the wait that the site asks for. An HTTP error is not an R
#' error here, because the caller reads the status.
#'
#' @param url Address of the page.
#' @return A `httr2` request.
#' @noRd
build_request <- function(url) {
  req <- httr2::req_error(httr2::request(url), is_error = \(resp) FALSE)
  httr2::req_retry(
    req, max_tries = 4, retry_on_failure = TRUE, backoff = \(i) 2^i
  )
}

#' Download a web page
#'
#' This is the only function of the package that uses the network for the
#' career files, so the tests replace it with a function that does not.
#'
#' @param url Address of the page.
#' @return A list with the HTTP `status` (a number) and the `body` (text).
#' @noRd
http_get <- function(url) {
  response <- tryCatch(
    httr2::req_perform(build_request(url)),
    error = function(e) stop_unreachable(url, e)
  )
  list(status = httr2::resp_status(response), body = response_text(response))
}

#' Text of the body of a response, or an empty string if it has no body
#' @param response A `httr2` response.
#' @noRd
response_text <- function(response) {
  if (!httr2::resp_has_body(response)) {
    return("")
  }
  httr2::resp_body_string(response, encoding = "UTF-8")
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
