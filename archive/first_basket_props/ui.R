ui <-
  fluidPage(
    titlePanel('NBA First Basket Props!'),
    br(),
    p('Thanks for using the dashboard! My partners and I at Slam Dunk Betting Services are getting ready to launch some pretty cool new tools, and this dashboard will be moving soon. If you have interest in learning more, hit me up @jimtheflash or jim.kloet@gmail.com, and I will point you in the right direction! Thanks again!'),
    br(),
    fluidRow(
      column(
        width = 12,
        tabsetPanel(
# first player to score tab -----------------------------------------------
          tabPanel('First Player to Score',
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       em(textOutput('fpts_ts')))),
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       reactableOutput('fpts_table')))),
# first player to score by team tab ---------------------------------------
          tabPanel('First Player to Score by Team',
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       em(textOutput('fpts_team_ts')))),
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       reactableOutput('fpts_team_table')))),
# first player to score exact tab -----------------------------------------
          tabPanel('First Player to Score Exact',
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       em(textOutput('fpts_exact_ts')))),
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       reactableOutput('fpts_exact_table')))),
# first player to score by team exact tab ---------------------------------
tabPanel('First Player to Score By Team Exact',
         br(),
         fluidRow(
           column(
             width = 12,
             em(textOutput('fpts_team_exact_ts')))),
         br(),
         fluidRow(
           column(
             width = 12,
             reactableOutput('fpts_team_exact_table')))),
# first three tab -----------------------------------------------
tabPanel('First Three',
         br(),
         fluidRow(
           column(
             width = 12,
             em(textOutput('first_three_ts')))),
         br(),
         fluidRow(
           column(
             width = 12,
             reactableOutput('first_three_table')))),
# first three by team tab ---------------------------------------
tabPanel('First Three by Team',
         br(),
         fluidRow(
           column(
             width = 12,
             em(textOutput('first_three_team_ts')))),
         br(),
         fluidRow(
           column(
             width = 12,
             reactableOutput('first_three_team_table')))),
# first team to score tab -------------------------------------------------
          tabPanel('First Team to Score',
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       em(textOutput('ftts_ts')))),
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       reactableOutput('ftts_table')))),
# first team to score exact tab -------------------------
          tabPanel('First Team to Score Exact',
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       em(textOutput('ftts_exact_ts')))),
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       reactableOutput('ftts_exact_table')))),
# win tip -----------------------------------------------
          tabPanel('Win Tipoff',
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       em(textOutput('win_tip_ts')))),
                   br(),
                   fluidRow(
                     column(
                       width = 12,
                       reactableOutput('win_tip_table'))))))))
