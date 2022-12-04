# deps
library(reactable)
library(shiny)
library(tidyverse)

# funs
for (f in list.files('funs/')) {
  source(paste0('funs/', f))
}

# vars
fpts_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/odds_fpts.csv"
fpts_team_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/odds_fpts_team.csv"
ftts_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/odds_ftts.csv"

# data
fpts <- reactiveValues(data = read.csv(fpts_path))
fpts_team <- reactiveValues(data = read.csv(fpts_team_path))
ftts <- reactiveValues(data =  read.csv(ftts_path))
