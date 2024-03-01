tidyup_table_data <- function(raw_data, bet_type, schedule) {

  # make sure there are upcoming games
  validate(need(nrow(raw_data) > 0 & any(!is.na(raw_data$game)), "waiting for input..."))

  # make some tidy data
  tidy <- raw_data %>%
    select(where(function(x) !all(is.na(x)))) %>%
    pivot_longer(cols = where(function(x) is.numeric(x)),
                 values_drop_na = TRUE) %>%
    separate(name, c('book', 'type'))

  if ('quarter' %in% names(tidy)) {
    tidy <- tidy %>%
      filter(quarter == '1Q') %>%
      select(-quarter)
  }

  if (bet_type %in% c('win_tip')) {

    output <- tidy %>%
      group_by(player_name, game) %>%
      filter('line' %in% unique(type)) %>%
      mutate(line = value[type == 'line'],
             prob = value[type == 'prob'],
             units = value[type == 'units'],
             edge = value[type == 'edge'],
             tip_line = value[type == 'tip' & book == 'line'],
             tip_prob = value[type == 'tip' & book == 'prob']) %>%
      filter(!book %in% c('prob', 'line')) %>%
      mutate(max_edge = max(edge, na.rm=TRUE),
             is_max_edge = if_else(edge == max_edge, 1, 0)) %>%
      ungroup() %>%
      select(-type, -value) %>%
      distinct() %>%
      transmute(
        Player = player_name,
        # Team = team_abbreviation,
        # Date = game_date,
        # Tipoff = tipoff,
        Game = game,
        Book = book,
        Line = line,
        Prob = prob,
        `Proj Line` = tip_line,
        `Proj Prob` = tip_prob,
        Edge = edge,
        Units = units,
        is_max_edge
      )
    return(output)
  }
  else if (bet_type %in% c('fpts', 'fpts_team', 'ftts')) {
    if (bet_type == 'ftts') tidy$player_name <- 'Team'

    output <- tidy  %>%
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
        Prob = prob,
        `Proj Line` = if_else(book %in% c('fd'), points_line, fgm_line),
        `Proj Prob` = if_else(book %in% c('fd'), points_prob, fgm_prob),
        Edge = edge,
        Units = units,
        is_max_edge
      )
    return(output)
  }
  else if (bet_type %in% c('first_three', 'first_three_team')) {

    output <- tidy  %>%
      inner_join(schedule, by = c('team_abbreviation' = 'team')) %>%
      group_by(player_name, team_abbreviation, game, tipoff) %>%
      mutate(fgm_line = value[book == 'line' & type == 'fg3m'],
             fgm_prob = value[book == 'prob' & type == 'fg3m']) %>%
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
        Prob = prob,
        `Proj Line` = fgm_line,
        `Proj Prob` = fgm_prob,
        Edge = edge,
        Units = units,
        is_max_edge
      )
    return(output)

  }
  else if (bet_type %in% c('ftts_exact')) {

    almost_output <- tidy %>%
      mutate(join_col = if_else(team_abbreviation == 'Game', str_split(game, ' @ ', simplify = TRUE)[, 1], team_abbreviation)) %>%
      inner_join(schedule, by = c('join_col' = 'team')) %>%
      select(-join_col)

    points_output <- almost_output %>%
      group_by(shot_team, team_abbreviation, game, shot_type) %>%
      filter('line' %in% unique(book) & 'points' %in% unique(type)) %>%
      mutate(points_line = value[book == 'line' & type == 'points'],
             points_prob = value[book == 'prob' & type == 'points'])

    fgm_output <- almost_output %>%
      group_by(shot_team, team_abbreviation, game, shot_type) %>%
      filter('line' %in% unique(book) & 'fgm' %in% unique(type)) %>%
      mutate(fgm_line = value[book == 'line' & type == 'fgm'],
             fgm_prob = value[book == 'prob' & type == 'fgm'])

    output <- points_output %>%
      full_join(fgm_output) %>%
      filter(!book %in% c('prob', 'line')) %>%
      group_by(shot_team, team_abbreviation, book, game, tipoff, shot_type) %>%
      mutate(line = value[type == 'line'],
             prob = value[type == 'prob'],
             units = value[type == 'units'],
             edge = value[type == 'edge']) %>%
      ungroup() %>%
      filter(type %in% c('line', 'prob', 'units')) %>%
      group_by(shot_team, team_abbreviation, game, tipoff, shot_type) %>%
      mutate(max_edge = max(edge, na.rm=TRUE),
             is_max_edge = if_else(edge == max_edge, 1, 0)) %>%
      ungroup() %>%
      select(-type, -value) %>%
      distinct() %>%
      transmute(
        Player = if_else(team_abbreviation == 'Game', 'Game', 'Team'),
        Team = team_abbreviation,
        Date = game_date,
        Tipoff = tipoff,
        Game = game,
        `Shot Type` = shot_type,
        Book = book,
        Line = line,
        Prob = prob,
        `Proj Line` = if_else(book %in% c('fd'), points_line, fgm_line),
        `Proj Prob` = if_else(book %in% c('fd'), points_prob, fgm_prob),
        Edge = edge,
        Units = units,
        is_max_edge
      )

    return(output)

  }
  else if (bet_type %in% c('fpts_exact', 'fpts_team_exact')) {

    almost_output <- tidy %>%
      inner_join(schedule, by = c('team_abbreviation' = 'team'))

    points_output <- almost_output %>%
      group_by(player_name, team_abbreviation, game, shot_type) %>%
      filter('line' %in% unique(book) & 'points' %in% unique(type)) %>%
      mutate(points_line = value[book == 'line' & type == 'points'],
             points_prob = value[book == 'prob' & type == 'points'])

    fgm_output <- almost_output %>%
      group_by(player_name, team_abbreviation, game, shot_type) %>%
      filter('line' %in% unique(book) & 'fgm' %in% unique(type)) %>%
      mutate(fgm_line = value[book == 'line' & type == 'fgm'],
             fgm_prob = value[book == 'prob' & type == 'fgm'])

    output <- points_output %>%
      full_join(fgm_output) %>%
      filter(!book %in% c('prob', 'line')) %>%
      group_by(player_name, team_abbreviation, book, tipoff, shot_type) %>%
      mutate(line = value[type == 'line'],
             prob = value[type == 'prob'],
             units = value[type == 'units'],
             edge = value[type == 'edge']) %>%
      ungroup() %>%
      filter(type %in% c('line', 'prob', 'units')) %>%
      group_by(player_name, team_abbreviation, game, tipoff, shot_type) %>%
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
        `Shot Type` = shot_type,
        Book = book,
        Line = line,
        Prob = prob,
        `Proj Line` = if_else(book %in% c('fd'), points_line, fgm_line),
        `Proj Prob` = if_else(book %in% c('fd'), points_prob, fgm_prob),
        Edge = edge,
        Units = units,
        is_max_edge
      )
    return(output)
  }

}
