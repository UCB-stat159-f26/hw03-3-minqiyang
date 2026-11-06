#' Age in years on a date
#'
#' The age is the number of days from the date of birth to the date, divided
#' by 365.25.
#'
#' @param dob Date of birth, a `Date` vector.
#' @param date Date on which the age is wanted, a `Date` vector.
#' @return A numeric vector with the age in years. It is `NA` when a date is
#'   `NA`.
#' @noRd
age_in_years <- function(dob, date) {
  as.numeric(date - dob) / 365.25
}
