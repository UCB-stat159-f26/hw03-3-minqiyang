#' Cut the array of matches out of the text of a career JS file
#'
#' The file has one statement, `var morematchmx = [[...], [...]];`. This
#' function keeps the text from the first `[` to the last `]`, which is valid
#' JSON.
#'
#' @param js_text Text of the JS file, as one string or a vector of lines.
#' @return One character string with the JSON array.
#' @noRd
extract_js_array <- function(js_text) {
  js_text <- paste(js_text, collapse = "\n")
  sub("(?s)^[^\\[]*(\\[.*\\]).*$", "\\1", js_text, perl = TRUE)
}

#' Read the matches from the text of a career JS file
#'
#' The rows of the array have different lengths, so the result is a list with
#' one element for each match.
#'
#' @inheritParams extract_js_array
#' @return A list of matches. Each match is a list of character strings.
#' @noRd
parse_career_js <- function(js_text) {
  rows <- tryCatch(
    jsonlite::fromJSON(extract_js_array(js_text), simplifyVector = FALSE),
    error = function(e) NULL
  )
  if (!is.list(rows) || length(rows) == 0) {
    stop("The career file does not have the expected format.", call. = FALSE)
  }
  rows
}
