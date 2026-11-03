## Code to prepare `wpl_batters` dataset
## Source: Cricsheet (https://cricsheet.org), accessed via the cricketdata package.
## Cricsheet data are released under the Open Data Commons Attribution License (ODC-BY).

options(timeout = 300)

# 1. Download ball-by-ball data for every Women's Premier League match
wpl_balls <- cricketdata::fetch_cricsheet(
  type = "bbb",
  gender = "female",
  competition = "wpl"
)

# 2. Flag what happened on each ball from the batter's point of view
wpl_balls <- wpl_balls |>
  dplyr::mutate(
    # A wide is not counted as a ball faced by the batter
    is_wide = !is.na(wides) & wides > 0,
    ball_faced = !is_wide,
    is_dot = ball_faced & runs_off_bat == 0,
    is_four = runs_off_bat == 4,
    is_six = runs_off_bat == 6,
    # cricketdata stores empty dismissals as "" rather than NA
    striker_out = !is.na(player_dismissed) &
      player_dismissed != "" &
      player_dismissed == striker
  )

# 3. Summarise to one row per batter per season (and team)
wpl_batters <- wpl_balls |>
  dplyr::group_by(season, batting_team, striker) |>
  dplyr::summarise(
    innings = dplyr::n_distinct(match_id),
    runs = sum(runs_off_bat, na.rm = TRUE),
    balls_faced = sum(ball_faced),
    dismissals = sum(striker_out),
    fours = sum(is_four),
    sixes = sum(is_six),
    dot_balls = sum(is_dot),
    .groups = "drop"
  ) |>
  dplyr::mutate(
    strike_rate = round(100 * runs / balls_faced, 1),
    dot_percent = round(100 * dot_balls / balls_faced, 1),
    boundary_percent = round(100 * (fours + sixes) / balls_faced, 1),
    average = dplyr::if_else(dismissals > 0, round(runs / dismissals, 1), NA_real_),
    season = as.character(season)
  ) |>
  # Keep batters with a meaningful sample so percentages are not misleading
  dplyr::filter(balls_faced >= 20) |>
  dplyr::rename(batter = striker) |>
  dplyr::arrange(season, dplyr::desc(runs))

# 4. Save into the package's data/ folder
usethis::use_data(wpl_batters, overwrite = TRUE)