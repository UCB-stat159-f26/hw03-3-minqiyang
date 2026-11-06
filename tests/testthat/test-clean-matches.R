serena_dob <- as.Date("1981-09-26")

clean_female_mock <- function() {
  clean_career_matches(
    read_fixture("FemalePlayerCareer.js"), serena_dob, "Serena Williams"
  )
}

test_that("a female career gives one row for each match with the right columns", {
  matches <- clean_female_mock()
  expect_s3_class(matches, "data.frame")
  expect_equal(nrow(matches), 3)
  expect_named(matches, match_columns)
  expect_s3_class(matches$date, "Date")
})

test_that("the fields of a female match are read from the right positions", {
  first <- clean_female_mock()[1, ]
  expect_equal(first$player, "Serena Williams")
  expect_equal(first$date, as.Date("1995-10-30"))
  expect_equal(first$tournament, "Canadian Open")
  expect_equal(first$surface, "Carpet")
  expect_equal(first$result, "loss")
  expect_equal(first$score, "6-1 6-1")
  expect_equal(first$opponent, "Anne Miller")
})

test_that("the age of a female opponent comes from her date of birth", {
  first <- clean_female_mock()[1, ]
  days_old <- as.numeric(as.Date("1995-10-30") - as.Date("1977-01-19"))
  expect_equal(first$opponent_age, days_old / 365.25)
})

test_that("the ages of the player and the age difference are computed", {
  first <- clean_female_mock()[1, ]
  days_old <- as.numeric(as.Date("1995-10-30") - serena_dob)
  expect_equal(first$player_age, days_old / 365.25)
  expect_equal(first$age_diff, first$player_age - first$opponent_age)
})

nadal_dob <- as.Date("1986-06-03")

clean_male_mock <- function(js = read_fixture("MalePlayerCareer.js")) {
  clean_career_matches(js, nadal_dob, "Rafael Nadal")
}

test_that("the age of a male opponent is taken from the file", {
  matches <- clean_male_mock()
  expect_equal(nrow(matches), 3)
  expect_equal(matches$opponent_age[1], 22.264202601)
  expect_equal(matches$opponent_age[3], 18.7597535934)
  expect_equal(matches$result, c("loss", "loss", "win"))
})

test_that("the age of a male player is computed from his date of birth", {
  first <- clean_male_mock()[1, ]
  days_old <- as.numeric(as.Date("2001-09-10") - nadal_dob)
  expect_equal(first$player_age, days_old / 365.25)
  expect_equal(first$age_diff, first$player_age - 22.264202601)
})

test_that("a walkover is removed", {
  js <- sub("6-4 6-4", "W/O", read_fixture("MalePlayerCareer.js"), fixed = TRUE)
  matches <- clean_male_mock(js)
  expect_equal(nrow(matches), 2)
  expect_false("W/O" %in% matches$score)
})

test_that("a match without an age for the opponent is removed", {
  js <- sub("18.7597535934", "", read_fixture("MalePlayerCareer.js"), fixed = TRUE)
  matches <- clean_male_mock(js)
  expect_equal(nrow(matches), 2)
  expect_false(anyNA(matches$age_diff))
})

test_that("has_birth_dates() tells dates of birth from ages", {
  expect_true(has_birth_dates(c("19770119", "19700503")))
  expect_true(has_birth_dates(c("19770119", "")))
  expect_false(has_birth_dates(c("22.264202601", "24.2902121834")))
  expect_false(has_birth_dates(c("", "")))
})
