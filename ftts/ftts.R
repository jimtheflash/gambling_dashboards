
# prep --------------------------------------------------------------------

# load some libraries
library(tidyverse)
library(lubridate)
library(jsonlite)
library(shiny)
library(DT)

# ui ----------------------------------------------------------------------

ui <- fluidPage(
  h1('First Team To Score'),
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
      h4(textOutput('ftts_last_update')))),
  br(),
  fluidRow(dataTableOutput('ftts_table'))
)

# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  # TODO is this restart.txt business still necessary
  if (file.exists('restart.txt')) system('touch restart.txt') else file.create('restart.txt')
  
  # when the update button is pushed grab the latest odds_fpts.csv from github
  ftts_raw <- eventReactive(input$updateButton, {
    read.csv("https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/odds_ftts.csv")
  })
  # generate the output for the table
  ftts_tidy <- reactive({
    # make a string with edges - this is not the right or best or even a good way to do it
    edges <- list()
    for (i in 1:nrow(ftts_raw())) {
      test_row <- ftts_raw() %>%
        filter(row_number() == i) 
      out_vec <- c()
      if (!is.na(test_row$br_edge) & test_row$br_edge > 0) out_vec['br'] <- test_row$br_line
      if (!is.na(test_row$dk_edge) & test_row$dk_edge > 0) out_vec['dk'] <- test_row$dk_line
      if (!is.na(test_row$fd_edge) & test_row$fd_edge > 0) out_vec['fd'] <- test_row$fd_line
      if (!is.na(test_row$pb_edge) & test_row$pb_edge > 0) out_vec['pb'] <- test_row$pb_line
      if (all(is.na(out_vec))|is.null(out_vec)) {
        edges[[i]] <- 'none'
      } else {
        sorted_edges <- rev(sort(out_vec[which(!is.na(out_vec))]))
        out_string <- paste0(names(sorted_edges), ifelse(sorted_edges > 0, ' +', ' '), sorted_edges, collapse = ', ')
        edges[[i]] <- out_string
      }
    }
    
    # return table with the edges and the nicely named columns
    ftts_raw() %>%
      mutate(Edges = unlist(edges)) %>%
      rowwise() %>%
      # NOTE: this suppressWarnings call is annoying but necessary
      mutate(`Max Edge` = suppressWarnings(max(c_across(ends_with('edge')), na.rm = TRUE))) %>% 
      ungroup() %>%
      group_by(team, game_date) %>%
      fill(game, .direction =  'downup') %>%
      ungroup() %>%
      filter(!is.na(game)) %>%
      transmute(
        Team = team,
        Game = game,
        Date = game_date,
        Quarter = quarter,
        Expected = ftts_line,
        `Max Edge`,
        Edges,
        BR = br_line,
        # DK = dk_line,
        FD = fd_line,
        PB = pb_line
      ) %>%
      arrange(desc(`Max Edge`))
  })
  
  # when the update button is clicked, hit github api to find out datetime of latest commit for odds_fpts
  ftts_last_update <- eventReactive(input$updateButton, {
    max(as_datetime(ftts_raw()$run_timestamp_utc))
  })
  # extract and render datetime
  output$ftts_last_update <- renderText(
    paste0('FTTS Data Last Updated at ', ftts_last_update(), ' UTC')
  )
  
  # make the table of odds
  output$ftts_table <- renderDT(
    datatable(ftts_tidy(),
              filter = list(
                position = 'top', clear = FALSE
              ),
              options = list(
                dom = 't',
                paging = FALSE
              )) %>%
      formatPercentage(columns = c('Max Edge'),
                       digits = 2) %>%
      formatStyle(columns = c('Expected', 'BR', 'FD', 'PB'),
                     digits = 0))
}

# app ---------------------------------------------------------------------

shinyApp(ui, server)
