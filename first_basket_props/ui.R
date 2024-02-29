ui <-
  fluidPage(
    titlePanel('NBA First Basket Props!'),
    br(),
    bsCollapse(
      bsCollapsePanel(
        title = 'Instructions (Click To Expand)',
        p(em('Thanks for taking a look! The projections are from a set of ML tools, and the odds are directly from the books. The edges shown here are the simple difference between the projected and offered odds. A positive edge is a value, and a negative edge indicates a bet is overpriced per our models.')),
        br(),
        p(em('Tables are sortable and filterable; to sort by multiple columns hold the Shift key. Table rows are grouped by player and team for non-exact bets; you can click a row and expand to see the odds for that player in the specific books. For exact bets, there are not any groups.')),
        br(),
        p(em('To update the data, clear your browser cache and refresh the page. Projections are updated a couple times an hour, based on the latest odds we pull and any lineup changes.'))),
      open = TRUE),


    # br(),
    # fluidRow(column(width = 6,
    #                 bsCollapse(
    #                   bsCollapsePanel(
    #                     title = 'Global Filters & Settings',
    #                     fluidRow(column(width = 12, p(em('Adjustments made here apply to all of the tabs below.')))),
    #                     fluidRow(column(width = 4, numericInput('unitsize', 'Unit Size ($)', value = 1, step = 1)),
    #                              column(width = 4, numericInput('minedge', 'Minimum Edge (%)', value = -1, min = -Inf, max = Inf))),
    #                     # fluidRow(),
    #                     fluidRow(column(width = 12, checkboxInput('bestodds', 'Only show books with best odds for each bet?', value = TRUE, width = "100%"))))))),
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
tabPanel('First Team to Score Exact'),
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
