# The site is replaced by mock files, so these tests do not use the network.
fake_site <- function(career_js, page) {
  function(url) {
    body <- if (grepl("/jsmatches/", url, fixed = TRUE)) career_js else page
    list(status = 200, body = body)
  }
}

serena_page <- function() read_fixture("SerenaWilliamsPage.html")

nadal_page <- function() {
  page <- gsub("Serena Williams", "Rafael Nadal", serena_page(), fixed = TRUE)
  sub("19810926", "19860603", page, fixed = TRUE)
}

test_that("a female player gives a clean data frame", {
  site <- fake_site(read_fixture("FemalePlayerCareer.js"), serena_page())
  local_mocked_bindings(http_get = site)
  serena <- get_player_matches("serena williams")
  expect_named(serena, match_columns)
  expect_equal(nrow(serena), 3)
  expect_equal(unique(serena$player), "Serena Williams")
  expect_equal(serena$opponent[2], "Alexia Dechaume Balleret")
})

test_that("a male player gives a clean data frame", {
  site <- fake_site(read_fixture("MalePlayerCareer.js"), nadal_page())
  local_mocked_bindings(http_get = site)
  rafa <- get_player_matches("Rafael Nadal")
  expect_named(rafa, match_columns)
  expect_equal(nrow(rafa), 3)
  expect_equal(unique(rafa$player), "Rafael Nadal")
  expect_equal(rafa$opponent_age[2], 24.2902121834)
})

test_that("the three spellings of a name ask for the same files", {
  asked <- character()
  local_mocked_bindings(http_get = function(url) {
    asked <<- c(asked, url)
    fake_site(read_fixture("FemalePlayerCareer.js"), serena_page())(url)
  })
  for (name in c("serena williams", "Serena Williams", "SerenaWilliams")) {
    get_player_matches(name)
  }
  expect_length(unique(asked), 2)
  expect_true(all(grepl("SerenaWilliams", asked, fixed = TRUE)))
})

test_that("an unknown player gives a meaningful error", {
  local_mocked_bindings(
    http_get = function(url) list(status = 404, body = "<html>Not Found</html>")
  )
  expect_error(
    get_player_matches("Gaston Sanchez"),
    'No career data found for "GastonSanchez"'
  )
})

test_that("a bad name is rejected before any download", {
  local_mocked_bindings(http_get = function(url) stop("the network was used"))
  expect_error(get_player_matches(""), "non-empty character string")
  expect_error(get_player_matches(NULL), "non-empty character string")
})
