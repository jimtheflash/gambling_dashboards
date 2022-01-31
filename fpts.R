
# prep --------------------------------------------------------------------

# load some libraries
library(tidyverse)
library(lubridate)
library(jsonlite)
library(shiny)
library(DT)


# ui ----------------------------------------------------------------------

ui <- fluidPage(
  h1('First Player To Score Dash'),
  br(),
  fluidRow(
    column(
      width = 3,
      actionButton('updateButton', h4('Update Data'))
    )),
  br(),
  fluidRow(
    column(
      width = 10,
      h4(textOutput('fpts_last_update')))),
  br(),
  fluidRow(dataTableOutput('fpts_table'))
)

# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  # TODO is this restart.txt business still necessary
  if (file.exists('restart.txt')) system('touch restart.txt') else file.create('restart.txt')
  
  fpts_raw <- eventReactive(input$updateButton, {
    read.csv("https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/odds_fpts.csv")
  })
  
  fpts_tidy <- reactive({
    edges <- list()
    for (i in 1:nrow(fpts_raw())) {
      test_row <- fpts_raw()[i, ]
      out_vec <- c()
      if (!is.na(test_row$br_edge) & test_row$br_edge > 0) out_vec[['br']] <- paste0('br (+', test_row$br_line, ')')
      if (!is.na(test_row$dk_edge) & test_row$dk_edge > 0)  out_vec[['dk']] <- paste0('dk (+', test_row$dk_line, ')')
      if (!is.na(test_row$fd_edge) & test_row$fd_edge > 0)  out_vec[['fd']] <- paste0('fd (+', test_row$fd_line, ')')
      if (!is.na(test_row$pb_edge) & test_row$pb_edge > 0)  out_vec[['pb']] <- paste0('pb (+', test_row$pb_line, ')')
      if (length(out_vec) == 0) out_vec <- 'none'
      edges[[i]] <- paste(out_vec, collapse = ', ')
    }
    fpts_raw() %>%
      mutate(Edges = unlist(edges)) %>%
      group_by(team, game_date) %>%
      fill(game, .direction =  'downup') %>%
      ungroup() %>%
      filter(!is.na(game)) %>%
      transmute(
        Player = player,
        Team = team,
        Game = game,
        Date = game_date,
        Expected = fpts_line,
        Edges
      ) %>%
      arrange(Expected)
  })
  
  fpts_last_update <- eventReactive(input$updateButton, {
    fpts_commit <- fromJSON("https://api.github.com/repos/jimtheflash/gambling_stuff/commits?path=data/02_curated/nba_first_to_score/odds_fpts.csv", flatten = TRUE)
    max(as_datetime(fpts_commit$commit.committer.date))
    })
  
  output$fpts_last_update <- renderText(
    paste0('FPTS Data Last Updated at ', fpts_last_update(), ' UTC')
    )
  
  # make the table
  output$fpts_table <- renderDT(
    datatable(fpts_tidy(),
              options = list(
                dom = 't',
                paging = FALSE
              )))
}

# app ---------------------------------------------------------------------

shinyApp(ui, server)
