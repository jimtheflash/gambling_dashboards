# deps
library(glue)
library(httr)
library(lubridate)
library(reactable)
library(readr)
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
fpts_team_exact_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_fpts_team_exact.csv"

ftts_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_ftts.csv"
ftts_exact_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_ftts_exact.csv"
win_tip_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_win_tip.csv"

date_string <- as.character(gsub('-', '', today("America/Chicago")))
schedule_path <- glue("https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/nba_schedules/{date_string}.csv")

# creds
gh_pat <- Sys.getenv('gh_pat')

# data
fpts <- reactiveValues(data = read_csv_from_private_repo(fpts_path, gh_pat))
fpts_exact <- reactiveValues(data = read_csv_from_private_repo(fpts_exact_path, gh_pat))
fpts_team <- reactiveValues(data = read_csv_from_private_repo(fpts_team_path, gh_pat))
fpts_team_exact <- reactiveValues(data = read_csv_from_private_repo(fpts_team_exact_path, gh_pat))
ftts <- reactiveValues(data = read_csv_from_private_repo(ftts_path, gh_pat))
ftts_exact <- reactiveValues(data = read_csv_from_private_repo(ftts_exact_path, gh_pat))
win_tip <- reactiveValues(data = read_csv_from_private_repo(win_tip_path, gh_pat))
schedule <- reactiveValues(data = read_csv_from_private_repo(schedule_path, gh_pat))
