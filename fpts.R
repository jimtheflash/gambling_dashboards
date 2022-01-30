
# prep --------------------------------------------------------------------

# load some libraries
library(tidyverse)
library(shiny)

# load the data
fpts_raw <- read.csv("https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/odds_fpts.csv")

# terribly slow way to identify edges
edges <- list()
for (i in 1:nrow(fpts_raw)) {
  test_row <- fpts_raw[i, ]
  out_vec <- c()
  if (!is.na(test_row$br_edge) & test_row$br_edge > 0) out_vec <- c(out_vec, paste0('br +', test_row$br_line))
  if (!is.na(test_row$dk_edge) & test_row$dk_edge > 0)  out_vec <- c(out_vec, paste0('dk +', test_row$dk_line))
  if (!is.na(test_row$fd_edge) & test_row$fd_edge > 0)  out_vec <- c(out_vec, paste0('fd +', test_row$fd_line))
  if (!is.na(test_row$pb_edge) & test_row$pb_edge > 0)  out_vec <- c(out_vec, paste0('pb +', test_row$pb_line))
  if (length(out_vec) == 0) out_vec <- 'none'
  edges[[i]] <- paste(out_vec, collapse = ', ')
}

# make the tidy data
fpts_tidy <- fpts_raw %>%
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
  )


# ui ----------------------------------------------------------------------

ui <- fluidPage(
  dataTableOutput('fpts_table')
)

# server ------------------------------------------------------------------

server <- function(input, output, session) {
  output$fpts_table <- renderDataTable(fpts_tidy)
}

# app ---------------------------------------------------------------------

shinyApp(ui, server)
