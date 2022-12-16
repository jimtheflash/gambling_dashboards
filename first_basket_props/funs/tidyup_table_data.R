tidyup_table_data <- function(raw_data, bet_type, inputs, schedule) {

  # make sure there are upcoming games
  validate(need(nrow(raw_data) > 0 & any(!is.na(raw_data$game)), "waiting for input..."))

  # do some filtering as needed by bet_type
  if (bet_type == 'fpts_team') {
    names(raw_data) <- gsub('fpts_team', 'fptsteam', names(raw_data))
    bet_type <- 'fptsteam'
  }

  if (bet_type == 'ftts') {
    raw_data <- raw_data %>%
      mutate(player = 'Team') %>%
      filter(quarter == '1Q')

  }

  # make some tidy data
  tidy <- raw_data %>%
    pivot_longer(cols = where(function(x) is.numeric(x)),
                 values_drop_na = TRUE) %>%
    separate(name, c('book', 'type')) %>%
    filter(type != 'kelly') %>%
    pivot_wider(names_from = type,
                values_from = value) %>%
    group_by(player, team) %>%
    mutate(proj_line = max(line[book == bet_type], na.rm = TRUE),
           proj_prob = max(prob[book == bet_type], na.rm = TRUE)) %>%
    filter(book != bet_type) %>%
    mutate(best_odds = max(line),
           best_prob = max(prob),
           best_edge = max(edge),
           is_best_edge = if_else(edge == best_edge, TRUE, FALSE)) %>%
    ungroup() %>%
    inner_join(schedule, by = 'team') %>%
    transmute(
      'Player' = player,
      'Team' = team,
      'Date'  = as.Date(tipoff),
      'Tipoff' = tipoff,
      'Game' = game,
      'Book' = book,
      'Line' = line,
      'Proj Line' = proj_line,
      'Edge' = edge,
      'Wager' = units * inputs$unitsize,
      is_best_edge
    )

  # apply the filters
  if (inputs$bestodds == TRUE) {
    tidy <- tidy %>% filter(is_best_edge == TRUE)
  }

  tidy <- tidy %>% filter(Edge > inputs$minedge)

  return(tidy)

}
