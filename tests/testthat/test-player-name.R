test_that("the three spellings of a name give the same result", {
  expect_equal(normalize_player_name("serena williams"), "SerenaWilliams")
  expect_equal(normalize_player_name("Serena Williams"), "SerenaWilliams")
  expect_equal(normalize_player_name("SerenaWilliams"), "SerenaWilliams")
})

test_that("extra spaces and capital letters are removed", {
  expect_equal(normalize_player_name("  rafael   NADAL "), "RafaelNadal")
})

test_that("a name with more than two words is joined", {
  expect_equal(
    normalize_player_name("juan martin del potro"),
    "JuanMartinDelPotro"
  )
})

test_that("a name with one word only gets a capital first letter", {
  expect_equal(normalize_player_name("serenaWilliams"), "SerenaWilliams")
})
