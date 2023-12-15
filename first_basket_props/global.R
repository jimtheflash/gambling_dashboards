# deps
library(glue)
library(lubridate)
library(reactable)
library(shiny)
library(shinyBS)
library(tidyverse)

# funs
for (f in list.files('funs/')) {
  source(paste0('funs/', f))
}

# vars
fpts_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_fpts.csv"
fpts_exact_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_fpts_exact.csv"
fpts_team_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_fpts_team.csv"
ftts_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_ftts.csv"
ftts_exact_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_ftts_exact.csv"
win_tip_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_win_tip.csv"

date_string <- as.character(gsub('-', '', today("America/Chicago")))
schedule_path <- glue("https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/nba_schedules/{date_string}.csv")

# data
fpts <- reactiveValues(data = read.csv(fpts_path))
fpts_exact <- reactiveValues(data = read.csv(fpts_exact_path))
fpts_team <- reactiveValues(data = read.csv(fpts_team_path))
ftts <- reactiveValues(data = read.csv(ftts_path))
ftts_exact <- reactiveValues(data = read.csv(ftts_exact_path))
win_tip <- reactiveValues(data = read.csv(win_tip_path))
schedule <- reactiveValues(data = read.csv(schedule_path))
