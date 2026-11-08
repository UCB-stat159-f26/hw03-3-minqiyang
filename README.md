# tenniscareer

- Author: Minqi (Minchee) Yang
- Course: STAT 159, Fall 2026, UC Berkeley
- Start date: 2026-11-05

## Overview

`tenniscareer` is an R package for HW 3 of STAT 159. It has two public
functions. `get_player_matches()` downloads the career matches of a tennis
player from [Tennis Abstract](https://www.tennisabstract.com/) and returns a
clean data frame. `plot_age_gap()` draws the scatter plot of HW 2 from that
data frame: the age of the player against the age gap with the opponent,
colored by win or loss, without the annotations of the New York Times chart.

## Install

The package is not on CRAN. Install it from GitHub with `pak` or with
`devtools`:

```r
pak::pak("UCB-stat159-f26/hw03-3-minqiyang")

# or
devtools::install_github("UCB-stat159-f26/hw03-3-minqiyang")
```

## Use

```r
library(tenniscareer)

# Serena Williams: data and plot
serena <- get_player_matches("serena williams")
plot_age_gap(serena)

# Rafael Nadal: data and plot
rafa <- get_player_matches("Rafael Nadal")
plot_age_gap(rafa)

# An unknown player gives an error
get_player_matches("Gaston Sanchez")
#> Error: No career data found for "GastonSanchez" on tennisabstract.com.
#> Check the spelling of the name.
```

`get_player_matches()` accepts the name as `"serena williams"`,
`"Serena Williams"` or `"SerenaWilliams"`. It returns a data frame with one
row for each match and these columns:

| Column         | Meaning                                              |
| -------------- | ---------------------------------------------------- |
| `player`       | Full name of the player                              |
| `date`         | Date of the match                                    |
| `tournament`   | Name of the tournament                               |
| `surface`      | Court surface: `Hard`, `Clay`, `Grass` or `Carpet`   |
| `result`       | `"win"` or `"loss"`, for the player                  |
| `score`        | Score of the match                                   |
| `opponent`     | Full name of the opponent                            |
| `player_age`   | Age of the player on the date of the match, in years |
| `opponent_age` | Age of the opponent on that date, in years           |
| `age_diff`     | `player_age` minus `opponent_age`                    |

`plot_age_gap()` returns a `ggplot` object. Each point is one match. The
x-axis is the age of the player. The y-axis is the age of the player minus
the age of the opponent, so a point above the line at 0 is a match against a
younger opponent. The color and the shape of a point show if the player won
or lost.
