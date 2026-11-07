test_that("page_variable() reads quoted and unquoted values", {
  page <- read_fixture("SerenaWilliamsPage.html")
  expect_equal(page_variable(page, "fullname"), "Serena Williams")
  expect_equal(page_variable(page, "dob"), "19810926")
  expect_equal(page_variable(page, "peakrank"), "1")
})

test_that("page_variable() keeps an apostrophe inside a name", {
  page <- "var fullname = 'Dominic O'Neil';"
  expect_equal(page_variable(page, "fullname"), "Dominic O'Neil")
})

test_that("page_variable() gives NA for a variable that is not there", {
  expect_true(is.na(page_variable("var dob = 19810926;", "fullname")))
})

test_that("parse_player_profile() gives the full name and the date of birth", {
  profile <- parse_player_profile(read_fixture("SerenaWilliamsPage.html"))
  expect_equal(profile$name, "Serena Williams")
  expect_equal(profile$dob, as.Date("1981-09-26"))
})

test_that("parse_player_profile() gives an error for a page without data", {
  expect_error(
    parse_player_profile("<html>Not a player page</html>"),
    "Could not read the name and the date of birth"
  )
})
