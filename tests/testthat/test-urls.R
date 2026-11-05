test_that("career_js_url() points to the career file of the player", {
  expect_equal(
    career_js_url("SerenaWilliams"),
    "https://www.tennisabstract.com/jsmatches/SerenaWilliamsCareer.js"
  )
})

test_that("player_page_url() points to the page of the player", {
  expect_equal(
    player_page_url("RafaelNadal"),
    "https://www.tennisabstract.com/cgi-bin/player.cgi?p=RafaelNadal"
  )
})
