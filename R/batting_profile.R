#' Profile batters' scoring styles within a WPL season
#'
#' Selects batters from one season who faced at least `min_balls` balls,
#' compares each batter's dot-ball and boundary percentages with the median
#' of all qualifying batters in that season, and labels their scoring style.
#' The comparison is always made against the whole league, even when the
#' result is limited to one team.
#'
#' @param data A data frame with the same columns as [wpl_batters].
#' @param chosen_season A season label, such as `"2024/25"`. Must appear in
#'   `data$season`.
#' @param chosen_team A team name, or `NULL` (the default) to keep all teams.
#' @param min_balls Minimum number of balls faced for a batter to be included.
#'
#' @return A tibble with one row per qualifying batter, containing the
#'   original columns plus:
#'   \describe{
#'     \item{median_dot_percent, median_boundary_percent}{League medians for
#'       the season, among batters meeting `min_balls`.}
#'     \item{style}{One of `"Attacking"` (more boundaries, fewer dots than the
#'       median), `"Rotator"` (fewer boundaries, fewer dots),
#'       `"Boundary-reliant"` (more boundaries, more dots) or `"Low tempo"`
#'       (fewer boundaries, more dots).}
#'   }
#'   The tibble has zero rows if no batter meets the conditions.
#'
#' @examples
#' # All qualifying batters in the 2024/25 season
#' batting_profile(wpl_batters, "2024/25")
#'
#' # Only Mumbai Indians batters who faced at least 100 balls
#' batting_profile(wpl_batters, "2024/25",
#'                 chosen_team = "Mumbai Indians", min_balls = 100)
#'
#' @importFrom dplyr filter mutate arrange desc case_when
#' @importFrom stats median
#' @export
batting_profile <- function(data, chosen_season, chosen_team = NULL,
                            min_balls = 20) {
  if (!chosen_season %in% data$season) {
    stop("`chosen_season` must be one of: ",
         paste(sort(unique(data$season)), collapse = ", "), call. = FALSE)
  }

  # League benchmark: every qualifying batter in the season, all teams
  season_data <- data |>
    filter(season == chosen_season, balls_faced >= min_balls)

  profiled <- season_data |>
    mutate(
      median_dot_percent = median(dot_percent),
      median_boundary_percent = median(boundary_percent),
      style = case_when(
        boundary_percent >= median_boundary_percent &
          dot_percent < median_dot_percent ~ "Attacking",
        boundary_percent < median_boundary_percent &
          dot_percent < median_dot_percent ~ "Rotator",
        boundary_percent >= median_boundary_percent ~ "Boundary-reliant",
        TRUE ~ "Low tempo"
      )
    )

  # Narrow to one team only after the league benchmark is calculated
  if (!is.null(chosen_team)) {
    profiled <- profiled |> filter(batting_team == chosen_team)
  }

  profiled |> arrange(desc(runs))
}
