ui <-
  fluidPage(
    titlePanel('NBA First Basket Props!'),
    br(),
    p(em('To update the data, clear your browser cache and refresh the page. Projections are updated a couple times an hour, and more frequently closer to tipoff.')),
    br(),
    fluidRow(column(width = 6,
                    bsCollapse(
                      bsCollapsePanel(
                        title = 'Global Filters & Settings',
                        fluidRow(column(width = 12, p(em('Adjustments made here apply to all of the tabs below.')))),
                        fluidRow(column(width = 4, numericInput('unitsize', 'Unit Size ($)', value = 1, step = 1)),
                                 column(width = 4, numericInput('minedge', 'Minimum Edge (%)', value = -1, min = -Inf, max = Inf))),
                        # fluidRow(),
                        fluidRow(column(width = 12, checkboxInput('bestodds', 'Only show books with best odds for each bet?', value = TRUE, width = "100%"))))))),
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
# # first player to score by points by points tab ---------------------------
# tabPanel('First Player to Score By Points',
#          br(),
#          fluidRow(
#            column(
#              width = 12,
#              em(textOutput('fpts_ts')))),
#          br(),
#          fluidRow(
#            column(
#              width = 12,
#              reactableOutput('fpts_table')))),
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
                       reactableOutput('ftts_table'))))))))
