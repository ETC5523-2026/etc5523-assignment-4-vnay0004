# Profile batters' scoring styles within a WPL season

Selects batters from one season who faced at least `min_balls` balls,
compares each batter's dot-ball and boundary percentages with the median
of all qualifying batters in that season, and labels their scoring
style. The comparison is always made against the whole league, even when
the result is limited to one team.

## Usage

``` r
batting_profile(data, chosen_season, chosen_team = NULL, min_balls = 20)
```

## Arguments

- data:

  A data frame with the same columns as
  [wpl_batters](https://etc5523-2026.github.io/etc5523-assignment-4-vnay0004/reference/wpl_batters.md).

- chosen_season:

  A season label, such as `"2024/25"`. Must appear in `data$season`.

- chosen_team:

  A team name, or `NULL` (the default) to keep all teams.

- min_balls:

  Minimum number of balls faced for a batter to be included.

## Value

A tibble with one row per qualifying batter, containing the original
columns plus:

- median_dot_percent, median_boundary_percent:

  League medians for the season, among batters meeting `min_balls`.

- style:

  One of `"Attacking"` (more boundaries, fewer dots than the median),
  `"Rotator"` (fewer boundaries, fewer dots), `"Boundary-reliant"` (more
  boundaries, more dots) or `"Low tempo"` (fewer boundaries, more dots).

The tibble has zero rows if no batter meets the conditions.

## Examples

``` r
# All qualifying batters in the 2024/25 season
batting_profile(wpl_batters, "2024/25")
#> # A tibble: 48 × 17
#>    season  batting_team  batter innings  runs balls_faced dismissals fours sixes
#>    <chr>   <chr>         <chr>    <int> <int>       <int>      <int> <int> <int>
#>  1 2024/25 Mumbai India… NR Sc…      10   523         343          8    84     4
#>  2 2024/25 Royal Challe… EA Pe…       8   372         250          4    40    11
#>  3 2024/25 Mumbai India… HK Ma…      10   307         250         10    42     9
#>  4 2024/25 Delhi Capita… Shafa…       9   304         199          8    34    16
#>  5 2024/25 Mumbai India… H Kaur      10   302         195          9    38    11
#>  6 2024/25 Delhi Capita… MM La…       9   276         232          8    45     1
#>  7 2024/25 Gujarat Gian… A Gar…       9   243         148          8    17    18
#>  8 2024/25 Gujarat Gian… BL Mo…       9   237         185          8    37     0
#>  9 2024/25 Gujarat Gian… H Deol       9   232         192          5    32     1
#> 10 2024/25 Royal Challe… RM Gh…       8   232         134          6    25    13
#> # ℹ 38 more rows
#> # ℹ 8 more variables: dot_balls <int>, strike_rate <dbl>, dot_percent <dbl>,
#> #   boundary_percent <dbl>, average <dbl>, median_dot_percent <dbl>,
#> #   median_boundary_percent <dbl>, style <chr>

# Only Mumbai Indians batters who faced at least 100 balls
batting_profile(wpl_batters, "2024/25",
                chosen_team = "Mumbai Indians", min_balls = 100)
#> # A tibble: 3 × 17
#>   season  batting_team   batter innings  runs balls_faced dismissals fours sixes
#>   <chr>   <chr>          <chr>    <int> <int>       <int>      <int> <int> <int>
#> 1 2024/25 Mumbai Indians NR Sc…      10   523         343          8    84     4
#> 2 2024/25 Mumbai Indians HK Ma…      10   307         250         10    42     9
#> 3 2024/25 Mumbai Indians H Kaur      10   302         195          9    38    11
#> # ℹ 8 more variables: dot_balls <int>, strike_rate <dbl>, dot_percent <dbl>,
#> #   boundary_percent <dbl>, average <dbl>, median_dot_percent <dbl>,
#> #   median_boundary_percent <dbl>, style <chr>
```
