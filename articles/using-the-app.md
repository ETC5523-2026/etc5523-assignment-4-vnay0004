# Using the WPL batting styles app

## Who this package is for

`a4` helps a **WPL franchise analyst preparing for the player auction**
answer one question:

> In a given season, which batters score quickly without wasting balls,
> and how do they compare with the rest of the league?

The package contains:

- `wpl_batters`: season-level batting summaries for every Women’s
  Premier League batter who faced at least 20 balls in a season;
- [`batting_profile()`](https://etc5523-2026.github.io/etc5523-assignment-4-vnay0004/reference/batting_profile.md):
  a function that compares batters with the league median for a season
  and labels their scoring style; and
- [`run_app()`](https://etc5523-2026.github.io/etc5523-assignment-4-vnay0004/reference/run_app.md):
  an interactive Shiny app built on the two above.

## Installation

Install the package from GitHub:

``` r

# install.packages("remotes")
remotes::install_github("ETC5523-2026/etc5523-assignment-4-vnay0004")
```

Then load it:

``` r

library(a4)
```

## Launching the app

``` r

run_app()
```

The app opens in your browser or in your IDE’s viewer.

## Using the controls

| Control | What it does |
|----|----|
| **Season** | Chooses which WPL season to analyse. Cricsheet labels seasons like `2024/25`; that season was played in early 2025. |
| **Team** | Shows only one franchise’s batters. They are still compared with the *whole league’s* medians. |
| **Minimum balls faced** | Excludes batters with small samples. Raise it when you want only established batters. |

A suggested workflow for an analyst:

1.  Choose the most recent season and leave **Team** on *All teams*.
2.  Set **Minimum balls faced** to about 100 to focus on regular
    batters.
3.  Look in the **upper-left** of the chart for attacking batters.
4.  Switch to an earlier season to see whether those batters were
    consistent.
5.  Select your own franchise to see where your current batters sit.

## Reading the outputs

**The scatter plot** places each batter by dot-ball percentage
(horizontal) and boundary percentage (vertical). The dashed lines are
the league medians for the season, which
