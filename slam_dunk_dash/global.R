# deps
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(scales))
suppressPackageStartupMessages(library(glue))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(reactable))

# funs
for (f in list.files('funs/')) {
  source(paste0('funs/', f))
}

# creds
gh_pat <- Sys.getenv('gh_pat')

#### Read in schedule Data ####
date_string <- as.character(gsub('-', '', today("America/Chicago")))
schedule_path <- glue("https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/nba_schedules/{date_string}.csv")

# Read the schedule file
schedule <- read_csv_from_private_repo(schedule_path, gh_pat)
schedule_tidy <- tidyup_schedule(schedule)

#### Read in Trends Data ####
player_trend_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/trends/player_trends.csv"
team_trend_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/trends/team_trends.csv"
win_tip_trend_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/trends/tip_trends.csv"

# Read the player_trend_data file
player_trend_data <-
  read_csv_from_private_repo(player_trend_path, gh_pat) %>%
  filter(!is.na(matchup)) %>%
  mutate(starts = if_else(is.na(starts), 0, starts),
         game = sub("(.*) vs. (.*)", "\\2 @ \\1", matchup))

# Read the team_trend_data file
team_trend_data <-
  read_csv_from_private_repo(team_trend_path, gh_pat) %>%
  filter(!is.na(matchup)) %>%
  mutate(games = if_else(is.na(games), 0, games),
         game = sub("(.*) vs. (.*)", "\\2 @ \\1", matchup))

# Read the tip_trend_data file
tip_trend_data <-
  read_csv_from_private_repo(win_tip_trend_path, gh_pat) %>%
  filter(!is.na(matchup)) %>%
  mutate(jumps = if_else(is.na(jumps), 0, jumps),
         game = sub("(.*) vs. (.*)", "\\2 @ \\1", matchup))

#### Read in Edges Data ####
edge_fpts_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_fpts.csv"
edge_fpts_not_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_fpts_not.csv"
edge_fpts_exact_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_fpts_exact.csv"
edge_fpts_team_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_fpts_team.csv"
edge_fpts_team_exact_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_fpts_team_exact.csv"
edge_first_three_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_first_three.csv"
edge_first_three_team_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_first_three_team.csv"
edge_ftts_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_ftts.csv"
edge_ftts_exact_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_ftts_exact.csv"
edge_win_tip_path <- "https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/edges/edges_win_tip.csv"

# Read in the player projections as of this run
edges_ftts <- read_csv_from_private_repo(edge_ftts_path, gh_pat) %>%
  mutate(game_date = as.Date(game_date),
         across(game:quarter_team, as.character),
         across(prob_points:mgm_units, as.numeric))

edges_ftts_exact <- read_csv_from_private_repo(edge_ftts_exact_path, gh_pat) %>%
  mutate(game_date = as.Date(game_date),
         across(game:shot_team, as.character),
         across(prob_points_fd:mgm_units, as.numeric))

edges_fpts <- read_csv_from_private_repo(edge_fpts_path, gh_pat) %>%
  mutate(game_date = as.Date(game_date),
         across(game:team_abbreviation, as.character),
         across(prob_points:mgm_units, as.numeric))

edges_fpts_not <- read_csv_from_private_repo(edge_fpts_not_path, gh_pat) %>%
  mutate(game_date = as.Date(game_date),
         across(game:team_abbreviation, as.character),
         across(prob_points:mgm_units, as.numeric))

edges_fpts_team <- read_csv_from_private_repo(edge_fpts_team_path, gh_pat) %>%
  mutate(game_date = as.Date(game_date),
         across(game:team_abbreviation, as.character),
         across(prob_points:mgm_units, as.numeric))

edges_fpts_team_exact <- read_csv_from_private_repo(edge_fpts_team_exact_path, gh_pat) %>%
  mutate(game_date = as.Date(game_date),
         across(game:team_abbreviation, as.character),
         across(prob_points_fd:mgm_units, as.numeric))

edges_fpts_exact <- read_csv_from_private_repo(edge_fpts_exact_path, gh_pat) %>%
  mutate(game_date = as.Date(game_date),
         across(game:shot_player, as.character),
         across(prob_points_fd:mgm_units, as.numeric))

edges_first_three <- read_csv_from_private_repo(edge_first_three_path, gh_pat) %>%
  mutate(game_date = as.Date(game_date),
         across(game:team_abbreviation, as.character),
         across(prob_fg3m:mgm_units, as.numeric))

edges_first_three_team <- read_csv_from_private_repo(edge_first_three_team_path, gh_pat) %>%
  mutate(game_date = as.Date(game_date),
         across(game:team_abbreviation, as.character),
         across(prob_fg3m:mgm_units, as.numeric))

edges_win_tip <- read_csv_from_private_repo(edge_win_tip_path, gh_pat) %>%
  mutate(game_date = as.Date(game_date),
         across(game:player_name, as.character),
         across(prob_tip:mgm_units, as.numeric))

############ Data Wrangling for Dashboard Format ################
# Store off First Basket data
first_basket_projections <-
  edges_fpts %>%
  select(game, team_abbreviation, player_name, prob_points, line_points, prob_fgm, line_fgm)

first_basket_data <-
  first_basket_projections %>%
  left_join(schedule_tidy, by = join_by(game)) %>%
  left_join(player_trend_data, by = join_by(player_name, team_abbreviation, game)) %>%
  mutate(first_shots = round(starts * first_game_shot_overall_season, 0),
         first_points = round(starts * first_game_points_overall_season, 0),
         first_fga = round(starts * first_game_fga_overall_season, 0),
         first_fgm = round(starts * first_game_fgm_overall_season, 0),
         first_shots_display = paste0(first_shots, " (", round(first_game_shot_overall_season*100,1), "%)"),
         first_points_display = paste0(first_points, " (", round(first_game_points_overall_season*100,1), "%)"),
         first_fga_display = paste0(first_fga, " (", round(first_game_fga_overall_season*100,1), "%)"),
         first_fgm_display = paste0(first_fgm, " (", round(first_game_fgm_overall_season*100,1), "%)")) %>%
  select(game, tipoff, team_abbreviation, player_name, starts, fgpct_season, usg_season,
         first_shots_display, first_points_display, line_points, prob_points,
         first_fga_display, first_fgm_display, line_fgm, prob_fgm)

# Store off First Basket Exact data
first_basket_exact_projections <-
  edges_fpts_exact %>%
  select(game, team_abbreviation, player_name, shot_type, prob_points_fd, line_points_fd, prob_points_ftics, line_points_ftics, prob_fgm, line_fgm)

first_basket_exact_data <-
  first_basket_exact_projections %>%
  left_join(schedule_tidy, by = join_by(game)) %>%
  left_join(player_trend_data, by = join_by(player_name, team_abbreviation, game)) %>%
  filter(shot_type != 'two_point_non_dunk') %>%
  mutate(shot_type_display = case_when(shot_type == 'dunk' ~ "Dunk",
                                       shot_type == 'free_throw' ~ "Free Throw",
                                       shot_type == 'layup' ~ "Layup",
                                       shot_type == 'other_fg' ~ "Other FG",
                                       shot_type == 'three_point' ~ "Three Point",
                                       shot_type == 'two_point' ~ "Two Point",
                                       shot_type == 'two_point_non_dunk' ~ "Two Point (Non Dunk)"),
         fg_type_pct = case_when(shot_type == 'dunk' ~ fg_dunk_pct_season,
                                 shot_type == 'free_throw' ~ ftpct_season,
                                 shot_type == 'layup' ~ fg_layup_pct_season,
                                 shot_type == 'other_fg' ~ fg_other_fg_pct_season,
                                 shot_type == 'three_point' ~ fg_three_pct_season,
                                 shot_type == 'two_point' ~ fg_two_pct_season,
                                 shot_type == 'two_point_non_dunk' ~ NA),
         fga_ratio = case_when(shot_type == 'dunk' ~ fga_dunk_ratio_season,
                               shot_type == 'free_throw' ~ NA,
                               shot_type == 'layup' ~ fga_layup_ratio_season,
                               shot_type == 'other_fg' ~ fga_other_fg_ratio_season,
                               shot_type == 'three_point' ~ fga_three_ratio_season,
                               shot_type == 'two_point' ~ fga_two_ratio_season,
                               shot_type == 'two_point_non_dunk' ~ NA),
         first_shots = round(starts * case_when(shot_type == 'dunk' ~ first_game_shot_dunk_season,
                                          shot_type == 'free_throw' ~ first_game_shot_free_throw_season,
                                          shot_type == 'layup' ~ first_game_shot_layup_season,
                                          shot_type == 'other_fg' ~ first_game_shot_other_fg_season,
                                          shot_type == 'three_point' ~ first_game_shot_three_point_season,
                                          shot_type == 'two_point' ~ first_game_shot_two_season,
                                          shot_type == 'two_point_non_dunk' ~ first_game_shot_two_season - first_game_shot_dunk_season), 0),
         first_points = round(starts * case_when(shot_type == 'dunk' ~ first_game_points_dunk_season,
                                           shot_type == 'free_throw' ~ first_game_points_free_throw_season,
                                           shot_type == 'layup' ~ first_game_points_layup_season,
                                           shot_type == 'other_fg' ~ first_game_points_other_fg_season,
                                           shot_type == 'three_point' ~ first_game_points_three_point_season,
                                           shot_type == 'two_point' ~ first_game_points_two_season,
                                           shot_type == 'two_point_non_dunk' ~ first_game_points_two_season - first_game_points_dunk_season), 0),
         first_fga = round(starts * case_when(shot_type == 'dunk' ~ first_game_fga_dunk_season,
                                        shot_type == 'free_throw' ~ NA,
                                        shot_type == 'layup' ~ first_game_fga_layup_season,
                                        shot_type == 'other_fg' ~ first_game_fga_other_fg_season,
                                        shot_type == 'three_point' ~ first_game_fga_three_point_season,
                                        shot_type == 'two_point' ~ first_game_fga_two_season,
                                        shot_type == 'two_point_non_dunk' ~ first_game_fga_two_season - first_game_fga_dunk_season), 0),
         first_fgm = round(starts * case_when(shot_type == 'dunk' ~ first_game_fgm_dunk_season,
                                        shot_type == 'free_throw' ~ NA,
                                        shot_type == 'layup' ~ first_game_fgm_layup_season,
                                        shot_type == 'other_fg' ~ first_game_fgm_other_fg_season,
                                        shot_type == 'three_point' ~ first_game_fgm_three_point_season,
                                        shot_type == 'two_point' ~ first_game_fgm_two_season,
                                        shot_type == 'two_point_non_dunk' ~ first_game_fgm_two_season - first_game_fgm_dunk_season), 0),
         first_shots_display = case_when(shot_type == 'dunk' ~ paste0(first_shots, " (", round(first_game_shot_dunk_season*100,1), "%)"),
                                         shot_type == 'free_throw' ~ paste0(first_shots, " (", round(first_game_shot_free_throw_season*100,1), "%)"),
                                         shot_type == 'layup' ~ paste0(first_shots, " (", round(first_game_shot_layup_season*100,1), "%)"),
                                         shot_type == 'other_fg' ~ paste0(first_shots, " (", round(first_game_shot_other_fg_season*100,1), "%)"),
                                         shot_type == 'three_point' ~ paste0(first_shots, " (", round(first_game_shot_three_point_season*100,1), "%)"),
                                         shot_type == 'two_point' ~ NA,
                                         shot_type == 'two_point_non_dunk' ~ paste0(first_shots, " (", round((first_game_shot_two_season - first_game_shot_dunk_season)*100,1), "%)")),
         first_points_display = case_when(shot_type == 'dunk' ~ paste0(first_points, " (", round(first_game_points_dunk_season*100,1), "%)"),
                                          shot_type == 'free_throw' ~ paste0(first_points, " (", round(first_game_points_free_throw_season*100,1), "%)"),
                                          shot_type == 'layup' ~ paste0(first_points, " (", round(first_game_points_layup_season*100,1), "%)"),
                                          shot_type == 'other_fg' ~ paste0(first_points, " (", round(first_game_points_other_fg_season*100,1), "%)"),
                                          shot_type == 'three_point' ~ paste0(first_points, " (", round(first_game_points_three_point_season*100,1), "%)"),
                                          shot_type == 'two_point' ~ NA,
                                          shot_type == 'two_point_non_dunk' ~ paste0(first_points, " (", round((first_game_points_two_season - first_game_points_dunk_season)*100,1), "%)")),
         first_fga_display = case_when(shot_type == 'dunk' ~ NA,
                                       shot_type == 'free_throw' ~ NA,
                                       shot_type == 'layup' ~ NA,
                                       shot_type == 'other_fg' ~ NA,
                                       shot_type == 'three_point' ~ paste0(first_fga, " (", round(first_game_fga_three_point_season*100,1), "%)"),
                                       shot_type == 'two_point' ~ paste0(first_fga, " (", round(first_game_fga_two_season*100,1), "%)"),
                                       shot_type == 'two_point_non_dunk' ~ NA),
         first_fgm_display = case_when(shot_type == 'dunk' ~ NA,
                                       shot_type == 'free_throw' ~ NA,
                                       shot_type == 'layup' ~ NA,
                                       shot_type == 'other_fg' ~ NA,
                                       shot_type == 'three_point' ~ paste0(first_fgm, " (", round(first_game_fgm_three_point_season*100,1), "%)"),
                                       shot_type == 'two_point' ~ paste0(first_fgm, " (", round(first_game_fgm_two_season*100,1), "%)"),
                                       shot_type == 'two_point_non_dunk' ~ NA),
         line_points = coalesce(line_points_fd, line_points_ftics),
         prob_points = coalesce(prob_points_fd, prob_points_ftics)) %>%
  select(game, tipoff, team_abbreviation, player_name, shot_type_display, starts, fg_type_pct, fga_ratio, usg_season,
         first_shots_display, first_points_display, line_points, prob_points,
         first_fga_display, first_fgm_display, line_fgm, prob_fgm)

# Store off First Basket by Team data
first_basket_by_team_projections <-
  edges_fpts_team %>%
  select(game, team_abbreviation, player_name, prob_points, line_points, prob_fgm, line_fgm)

first_basket_by_team_data <-
  first_basket_by_team_projections %>%
  left_join(schedule_tidy, by = join_by(game)) %>%
  left_join(player_trend_data, by = join_by(player_name, team_abbreviation, game)) %>%
  mutate(first_shots = round(starts * first_team_shot_overall_season, 0),
         first_points = round(starts * first_team_points_overall_season, 0),
         first_fga = round(starts * first_team_fga_overall_season, 0),
         first_fgm = round(starts * first_team_fgm_overall_season, 0),
         first_shots_display = paste0(first_shots, " (", round(first_team_shot_overall_season*100,1), "%)"),
         first_points_display = paste0(first_points, " (", round(first_team_points_overall_season*100,1), "%)"),
         first_fga_display = paste0(first_fga, " (", round(first_team_fga_overall_season*100,1), "%)"),
         first_fgm_display = paste0(first_fgm, " (", round(first_team_fgm_overall_season*100,1), "%)")) %>%
  select(game, tipoff, team_abbreviation, player_name, starts, fgpct_season, usg_season,
         first_shots_display, first_points_display, line_points, prob_points,
         first_fga_display, first_fgm_display, line_fgm, prob_fgm)

# Store off First Basket by Team Exact data
first_basket_by_team_exact_projections <-
  edges_fpts_team_exact %>%
  select(game, team_abbreviation, player_name, shot_type, prob_points_fd, line_points_fd, prob_points_ftics, line_points_ftics, prob_fgm, line_fgm)

first_basket_by_team_exact_data <-
  first_basket_by_team_exact_projections %>%
  left_join(schedule_tidy, by = join_by(game)) %>%
  left_join(player_trend_data, by = join_by(player_name, team_abbreviation, game)) %>%
  filter(shot_type %in% c('two_point', 'three_point')) %>%
  mutate(shot_type_display = case_when(shot_type == 'dunk' ~ "Dunk",
                                       shot_type == 'free_throw' ~ "Free Throw",
                                       shot_type == 'layup' ~ "Layup",
                                       shot_type == 'other_fg' ~ "Other FG",
                                       shot_type == 'three_point' ~ "Three Point",
                                       shot_type == 'two_point' ~ "Two Point",
                                       shot_type == 'two_point_non_dunk' ~ "Two Point (Non Dunk)"),
         fg_type_pct = case_when(shot_type == 'dunk' ~ fg_dunk_pct_season,
                                 shot_type == 'free_throw' ~ ftpct_season,
                                 shot_type == 'layup' ~ fg_layup_pct_season,
                                 shot_type == 'other_fg' ~ fg_other_fg_pct_season,
                                 shot_type == 'three_point' ~ fg_three_pct_season,
                                 shot_type == 'two_point' ~ fg_two_pct_season,
                                 shot_type == 'two_point_non_dunk' ~ NA),
         fga_ratio = case_when(shot_type == 'dunk' ~ fga_dunk_ratio_season,
                               shot_type == 'free_throw' ~ NA,
                               shot_type == 'layup' ~ fga_layup_ratio_season,
                               shot_type == 'other_fg' ~ fga_other_fg_ratio_season,
                               shot_type == 'three_point' ~ fga_three_ratio_season,
                               shot_type == 'two_point' ~ fga_two_ratio_season,
                               shot_type == 'two_point_non_dunk' ~ NA),
         first_shots = round(starts * case_when(shot_type == 'dunk' ~ first_team_shot_dunk_season,
                                          shot_type == 'free_throw' ~ first_team_shot_free_throw_season,
                                          shot_type == 'layup' ~ first_team_shot_layup_season,
                                          shot_type == 'other_fg' ~ first_team_shot_other_fg_season,
                                          shot_type == 'three_point' ~ first_team_shot_three_point_season,
                                          shot_type == 'two_point' ~ first_team_shot_two_season,
                                          shot_type == 'two_point_non_dunk' ~ first_team_shot_two_season - first_team_shot_dunk_season), 0),
         first_points = round(starts * case_when(shot_type == 'dunk' ~ first_team_points_dunk_season,
                                           shot_type == 'free_throw' ~ first_team_points_free_throw_season,
                                           shot_type == 'layup' ~ first_team_points_layup_season,
                                           shot_type == 'other_fg' ~ first_team_points_other_fg_season,
                                           shot_type == 'three_point' ~ first_team_points_three_point_season,
                                           shot_type == 'two_point' ~ first_team_points_two_season,
                                           shot_type == 'two_point_non_dunk' ~ first_team_points_two_season - first_team_points_dunk_season), 0),
         first_fga = round(starts * case_when(shot_type == 'dunk' ~ first_team_fga_dunk_season,
                                        shot_type == 'free_throw' ~ NA,
                                        shot_type == 'layup' ~ first_team_fga_layup_season,
                                        shot_type == 'other_fg' ~ first_team_fga_other_fg_season,
                                        shot_type == 'three_point' ~ first_team_fga_three_point_season,
                                        shot_type == 'two_point' ~ first_team_fga_two_season,
                                        shot_type == 'two_point_non_dunk' ~ first_team_fga_two_season - first_team_fga_dunk_season), 0),
         first_fgm = round(starts * case_when(shot_type == 'dunk' ~ first_team_fgm_dunk_season,
                                        shot_type == 'free_throw' ~ NA,
                                        shot_type == 'layup' ~ first_team_fgm_layup_season,
                                        shot_type == 'other_fg' ~ first_team_fgm_other_fg_season,
                                        shot_type == 'three_point' ~ first_team_fgm_three_point_season,
                                        shot_type == 'two_point' ~ first_team_fgm_two_season,
                                        shot_type == 'two_point_non_dunk' ~ first_team_fgm_two_season - first_team_fgm_dunk_season), 0),
         first_shots_display = paste0(first_shots, " (", case_when(shot_type == 'dunk' ~ round(first_team_shot_dunk_season*100,1),
                                                                   shot_type == 'free_throw' ~ round(first_team_shot_free_throw_season*100,1),
                                                                   shot_type == 'layup' ~ round(first_team_shot_layup_season*100,1),
                                                                   shot_type == 'other_fg' ~ round(first_team_shot_other_fg_season*100,1),
                                                                   shot_type == 'three_point' ~ round(first_team_shot_three_point_season*100,1),
                                                                   shot_type == 'two_point' ~ round(first_team_shot_two_season*100,1),
                                                                   shot_type == 'two_point_non_dunk' ~ round((first_team_shot_two_season - first_team_shot_dunk_season)*100,1)), "%)"),
         first_points_display = paste0(first_points, " (", case_when(shot_type == 'dunk' ~ round(first_team_points_dunk_season*100,1),
                                                                     shot_type == 'free_throw' ~ round(first_team_points_free_throw_season*100,1),
                                                                     shot_type == 'layup' ~ round(first_team_points_layup_season*100,1),
                                                                     shot_type == 'other_fg' ~ round(first_team_points_other_fg_season*100,1),
                                                                     shot_type == 'three_point' ~ round(first_team_points_three_point_season*100,1),
                                                                     shot_type == 'two_point' ~ round(first_team_points_two_season*100,1),
                                                                     shot_type == 'two_point_non_dunk' ~ round((first_team_points_two_season - first_team_points_dunk_season)*100,1)), "%)"),
         first_fga_display = paste0(first_fga, " (", case_when(shot_type == 'dunk' ~ round(first_team_fga_dunk_season*100,1),
                                                               shot_type == 'free_throw' ~ NA,
                                                               shot_type == 'layup' ~ round(first_team_fga_layup_season*100,1),
                                                               shot_type == 'other_fg' ~ round(first_team_fga_other_fg_season*100,1),
                                                               shot_type == 'three_point' ~ round(first_team_fga_three_point_season*100,1),
                                                               shot_type == 'two_point' ~ round(first_team_fga_two_season*100,1),
                                                               shot_type == 'two_point_non_dunk' ~ round((first_team_fga_two_season - first_team_fga_dunk_season)*100,1)), "%)"),
         first_fgm_display = paste0(first_fga, " (", case_when(shot_type == 'dunk' ~ round(first_team_fgm_dunk_season*100,1),
                                                               shot_type == 'free_throw' ~ NA,
                                                               shot_type == 'layup' ~ round(first_team_fgm_layup_season*100,1),
                                                               shot_type == 'other_fg' ~ round(first_team_fgm_other_fg_season*100,1),
                                                               shot_type == 'three_point' ~ round(first_team_fgm_three_point_season*100,1),
                                                               shot_type == 'two_point' ~ round(first_team_fgm_two_season*100,1),
                                                               shot_type == 'two_point_non_dunk' ~ round((first_team_fgm_two_season - first_team_fgm_dunk_season)*100,1)), "%)"),
         line_points = coalesce(line_points_fd, line_points_ftics),
         prob_points = coalesce(prob_points_fd, prob_points_ftics)) %>%
  select(game, tipoff, team_abbreviation, player_name, shot_type_display, starts, fg_type_pct, fga_ratio, usg_season,
         #first_shots_display, first_points_display, line_points, prob_points,
         first_fga_display, first_fgm_display, line_fgm, prob_fgm)

# Store off First Three data
first_three_projections <-
  edges_first_three %>%
  select(game, team_abbreviation, player_name, prob_fg3m, line_fg3m)

first_three_data <-
  first_three_projections %>%
  left_join(schedule_tidy, by = join_by(game)) %>%
  left_join(player_trend_data, by = join_by(player_name, team_abbreviation, game)) %>%
  mutate(first_three_attempts = round(starts * first_game_fg3a_season, 0),
         first_three_makes = round(starts * first_game_fg3m_season, 0),
         first_three_attempts_display = paste0(first_three_attempts, " (", round(first_game_fg3a_season*100,1), "%)"),
         first_three_makes_display = paste0(first_three_makes, " (", round(first_game_fg3m_season*100,1), "%)")) %>%
  select(game, tipoff, team_abbreviation, player_name, starts, fg_three_pct_season, fga_three_ratio_season,
         first_three_attempts_display, first_three_makes_display,
         line_fg3m, prob_fg3m)

# Store off First Three by Team data
first_three_by_team_projections <-
  edges_first_three_team %>%
  select(game, team_abbreviation, player_name, prob_fg3m, line_fg3m)

first_three_by_team_data <-
  first_three_by_team_projections %>%
  left_join(schedule_tidy, by = join_by(game)) %>%
  left_join(player_trend_data, by = join_by(player_name, team_abbreviation, game)) %>%
  mutate(first_three_attempts = round(starts * first_game_fg3a_season, 0),
         first_three_makes = round(starts * first_game_fg3m_season, 0),
         first_three_attempts_display = paste0(first_three_attempts, " (", round(first_team_fg3a_season*100,1), "%)"),
         first_three_makes_display = paste0(first_three_makes, " (", round(first_team_fg3m_season*100,1), "%)")) %>%
  select(game, tipoff, team_abbreviation, player_name, starts, fg_three_pct_season, fga_three_ratio_season,
         first_three_attempts_display, first_three_makes_display,
         line_fg3m, prob_fg3m)

# Store off First Team data
first_team_projections <-
  edges_ftts %>%
  select(game, team_abbreviation, prob_points, line_points, prob_fgm, line_fgm)

first_team_data <-
  first_team_projections %>%
  left_join(schedule_tidy, by = join_by(game)) %>%
  left_join(team_trend_data, by = join_by(team_abbreviation, game)) %>%
  mutate(first_shots = round(games * first_game_shot_overall_season, 0),
         first_points = round(games * first_game_points_overall_season, 0),
         first_fga = round(games * first_game_fga_overall_season, 0),
         first_fgm = round(games * first_game_fgm_overall_season, 0),
         first_shots_display = paste0(first_shots, " (", round(first_game_shot_overall_season*100,1), "%)"),
         first_points_display = paste0(first_points, " (", round(first_game_points_overall_season*100,1), "%)"),
         first_fga_display = paste0(first_fga, " (", round(first_game_fga_overall_season*100,1), "%)"),
         first_fgm_display = paste0(first_fgm, " (", round(first_game_fgm_overall_season*100,1), "%)")) %>%
  select(game, tipoff, team_abbreviation, games, fgpct_season,
         first_shots_display, first_points_display, line_points, prob_points,
         first_fga_display, first_fgm_display, line_fgm, prob_fgm)

# Store off First Team Exact data
first_team_exact_projections <-
  edges_ftts_exact %>%
  select(game, team_abbreviation, shot_type, prob_points_fd, line_points_fd, prob_points_ftics, line_points_ftics, prob_fgm, line_fgm)

first_team_exact_data <-
  first_team_exact_projections %>%
  left_join(schedule_tidy, by = join_by(game)) %>%
  left_join(team_trend_data, by = join_by(team_abbreviation, game)) %>%
  #Remove Game level props for now
  filter(!grepl("/", team_abbreviation)) %>%
  filter(shot_type %in% c('two_point', 'three_point')) %>%
  mutate(shot_type_display = case_when(shot_type == 'dunk' ~ "Dunk",
                                       shot_type == 'free_throw' ~ "Free Throw",
                                       shot_type == 'layup' ~ "Layup",
                                       shot_type == 'other_fg' ~ "Other FG",
                                       shot_type == 'three_point' ~ "Three Point",
                                       shot_type == 'two_point' ~ "Two Point",
                                       shot_type == 'two_point_non_dunk' ~ "Two Point (Non Dunk)"),
         fg_type_pct = case_when(shot_type == 'dunk' ~ fg_dunk_pct_season,
                                 shot_type == 'free_throw' ~ ftpct_season,
                                 shot_type == 'layup' ~ fg_layup_pct_season,
                                 shot_type == 'other_fg' ~ fg_other_fg_pct_season,
                                 shot_type == 'three_point' ~ fg_three_pct_season,
                                 shot_type == 'two_point' ~ fg_two_pct_season,
                                 shot_type == 'two_point_non_dunk' ~ NA),
         fga_ratio = case_when(shot_type == 'dunk' ~ fga_dunk_ratio_season,
                               shot_type == 'free_throw' ~ NA,
                               shot_type == 'layup' ~ fga_layup_ratio_season,
                               shot_type == 'other_fg' ~ fga_other_fg_ratio_season,
                               shot_type == 'three_point' ~ fga_three_ratio_season,
                               shot_type == 'two_point' ~ fga_two_ratio_season,
                               shot_type == 'two_point_non_dunk' ~ NA),
         first_shots = round(games * case_when(shot_type == 'dunk' ~ first_game_shot_dunk_season,
                                         shot_type == 'free_throw' ~ first_game_shot_free_throw_season,
                                         shot_type == 'layup' ~ first_game_shot_layup_season,
                                         shot_type == 'other_fg' ~ first_game_shot_other_fg_season,
                                         shot_type == 'three_point' ~ first_game_shot_three_point_season,
                                         shot_type == 'two_point' ~ first_game_shot_two_season,
                                         shot_type == 'two_point_non_dunk' ~ first_game_shot_two_season - first_game_shot_dunk_season), 0),
         first_points = round(games * case_when(shot_type == 'dunk' ~ first_game_points_dunk_season,
                                          shot_type == 'free_throw' ~ first_game_points_free_throw_season,
                                          shot_type == 'layup' ~ first_game_points_layup_season,
                                          shot_type == 'other_fg' ~ first_game_points_other_fg_season,
                                          shot_type == 'three_point' ~ first_game_points_three_point_season,
                                          shot_type == 'two_point' ~ first_game_points_two_season,
                                          shot_type == 'two_point_non_dunk' ~ first_game_points_two_season - first_game_points_dunk_season), 0),
         first_fga = round(games * case_when(shot_type == 'dunk' ~ first_game_fga_dunk_season,
                                       shot_type == 'free_throw' ~ NA,
                                       shot_type == 'layup' ~ first_game_fga_layup_season,
                                       shot_type == 'other_fg' ~ first_game_fga_other_fg_season,
                                       shot_type == 'three_point' ~ first_game_fga_three_point_season,
                                       shot_type == 'two_point' ~ first_game_fga_two_season,
                                       shot_type == 'two_point_non_dunk' ~ first_game_fga_two_season - first_game_fga_dunk_season), 0),
         first_fgm = round(games * case_when(shot_type == 'dunk' ~ first_game_fgm_dunk_season,
                                       shot_type == 'free_throw' ~ NA,
                                       shot_type == 'layup' ~ first_game_fgm_layup_season,
                                       shot_type == 'other_fg' ~ first_game_fgm_other_fg_season,
                                       shot_type == 'three_point' ~ first_game_fgm_three_point_season,
                                       shot_type == 'two_point' ~ first_game_fgm_two_season,
                                       shot_type == 'two_point_non_dunk' ~ first_game_fgm_two_season - first_game_fgm_dunk_season), 0),
         first_shots_display = paste0(first_shots, " (", case_when(shot_type == 'dunk' ~ round(first_game_shot_dunk_season*100,1),
                                                                   shot_type == 'free_throw' ~ round(first_game_shot_free_throw_season*100,1),
                                                                   shot_type == 'layup' ~ round(first_game_shot_layup_season*100,1),
                                                                   shot_type == 'other_fg' ~ round(first_game_shot_other_fg_season*100,1),
                                                                   shot_type == 'three_point' ~ round(first_game_shot_three_point_season*100,1),
                                                                   shot_type == 'two_point' ~ round(first_game_shot_two_season*100,1),
                                                                   shot_type == 'two_point_non_dunk' ~ round((first_game_shot_two_season - first_game_shot_dunk_season)*100,1)), "%)"),
         first_points_display = paste0(first_points, " (", case_when(shot_type == 'dunk' ~ round(first_game_points_dunk_season*100,1),
                                                                     shot_type == 'free_throw' ~ round(first_game_points_free_throw_season*100,1),
                                                                     shot_type == 'layup' ~ round(first_game_points_layup_season*100,1),
                                                                     shot_type == 'other_fg' ~ round(first_game_points_other_fg_season*100,1),
                                                                     shot_type == 'three_point' ~ round(first_game_points_three_point_season*100,1),
                                                                     shot_type == 'two_point' ~ round(first_game_points_two_season*100,1),
                                                                     shot_type == 'two_point_non_dunk' ~ round((first_game_points_two_season - first_game_points_dunk_season)*100,1)), "%)"),
         first_fga_display = paste0(first_fga, " (", case_when(shot_type == 'dunk' ~ round(first_game_fga_dunk_season*100,1),
                                                               shot_type == 'free_throw' ~ NA,
                                                               shot_type == 'layup' ~ round(first_game_fga_layup_season*100,1),
                                                               shot_type == 'other_fg' ~ round(first_game_fga_other_fg_season*100,1),
                                                               shot_type == 'three_point' ~ round(first_game_fga_three_point_season*100,1),
                                                               shot_type == 'two_point' ~ round(first_game_fga_two_season*100,1),
                                                               shot_type == 'two_point_non_dunk' ~ round((first_game_fga_two_season - first_game_fga_dunk_season)*100,1)), "%)"),
         first_fgm_display = paste0(first_fgm, " (", case_when(shot_type == 'dunk' ~ round(first_game_fgm_dunk_season*100,1),
                                                               shot_type == 'free_throw' ~ NA,
                                                               shot_type == 'layup' ~ round(first_game_fgm_layup_season*100,1),
                                                               shot_type == 'other_fg' ~ round(first_game_fgm_other_fg_season*100,1),
                                                               shot_type == 'three_point' ~ round(first_game_fgm_three_point_season*100,1),
                                                               shot_type == 'two_point' ~ round(first_game_fgm_two_season*100,1),
                                                               shot_type == 'two_point_non_dunk' ~ round((first_game_fgm_two_season - first_game_fgm_dunk_season)*100,1)), "%)"),
         line_points = coalesce(line_points_fd, line_points_ftics),
         prob_points = coalesce(prob_points_fd, prob_points_ftics)) %>%
  select(game, tipoff, team_abbreviation, games, shot_type_display, fg_type_pct, fga_ratio,
         #first_shots_display, first_points_display, line_points, prob_points,
         first_fga_display, first_fgm_display, line_fgm, prob_fgm)

# Store off Win Tipoff data
#TODO: Add team abbreviation to win tip projections?
win_tipoff_projections <-
  edges_win_tip %>%
  select(game, player_name, prob_tip, line_tip)

win_tipoff_data <-
  win_tipoff_projections %>%
  left_join(schedule_tidy, by = join_by(game)) %>%
  left_join(tip_trend_data, by = join_by(player_name, game)) %>%
  mutate(jump_ball_wins = round(jumps * win_tip_season, 0),
         jump_ball_wins_display = paste0(jump_ball_wins, " (", round(win_tip_season*100,1), "%)")) %>%
  select(game, tipoff, team_abbreviation, player_name, jumps, jump_ball_wins_display,
         line_tip, prob_tip)

# Store off Not First Basket data
not_first_basket_projections <-
  edges_fpts_not %>%
  select(game, team_abbreviation, player_name, prob_points, line_points, prob_fgm, line_fgm)

not_first_basket_data <-
  not_first_basket_projections %>%
  left_join(schedule_tidy, by = join_by(game)) %>%
  left_join(player_trend_data, by = join_by(player_name, team_abbreviation, game)) %>%
  mutate(not_first_shots = round(starts * (1-first_game_shot_overall_season), 0),
         not_first_points = round(starts * (1-first_game_points_overall_season), 0),
         not_first_fga = round(starts * (1-first_game_fga_overall_season), 0),
         not_first_fgm = round(starts * (1-first_game_fgm_overall_season), 0),
         not_first_shots_display = paste0(not_first_shots, " (", round((1 - first_game_shot_overall_season)*100,1), "%)"),
         not_first_points_display = paste0(not_first_points, " (", round((1 - first_game_points_overall_season)*100,1), "%)"),
         not_first_fga_display = paste0(not_first_fga, " (", round((1 - first_game_fga_overall_season)*100,1), "%)"),
         not_first_fgm_display = paste0(not_first_fgm, " (", round((1 - first_game_fgm_overall_season)*100,1), "%)")) %>%
  select(game, tipoff, team_abbreviation, player_name, starts, fgpct_season, usg_season,
         not_first_shots_display, not_first_points_display, line_points, prob_points)
         # not_first_fga_display, not_first_fgm_display, line_fgm, prob_fgm)
