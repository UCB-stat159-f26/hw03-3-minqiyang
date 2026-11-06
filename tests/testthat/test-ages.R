test_that("age_in_years() divides the number of days by 365.25", {
  dob <- as.Date("1981-09-26")
  date <- as.Date("1995-10-30")
  expect_equal(age_in_years(dob, date), 5147 / 365.25)
})

test_that("age_in_years() works on vectors of dates", {
  dob <- as.Date("2000-01-01")
  dates <- as.Date(c("2010-01-01", "2020-01-01"))
  expect_equal(age_in_years(dob, dates), c(3653, 7305) / 365.25)
})

test_that("age_in_years() gives NA for a missing date", {
  expect_true(is.na(age_in_years(as.Date(NA), as.Date("2000-01-01"))))
})
