test_that("the female mock file gives one row for each match", {
  rows <- parse_career_js(read_fixture("FemalePlayerCareer.js"))
  expect_length(rows, 3)
  expect_equal(rows[[1]][[12]], "Anne Miller")
  expect_equal(rows[[1]][[17]], "19770119")
})

test_that("the male mock file gives one row for each match", {
  rows <- parse_career_js(read_fixture("MalePlayerCareer.js"))
  expect_length(rows, 3)
  expect_equal(rows[[3]][[12]], "Israel Matos Gil")
  expect_equal(rows[[3]][[17]], "18.7597535934")
})

test_that("the text before the array and the final semicolon are ignored", {
  js <- 'var morematchmx = [["a", "b"],\n  ["c"]];\n'
  expect_equal(parse_career_js(js), list(list("a", "b"), list("c")))
})

test_that("a vector of lines is accepted", {
  lines <- c('var morematchmx = [["a"],', '["b"]];')
  expect_length(parse_career_js(lines), 2)
})

test_that("text without an array gives a clear error", {
  msg <- "does not have the expected format"
  expect_error(parse_career_js("<html>Not Found</html>"), msg)
  expect_error(parse_career_js(""), msg)
  expect_error(parse_career_js("var morematchmx = [];"), msg)
})
