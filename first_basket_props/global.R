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
fpts_team_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_fpts_team.csv"
ftts_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_ftts.csv"

date_string <- as.character(gsub('-', '', Sys.Date()))
schedule_path <- glue("https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/nba_schedules/{date_string}.csv")

# data
fpts <- reactiveValues(data = read.csv(fpts_path))
fpts_team <- reactiveValues(data = read.csv(fpts_team_path))
ftts <- reactiveValues(data =  read.csv(ftts_path))
schedule <- reactiveValues(data = read.csv(schedule_path))
