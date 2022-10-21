
# prep --------------------------------------------------------------------

# load some libraries
library(tidyverse)
library(lubridate)
library(shiny)
library(reactable)

# make some helpers
add_plus <- function(x) {
  if (is.na(x)) ''
  else if (x > 0) paste0('+', round(x))
  else if (x <= 0) as.character(round(x))
  else x
}

# ui ----------------------------------------------------------------------

ui <- fluidPage(
  h1('First Player To Score'),
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
  fluidRow(reactableOutput('fpts_table'))
)

# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  # restart
  if (file.exists('restart.txt')) system('touch restart.txt') else file.create('restart.txt')
  
  # when the update button is pushed grab the latest odds_fpts.csv from github
  fpts_raw <- eventReactive(input$updateButton, {
    read.csv("https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/odds_fpts.csv")
  })
  # generate the output for the table
  fpts_tidy <- reactive({
    # make a string with edges - this is not the right or best or even a good way to do it
    edges <- list()
    for (i in 1:nrow(fpts_raw())) {
      test_row <- fpts_raw() %>%
        filter(row_number() == i) %>%
        mutate_all(~replace(., is.na(.), -Inf))
        mutate(max_edge = max(c_across(ends_with('edge'))))
      edge_out_vec <- c()
      is_max_edge_out_vec <- c()
      edge_cols <- test_row %>% select(ends_with('edge'))
      for (j in 1:ncol(edge_cols)) {
        edge_colname <- colnames(edge_cols)[j]
        book <- unlist(str_split(colnames(edge_cols[j]), '_'))[1]
        book_edge <- edge_cols[j, edge_colname]
        if (book_edge > 0) edge_out_vec[book] <- book_edge
        if (book_edge > 0 & book_edge == test_row$max_edge) is_max_edge_out_vec[book] <- book_edge
      }
      if (all(is.na(edge_out_vec))|is.null(edge_out_vec)) {
        edges[[i]] <- 'none'
        } else {
        sorted_edges <- rev(sort(edge_out_vec[which(!is.na(edge_out_vec))]))
        out_string <- paste0(names(sorted_edges), ' +', sorted_edges, collapse = ', ')
        edges[[i]] <- out_string
        }
    }
      if (all(is.na(is_max_edge_out_vec))|is.null(is_max_edge_out_vec)) {
        max_edges[[i]] <- 'none'
      } else {
        sorted_max_edges <- rev(sort(is_max_edge_out_vec[which(!is.na(is_max_edge_out_vec))]))
        out_string <- paste0(names(sorted_max_edges), ' +', sorted_max_edges, collapse = ', ')
        max_edges[[i]] <- out_string
      }
    }    
    
    # return table with the edges and the nicely named columns
    fpts_raw() %>%
      mutate(Edges = unlist(edges)) %>%
      mutate(`Max Edge Books` = unlist(max_edges)) %>%
      rowwise() %>%
      # NOTE: this suppressWarnings call is annoying but necessary
      mutate(`Max Edge` = suppressWarnings(max(c_across(ends_with('edge')), na.rm = TRUE))) %>% 
      ungroup() %>%
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
        `Max Edge`,
        `Max Edge Books`,
        Edges,
        BR = br_line,
        BS = bs_line,
        CSR = csr_line,
        DK = dk_line,
        FD = fd_line,
        MGM = mgm_line,
        PB = pb_line
      ) %>%
      arrange(desc(`Max Edge`))
  })
  # when the update button is clicked, hit github api to find out datetime of latest commit for odds_fpts
  fpts_last_update <- eventReactive(input$updateButton, {
    max(as_datetime(fpts_raw()$run_timestamp_utc))
    })
  # extract and render datetime
  output$fpts_last_update <- renderText(
    paste0('FPTS Data Last Updated at ', fpts_last_update(), ' UTC')
    )
  output$fpts_table <- renderReactable({
    
    shiny::validate(need(nrow(fpts_tidy()) > 0, "waiting for input..."))
    
    reactable(
      fpts_tidy(),
      rownames = FALSE,
      pagination = FALSE,
      filterable = TRUE,
      sortable = TRUE,
      defaultSorted = list(`Max Edge` = 'desc'),
      columns = list(
        Player = colDef(name = 'Player'),
        Team = colDef(name = 'Team'),
        Game = colDef(name = 'Game'),
        Date = colDef(name = 'Date'),
        `Max Edge` = colDef(name = 'Max Edge', format = colFormat(percent = TRUE)),
        Expected = colDef(cell = function(value) {add_plus(value)}),
        BR = colDef(cell = function(value) {add_plus(value)}),
        BS = colDef(cell = function(value) {add_plus(value)}),
        CSR = colDef(cell = function(value) {add_plus(value)}),
        DK = colDef(cell = function(value) {add_plus(value)}),
        FD = colDef(cell = function(value) {add_plus(value)}),
        MGM = colDef(cell = function(value) {add_plus(value)}),
        PB = colDef(cell = function(value) {add_plus(value)})
      ),
      columnGroups = list(colGroup(
        name = "Odds",
        columns = c("BR", "BS", "CSR", "DK", "FD", "MGM", "PB")
      )))
  })
}

# app ---------------------------------------------------------------------

shinyApp(ui, server)
