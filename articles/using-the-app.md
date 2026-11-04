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
the league medians for the season, which split the chart into four
styles:

| Region | Style | Meaning |
|----|----|----|
| Upper-left | Attacking | More boundaries, fewer dot balls than the median |
| Lower-left | Rotator | Few boundaries, but keeps the strike moving |
| Upper-right | Boundary-reliant | Hits boundaries but faces many dots |
| Lower-right | Low tempo | Few boundaries and many dots |

Larger points faced more balls, so their percentages are more reliable.
The five leading run-scorers are labelled.

**The value boxes** summarise the current selection: how many batters
qualify, who scored most runs, and how many are attacking.

**The table** lists the ten leading run-scorers in the selection with
their rates and style.

## The same analysis without the app

[`batting_profile()`](https://etc5523-2026.github.io/etc5523-assignment-4-vnay0004/reference/batting_profile.md)
performs the calculation behind the app, so you can reproduce any view
in your own code:

``` r

profile_2025 <- batting_profile(wpl_batters, "2024/25", min_balls = 100)
head(profile_2025[, c("batter", "batting_team", "runs",
                      "dot_percent", "boundary_percent", "style")])
```

    ## # A tibble: 6 × 6
    ##   batter          batting_team           runs dot_percent boundary_percent style
    ##   <chr>           <chr>                 <int>       <dbl>            <dbl> <chr>
    ## 1 NR Sciver-Brunt Mumbai Indians          523        30               25.7 Atta…
    ## 2 EA Perry        Royal Challengers Be…   372        29.6             20.4 Atta…
    ## 3 HK Matthews     Mumbai Indians          307        48               20.4 Boun…
    ## 4 Shafali Verma   Delhi Capitals          304        42.7             25.1 Boun…
    ## 5 H Kaur          Mumbai Indians          302        36.4             25.1 Atta…
    ## 6 MM Lanning      Delhi Capitals          276        45.3             19.8 Low …

How many qualifying batters fall into each style?

``` r

table(profile_2025$style)
```

    ## 
    ##        Attacking Boundary-reliant        Low tempo          Rotator 
    ##                5                4                5                3

Which batters were attacking?

``` r

profile_2025$batter[profile_2025$style == "Attacking"]
```

    ## [1] "NR Sciver-Brunt" "EA Perry"        "H Kaur"          "A Gardner"      
    ## [5] "RM Ghosh"

## Interpreting a finding

✏️ *Write 2–4 sentences in your own words about something you noticed in
the app. For example: which batter stood out in a season, whether
attacking batters were also the top run-scorers, or whether a player’s
style changed between seasons. Refer to the numbers above.*

## Limitations

✏️ *Write 2–3 sentences in your own words. Points worth considering:*

- *the rates ignore batting position: openers face the new ball and
  powerplay fields, while finishers bat at the death;*
- *they ignore match situation and opposition strength;*
- *styles are relative to the season median, so “Low tempo” is not the
  same as “poor”;*
- *batters close to a dashed line could easily switch style with a few
  balls’ difference.*

## Data source

Data come from [Cricsheet](https://cricsheet.org), accessed through the
`cricketdata` package, and are used under the Open Data Commons
Attribution License (ODC-BY 1.0). The preparation script is
`data-raw/wpl_batters.R` in the package repository.
