
# ui ----------------------------------------------------------------------

ui <- shiny::fluidPage(
  shiny::h1('First To Score Dash!'),
  shiny::br(),
  shiny::fluidRow(
    shiny::column(
      width = 3,
      shiny::actionButton('updateButton', shiny::h4('Update Data'))
    )),
  shiny::br(),
  shiny::fluidRow(
    shiny::column(
      width = 12,
      shiny::h4(shiny::textOutput('fpts_last_update')))),
  shiny::br(),
  shiny::fluidRow(
    shiny::column(
    width = 12,
    shiny::tabsetPanel(
      shiny::tabPanel('First Player to Score',
                      shiny::fluidRow(
                        shiny::column(
                          width = 12,
                          reactable::reactableOutput('fpts_table')))),
      shiny::tabPanel('First Player to Score by Team'),
      shiny::tabPanel('First Team to Score'))
    )
  )
)
# ui <- shiny::fluidPage(
#   reactable::reactableOutput('fpts_table')
# )
# server ------------------------------------------------------------------

server <- function(input, output, session) {

  # restart; probably not necessary and easy to remove if that's the case
  restart_app()

  # when the update button is pushed grab the latest odds_fpts.csv from github
  shiny::observeEvent(input$updateButton, {
    fpts_raw$data <-
      read.csv("https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/odds_fpts.csv")
    fpts_by_team_raw$data <-
      read.csv("https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/odds_fpts_team.csv")
  })

  # generate the output for the table
  fpts_tidy <- shiny::reactive({
    tidyup_fpts(fpts_raw$data)
  })
  output$fpts_table <- reactable::renderReactable({

    shiny::validate(need(nrow(fpts_tidy()) > 0, "waiting for input..."))

    reactable::reactable(
      fpts_tidy(),
      defaultColDef = reactable::colDef(
        align = 'right'
      ),
      rownames = FALSE,
      pagination = FALSE,
      filterable = TRUE,
      sortable = TRUE,
      defaultSorted = list(`Max Edge` = 'desc'),
      columns = list(
        Player = reactable::colDef(name = 'Player', align = 'left', width = 210),
        Team = reactable::colDef(name = 'Team', align = 'left', width = 60),
        Game = reactable::colDef(name = 'Game', align = 'left', width = 120),
        Date = reactable::colDef(name = 'Date', align = 'left', width = 90),
        `Max Edge` = reactable::colDef(name = 'Max Edge', format = reactable::colFormat(percent = TRUE), width = 120),
        Edges = reactable::colDef(align = 'left'),
        Expected = define_book_col(),
        BR = define_book_col(),
        BS = define_book_col(),
        CSR = define_book_col(),
        DK = define_book_col(),
        FD = define_book_col(),
        MGM = define_book_col(),
        PB = define_book_col()
      ),
      columnGroups = list(
        reactable::colGroup(
          name = "Odds",
          columns = c("BR", "BS", "CSR", "DK", "FD", "MGM", "PB")
      )))
  })
}
# server <- function(input, output, session) {
#   output$fpts_table <- reactable::renderReactable({
#     reactable::reactable(fpts_raw$data)
#   })
# }
# app ---------------------------------------------------------------------

shiny::shinyApp(ui, server)
