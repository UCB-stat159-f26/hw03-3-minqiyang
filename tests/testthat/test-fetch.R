# These tests replace http_get() with a function that does not use the network.
fake_http <- function(status, body = "") {
  function(url) list(status = status, body = body)
}

test_that("fetch_career_js() returns the text of the file", {
  js <- 'var morematchmx = [["a"]];'
  local_mocked_bindings(http_get = fake_http(200, js))
  expect_equal(fetch_career_js("SerenaWilliams"), js)
})

test_that("fetch_career_js() asks for the career file of the player", {
  asked <- NULL
  local_mocked_bindings(http_get = function(url) {
    asked <<- url
    list(status = 200, body = "x")
  })
  fetch_career_js("RafaelNadal")
  expect_equal(
    asked,
    "https://www.tennisabstract.com/jsmatches/RafaelNadalCareer.js"
  )
})

test_that("an unknown player gives an error about the spelling of the name", {
  local_mocked_bindings(http_get = fake_http(404, "<html>Not Found</html>"))
  expect_error(
    fetch_career_js("GastonSanchez"),
    'No career data found for "GastonSanchez"'
  )
  expect_error(fetch_career_js("GastonSanchez"), "Check the spelling")
})

test_that("other HTTP errors are reported with their status", {
  local_mocked_bindings(http_get = fake_http(503))
  expect_error(fetch_career_js("SerenaWilliams"), "HTTP status 503")
  expect_error(fetch_player_profile("SerenaWilliams"), "HTTP status 503")
})

test_that("stop_if_http_error() lets a good response pass", {
  response <- list(status = 200, body = "ok")
  expect_identical(stop_if_http_error(response, "https://x"), response)
})

test_that("fetch_player_profile() reads the name and the date of birth", {
  page <- read_fixture("SerenaWilliamsPage.html")
  local_mocked_bindings(http_get = fake_http(200, page))
  profile <- fetch_player_profile("SerenaWilliams")
  expect_equal(profile$name, "Serena Williams")
  expect_equal(profile$dob, as.Date("1981-09-26"))
})
