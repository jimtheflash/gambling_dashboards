ui <- fluidPage(
  h1('NBA First Basket Props!'),
  br(),
  fluidRow(
    column(
      width = 2,
      actionButton('updateButton', h5('Update Data'))
    )),
  br(),
  fluidRow(
    column(
      width = 3,
      checkboxGroupInput('checkboxes', h5('Global Filters'),
                         choices = list('Show only best edges?' = 'best_edges',
                                        'Hide edges < 0%?' = 'pos_edges'),
                         selected = 'best_edges')
    )),
  br(),
  fluidRow(
    column(
      width = 12,
      tabsetPanel(
        tabPanel('First Player to Score',
                 br(),
                 fluidRow(
                   column(
                     width = 12,
                     em(textOutput('fpts_ts'))
                   )
                 ),
                 br(),
                 fluidRow(
                   column(
                     width = 12,
                     reactableOutput('fpts_table')))),
        tabPanel('First Player to Score by Team',
                 br(),
                 fluidRow(
                   column(
                     width = 12,
                     em(textOutput('fpts_team_ts'))
                   )
                 ),
                 br(),
                 fluidRow(
                   column(
                     width = 12,
                     reactableOutput('fpts_team_table')))),
        tabPanel('First Team to Score',
                 br(),
                 fluidRow(
                   column(
                     width = 12,
                     em(textOutput('ftts_ts'))
                   )
                 ),
                 br(),
                 fluidRow(
                   column(
                     width = 12,
                     reactableOutput('ftts_table')))))
      )
    )
  )

