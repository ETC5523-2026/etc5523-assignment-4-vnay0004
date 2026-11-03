#' Launch the WPL batting styles app
#'
#' Opens a Shiny app that helps a WPL franchise analyst find batters who
#' score quickly without wasting balls, and compare them with the rest of
#' the league in a chosen season.
#'
#' @return Called for its side effect of running the app.
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
#' @export
run_app <- function() {
  app_dir <- system.file("app", package = "a4")
  if (app_dir == "") {
    stop("Could not find the app. Try reinstalling the a4 package.",
         call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}