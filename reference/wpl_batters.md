# Women's Premier League batting summaries by season

Season-level batting statistics for every Women's Premier League (WPL)
batter who faced at least 20 balls in a season. Each row is one batter,
playing for one team, in one season. Values are derived from Cricsheet
ball-by-ball records; see `data-raw/wpl_batters.R` for the full
preparation steps.

## Usage

``` r
wpl_batters
```

## Format

A tibble with 185 rows and 14 columns:

- season:

  Season label used by Cricsheet, e.g. `"2022/23"`. Each WPL season is
  played early in the second calendar year (the `"2022/23"` season was
  played in 2023).

- batting_team:

  Franchise the batter played for.

- batter:

  Batter's name as recorded by Cricsheet (initials and surname).

- innings:

  Number of matches in which the batter faced at least one ball.

- runs:

  Total runs scored off the bat.

- balls_faced:

  Legal balls faced. Wides are excluded; no-balls are included.

- dismissals:

  Number of times the batter was dismissed.

- fours:

  Number of fours hit.

- sixes:

  Number of sixes hit.

- dot_balls:

  Balls faced from which the batter scored no runs.

- strike_rate:

  Runs per 100 balls faced.

- dot_percent:

  Percentage of balls faced that were dot balls.

- boundary_percent:

  Percentage of balls faced that were hit for four or six.

- average:

  Runs per dismissal. `NA` if the batter was never dismissed.

## Source

Cricsheet, <https://cricsheet.org>, accessed through the 'cricketdata'
package. Cricsheet data are made available under the Open Data Commons
Attribution License (ODC-BY 1.0).

## Details

Batters who faced fewer than 20 balls in a season are excluded, because
their percentages are based on too few balls to be reliable. A batter
who changed teams within a season would appear once per team.

## Examples

``` r
head(wpl_batters)
#> # A tibble: 6 × 14
#>   season  batting_team   batter innings  runs balls_faced dismissals fours sixes
#>   <chr>   <chr>          <chr>    <int> <int>       <int>      <int> <int> <int>
#> 1 2022/23 Delhi Capitals MM La…       9   345         248          6    50     6
#> 2 2022/23 Mumbai Indians NR Sc…      10   332         237          5    47     6
#> 3 2022/23 UP Warriorz    TM Mc…       8   302         191          5    46     7
#> 4 2022/23 Mumbai Indians H Kaur       9   281         208          7    44     3
#> 5 2022/23 Mumbai Indians HK Ma…      10   271         215          9    33    10
#> 6 2022/23 Royal Challen… SFM D…       8   266         154          8    32    13
#> # ℹ 5 more variables: dot_balls <int>, strike_rate <dbl>, dot_percent <dbl>,
#> #   boundary_percent <dbl>, average <dbl>
table(wpl_batters$season)
#> 
#> 2022/23 2023/24 2024/25 2025/26 
#>      48      44      48      45 
```
