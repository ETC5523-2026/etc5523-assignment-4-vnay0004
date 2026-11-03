#' Women's Premier League batting summaries by season
#'
#' Season-level batting statistics for every Women's Premier League (WPL)
#' batter who faced at least 20 balls in a season. Each row is one batter,
#' playing for one team, in one season. Values are derived from Cricsheet
#' ball-by-ball records; see `data-raw/wpl_batters.R` for the full
#' preparation steps.
#'
#' @format A tibble with 185 rows and 14 columns:
#' \describe{
#'   \item{season}{Season label used by Cricsheet, e.g. `"2022/23"`. Each
#'     WPL season is played early in the second calendar year
#'     (the `"2022/23"` season was played in 2023).}
#'   \item{batting_team}{Franchise the batter played for.}
#'   \item{batter}{Batter's name as recorded by Cricsheet (initials and surname).}
#'   \item{innings}{Number of matches in which the batter faced at least one ball.}
#'   \item{runs}{Total runs scored off the bat.}
#'   \item{balls_faced}{Legal balls faced. Wides are excluded; no-balls are included.}
#'   \item{dismissals}{Number of times the batter was dismissed.}
#'   \item{fours}{Number of fours hit.}
#'   \item{sixes}{Number of sixes hit.}
#'   \item{dot_balls}{Balls faced from which the batter scored no runs.}
#'   \item{strike_rate}{Runs per 100 balls faced.}
#'   \item{dot_percent}{Percentage of balls faced that were dot balls.}
#'   \item{boundary_percent}{Percentage of balls faced that were hit for four or six.}
#'   \item{average}{Runs per dismissal. `NA` if the batter was never dismissed.}
#' }
#'
#' @details Batters who faced fewer than 20 balls in a season are excluded,
#'   because their percentages are based on too few balls to be reliable.
#'   A batter who changed teams within a season would appear once per team.
#'
#' @source Cricsheet, <https://cricsheet.org>, accessed through the
#'   'cricketdata' package. Cricsheet data are made available under the
#'   Open Data Commons Attribution License (ODC-BY 1.0).
#'
#' @examples
#' head(wpl_batters)
#' table(wpl_batters$season)
"wpl_batters"
