mock_matches <- function() {
  clean_career_matches(
    read_fixture("FemalePlayerCareer.js"),
    as.Date("1981-09-26"),
    "Serena Williams"
  )
}

test_that("plot_age_gap() returns a ggplot that can be built", {
  plot <- plot_age_gap(mock_matches())
  expect_s3_class(plot, "ggplot")
  expect_no_error(ggplot2::ggplot_build(plot))
  expect_no_warning(ggplot2::ggplot_build(plot))
})

test_that("the points are the player's age and the age difference", {
  matches <- mock_matches()
  points <- ggplot2::layer_data(plot_age_gap(matches), 2)
  expect_equal(nrow(points), 3)
  expect_equal(points$x, matches$player_age)
  expect_equal(points$y, matches$age_diff)
})

test_that("a line at 0 marks matches against opponents of the same age", {
  line <- ggplot2::layer_data(plot_age_gap(mock_matches()), 1)
  expect_equal(line$yintercept, 0)
})

test_that("the title and the axis names use the name of the player", {
  labels <- ggplot2::get_labs(plot_age_gap(mock_matches()))
  expect_equal(
    labels$title, "Serena Williams's Professional Matches, Age 14 to 15"
  )
  expect_equal(labels$x, "Serena Williams's age (years)")
  expect_equal(labels$y, "Age difference from opponent (years)")
})

test_that("wins come before losses in the legend", {
  plot <- plot_age_gap(mock_matches())
  expect_equal(levels(plot$data$result), c("win", "loss"))
})

test_that("the table of matches given by the user is not changed", {
  matches <- mock_matches()
  plot_age_gap(matches)
  expect_type(matches$result, "character")
})

test_that("a table that is not from get_player_matches() gives an error", {
  msg <- "must be a data frame from `get_player_matches()`"
  expect_error(plot_age_gap("Serena Williams"), msg, fixed = TRUE)
  expect_error(plot_age_gap(mock_matches()[0, ]), msg, fixed = TRUE)
  two_columns <- mock_matches()[, c("player", "result")]
  expect_error(plot_age_gap(two_columns), msg, fixed = TRUE)
})
