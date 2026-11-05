#' Read a mock career JS file from tests/testthat/fixtures as one string
read_fixture <- function(name) {
  paste(readLines(test_path("fixtures", name), warn = FALSE), collapse = "\n")
}
