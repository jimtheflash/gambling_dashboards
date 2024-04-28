ui <- fluidPage(
  titlePanel("Slam Dunk Prop Dashboard"),
  tags$head(
    tags$style(
      HTML("
        .rt-th {
        border-bottom: 2px solid rgba(0, 0, 0, 1);
      }
    ")
    )
  ),
  tabsetPanel(
    tabPanel("First Basket", reactableOutput("first_basket")),
    tabPanel("First Basket Exact", reactableOutput("first_basket_exact")),
    tabPanel("First Basket By Team", reactableOutput("first_basket_by_team")),
    tabPanel("First Basket By Team Exact", reactableOutput("first_basket_by_team_exact")),
    tabPanel("First Three", reactableOutput("first_three")),
    tabPanel("First Three By Team", reactableOutput("first_three_by_team")),
    tabPanel("First Team", reactableOutput("first_team")),
    tabPanel("First Team Exact", reactableOutput("first_team_exact")),
    tabPanel("Win Tipoff", reactableOutput("win_tipoff")),
    tabPanel("Not First Basket", reactableOutput("not_first_basket"))
  )
)
