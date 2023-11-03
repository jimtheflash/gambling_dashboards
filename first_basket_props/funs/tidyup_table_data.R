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
      mutate(player_name = 'Team') %>%
      filter(quarter == '1Q')

  }
# browser()
  # make some tidy data
  tidy <- raw_data %>%
    select(where(function(x) !all(is.na(x)))) %>%
    pivot_longer(cols = where(function(x) is.numeric(x)),
                 values_drop_na = TRUE) %>%
    separate(name, c('book', 'type')) %>%
    inner_join(schedule, by = c('team_abbreviation' = 'team')) %>%
    group_by(player_name, team_abbreviation, game, tipoff) %>%
    mutate(points_line = value[book == 'line' & type == 'points'],
           fgm_line = value[book == 'line' & type == 'fgm'],
           points_prob = value[book == 'prob' & type == 'points'],
           fgm_prob = value[book == 'prob' & type == 'fgm']) %>%
    ungroup() %>%
    filter(!book %in% c('prob', 'line')) %>%
    group_by(player_name, team_abbreviation, book, tipoff) %>%
    mutate(line = value[type == 'line'],
           prob = value[type == 'prob'],
           units = value[type == 'units'],
           edge = value[type == 'edge']) %>%
    ungroup() %>%
    filter(type %in% c('line', 'prob', 'units')) %>%
    group_by(player_name, team_abbreviation, game, tipoff) %>%
    mutate(max_edge = max(edge, na.rm=TRUE),
           is_max_edge = if_else(edge == max_edge, 1, 0)) %>%
    ungroup() %>%
    select(-type, -value) %>%
    distinct() %>%
    transmute(
      Player = player_name,
      Team = team_abbreviation,
      Date = game_date,
      Tipoff = tipoff,
      Game = game,
      Book = book,
      Line = line,
      `Proj Line` = if_else(book %in% c('csr', 'fd'), points_line, fgm_line),
      `Proj Prob` = if_else(book %in% c('csr', 'fd'), points_prob, fgm_prob),
      Edge = edge,
      Units = units,
      is_max_edge
    )
  return(tidy)

}
