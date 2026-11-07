# httr2 answers with mock responses here, so these tests do not use the network.
mock_response <- function(status, body = raw(), headers = list()) {
  if (is.character(body)) {
    body <- charToRaw(enc2utf8(body))
  }
  httr2::response(status_code = status, headers = headers, body = body)
}

test_that("build_request() is set to try again, and keeps HTTP errors", {
  req <- build_request("https://example.test/page")
  expect_equal(req$policies$retry_max_tries, 4)
  expect_true(req$policies$retry_on_failure)
  expect_false(is.null(req$policies$retry_backoff))
})

test_that("http_get() gives the status and the text of the page", {
  httr2::local_mocked_responses(function(req) mock_response(200, "hello"))
  page <- http_get("https://example.test/a")
  expect_equal(page, list(status = 200L, body = "hello"))
})

test_that("http_get() gives an HTTP error as a status, not as an R error", {
  httr2::local_mocked_responses(function(req) mock_response(404, "Not Found"))
  page <- http_get("https://example.test/missing")
  expect_equal(page$status, 404L)
  expect_equal(page$body, "Not Found")
})

test_that("http_get() reads the text as UTF-8", {
  httr2::local_mocked_responses(
    function(req) mock_response(200, "Dušan Lajović")
  )
  expect_equal(http_get("https://example.test/a")$body, "Dušan Lajović")
})

test_that("http_get() gives a clear error when the site cannot be reached", {
  httr2::local_mocked_responses(function(req) stop("connection refused"))
  expect_error(
    http_get("https://example.test/a"),
    "Could not reach https://example.test/a: connection refused"
  )
})

test_that("response_text() gives an empty string for a response without body", {
  expect_equal(response_text(mock_response(429)), "")
  expect_equal(response_text(mock_response(200, "text")), "text")
})
