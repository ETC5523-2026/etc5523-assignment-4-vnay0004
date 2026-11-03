# Column names used inside dplyr verbs, declared so R CMD check
# does not report them as undefined global variables.
utils::globalVariables(c(
  "season", "balls_faced", "batting_team", "runs",
  "dot_percent", "boundary_percent",
  "median_dot_percent", "median_boundary_percent"
))
