library(shiny)
library(bslib)
library(ggplot2)
library(a4)   # data and batting_profile() come from the installed package

# ---- Settings shared by every user session ----------------------------------

seasons <- sort(unique(wpl_batters$season))
teams <- sort(unique(wpl_batters$batting_team))

# Colour-blind-safe palette (Okabe-Ito), with shapes so colour is not the only cue
style_colours <- c(
  "Attacking"        = "#D55E00",
  "Boundary-reliant" = "#E69F00",
  "Rotator"          = "#0072B2",
  "Low tempo"        = "#999999"
)
style_shapes <- c(
  "Attacking" = 16, "Boundary-reliant" = 17, "Rotator" = 15, "Low tempo" = 1
)

app_theme <- bs_theme(
  version = 5,
  primary = "#1F3A5F",
  secondary = "#5C6B7A",
  base_font = font_collection("Helvetica Neue", "Arial", "sans-serif"),
  heading_font = font_collection("Helvetica Neue", "Arial", "sans-serif")
)

# ---- User interface ----------------------------------------------------------

ui <- page_sidebar(
  title = "WPL batting styles: who scores quickly without wasting balls?",
  theme = app_theme,

  sidebar = sidebar(
    width = 310,
    selectInput("season", "Season", choices = seasons,
                selected = tail(seasons, 1)),
    helpText("Cricsheet labels seasons like 2024/25. That season was played in early 2025."),

    selectInput("team", "Team", choices = c("All teams", teams)),
    helpText("Focus on one franchise. Batters are still compared with the whole league."),

    sliderInput("min_balls", "Minimum balls faced",
                min = 20, max = 300, value = 50, step = 10),
    helpText("Raise this to exclude small samples, whose percentages can be misleading.")
  ),

  card(
    card_header("Who this app is for"),
    p(strong("User: "), "a WPL franchise analyst preparing for the player auction."),
    p(strong("Question: "), "In a given season, which batters score quickly without",
      "wasting balls, and how do they compare with the rest of the league?")
  ),

  layout_columns(
    value_box(title = "Batters shown", value = textOutput("n_shown"),
              theme = "primary"),
    value_box(title = "Leading run-scorer", value = textOutput("leader"),
              theme = "secondary"),
    value_box(title = "Attacking batters", value = textOutput("n_attacking"),
              theme = value_box_theme(bg = "#D55E00", fg = "#FFFFFF"))
  ),

  layout_columns(
    col_widths = c(8, 4),
    card(
      full_screen = TRUE,
      card_header(textOutput("plot_title")),
      plotOutput("style_plot", height = "480px"),
      textOutput("sample_note"),
      card_footer("Dashed lines show the league median for the selected season,",
                  "among batters who meet the minimum balls faced.")
    ),
    card(
      card_header("How to read this chart"),
      tags$ul(
        tags$li(strong("Upper-left"), " = attacking: more boundaries and fewer dot",
                " balls than the league median. These batters score quickly",
                " without wasting balls."),
        tags$li(strong("Lower-left"), " = rotators: few boundaries, but keep the strike moving."),
        tags$li(strong("Upper-right"), " = boundary-reliant: hit boundaries but face many dots."),
        tags$li(strong("Lower-right"), " = low tempo: few boundaries and many dots."),
        tags$li("Larger points faced more balls, so their percentages are more reliable."),
        tags$li("The five leading run-scorers in the selection are labelled.")
      ),
      h6("Fields"),
      tags$ul(
        tags$li(strong("Dot-ball %:"), " share of balls faced with no runs scored."),
        tags$li(strong("Boundary %:"), " share of balls faced hit for four or six."),
        tags$li(strong("Strike rate:"), " runs per 100 balls faced.")
      )
    )
  ),

  card(
    card_header("Leading run-scorers in this selection"),
    tableOutput("top_table"),
    card_footer(
      "Limitations: these rates ignore batting position, match situation and",
      "opposition strength. Data: Cricsheet (cricsheet.org) via the cricketdata",
      "package, ODC-BY licence."
    )
  )
)

# ---- Server ------------------------------------------------------------------

server <- function(input, output, session) {

  # One shared calculation feeds every output
  profiled <- reactive({
    team <- if (input$team == "All teams") NULL else input$team
        a4::batting_profile(a4::wpl_batters, input$season,
                    chosen_team = team, min_balls = input$min_balls)
  }, label = "profiled")

  output$n_shown <- renderText(nrow(profiled()))

  output$leader <- renderText({
    p <- profiled()
    if (nrow(p) == 0) return("None qualify")
    paste0(p$batter[1], " (", p$runs[1], " runs)")
  })

  output$n_attacking <- renderText(sum(profiled()$style == "Attacking"))

  output$plot_title <- renderText({
    who <- if (input$team == "All teams") "All teams" else input$team
    paste0(who, ", ", input$season, ": batters facing at least ",
           input$min_balls, " balls")
  })

  output$style_plot <- renderPlot({
    p <- profiled()
    validate(need(
      nrow(p) > 0,
      paste0("No batters in this selection faced at least ", input$min_balls,
             " balls. Try lowering the minimum balls faced or choosing All teams.")
    ))

    top_five <- head(p, 5)

    ggplot(p, aes(dot_percent, boundary_percent)) +
      geom_vline(xintercept = p$median_dot_percent[1],
                 linetype = "dashed", colour = "grey55") +
      geom_hline(yintercept = p$median_boundary_percent[1],
                 linetype = "dashed", colour = "grey55") +
      geom_point(aes(colour = style, shape = style, size = balls_faced),
                 alpha = 0.85, stroke = 1.2) +
      geom_text(data = top_five, aes(label = batter),
                vjust = -1.2, size = 4, colour = "#1F3A5F") +
      scale_colour_manual(values = style_colours, limits = names(style_colours)) +
      scale_shape_manual(values = style_shapes, limits = names(style_shapes)) +
      scale_size(range = c(2, 9)) +
      scale_x_continuous(labels = function(x) paste0(x, "%")) +
      scale_y_continuous(labels = function(x) paste0(x, "%")) +
      labs(x = "Dot-ball percentage (lower is better)",
           y = "Boundary percentage (higher is better)",
           colour = "Batting style", shape = "Batting style",
           size = "Balls faced") +
      theme_minimal(base_size = 15) +
      theme(legend.position = "bottom", legend.box = "vertical",
            panel.grid.minor = element_blank())
  })

  # Weak state: very few batters make the medians and styles unstable
  output$sample_note <- renderText({
    n <- nrow(profiled())
    if (n > 0 && n < 5) {
      paste("Only", n, "batter(s) meet these conditions. Treat the styles with",
            "caution, or lower the minimum balls faced.")
    } else {
      ""
    }
  })

  output$top_table <- renderTable({
    p <- profiled()
    validate(need(nrow(p) > 0, "No batters to show for this selection."))
    p <- head(p, 10)
    data.frame(
      Batter = p$batter,
      Team = p$batting_team,
      Runs = p$runs,
      `Balls faced` = p$balls_faced,
      `Strike rate` = p$strike_rate,
      `Dot %` = p$dot_percent,
      `Boundary %` = p$boundary_percent,
      Style = p$style,
      check.names = FALSE
    )
  }, digits = 1, striped = TRUE, hover = TRUE)
}

shinyApp(ui, server)