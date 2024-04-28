
server <- function(input, output, session) {

  # restart if necessary
  restart_app()

  # Render first basket reactable
  output$first_basket <- generate_tab_rendering_logic(
    first_basket_data,
    list(tipoff = 'asc', game = 'asc', prob_fgm = 'desc'),
    list(
      game = colDef(name = "Game"),
      tipoff = colDef(name = "Tipoff"),
      team_abbreviation = colDef(name = "Team", width = 60),
      player_name = colDef(name = "Player", width = calculate_column_width(first_basket_data, "player_name"), style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      starts = colDef(name = "Starts", defaultSortOrder = 'desc', width = 60),
      fgpct_season = percent_column("FG%"),
      usg_season = percent_column("USG%", style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      first_shots_display = colDef(name = "First Shots (Rate)"),
      first_points_display = colDef(name = "First Points (Rate)"),
      line_points = colDef(name = "First Points Model Line", defaultSortOrder = 'asc'),
      prob_points = color_percent_column("First Points Model Prob", first_basket_data, "prob_points"),
      first_fga_display = colDef(name = "First FGA (Rate)"),
      first_fgm_display = colDef(name = "First FGM (Rate)"),
      prob_fgm = color_percent_column("First FGM Model Prob", first_basket_data, "prob_fgm"),
      line_fgm = colDef(name = "First FGM Model Line", defaultSortOrder = 'asc')
    ),
    list(
      colGroup(name = "Stats", columns = c("starts", "fgpct_season", "usg_season")),
      colGroup(name = "Points (CSR/ESPN/FD)", columns = c("prob_points", "line_points", "first_shots_display", "first_points_display")),
      colGroup(name = "FGM (BR/DK/FTICS/MGM)", columns = c("prob_fgm", "line_fgm", "first_fga_display", "first_fgm_display"))
    )
  )

  # Render first basket exact reactable
  output$first_basket_exact <- generate_tab_rendering_logic(
    first_basket_exact_data,
    list(tipoff = 'asc', game = 'asc', player_name = 'asc', shot_type_display = 'asc'),
    list(
      game = colDef(name = "Game"),
      tipoff = colDef(name = "Tipoff"),
      team_abbreviation = colDef(name = "Team", width = 60),
      player_name = colDef(name = "Player", width = calculate_column_width(first_basket_exact_data, "player_name")),
      shot_type_display = colDef(name = "Shot Type", width = calculate_column_width(first_basket_exact_data, "shot_type_display"), style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      starts = colDef(name = "Starts", defaultSortOrder = 'desc', width = 60),
      fg_type_pct = percent_column("Shot Type FG%"),
      fga_ratio = percent_column("Shot Type Ratio of FGA"),
      usg_season = percent_column("USG%", style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      first_shots_display = colDef(name = "First Shots (Rate)"),
      first_points_display = colDef(name = "First Points (Rate)"),
      line_points = colDef(name = "First Points Model Line", defaultSortOrder = 'asc'),
      prob_points = color_percent_column("First Points Model Prob", first_basket_exact_data, "prob_points"),
      first_fga_display = colDef(name = "First FGA (Rate)"),
      first_fgm_display = colDef(name = "First FGM (Rate)"),
      prob_fgm = color_percent_column("First FGM Model Prob", first_basket_exact_data, "prob_fgm"),
      line_fgm = colDef(name = "First FGM Model Line", defaultSortOrder = 'asc')
    ),
    list(
      colGroup(name = "Stats", columns = c("starts", "fg_type_pct", "fga_ratio", "usg_season")),
      colGroup(name = "Points (FD)", columns = c("prob_points", "line_points", "first_shots_display", "first_points_display")),
      colGroup(name = "FGM (CSR/DK/ESPN/MGM)", columns = c("prob_fgm", "line_fgm", "first_fga_display", "first_fgm_display"))
    )
  )

  # Render first basket by team reactable
  output$first_basket_by_team <- generate_tab_rendering_logic(
    first_basket_by_team_data,
    list(tipoff = 'asc', game = 'asc', team_abbreviation = 'asc', prob_fgm = 'desc'),
    list(
      game = colDef(name = "Game"),
      tipoff = colDef(name = "Tipoff"),
      team_abbreviation = colDef(name = "Team"),
      player_name = colDef(name = "Player", width = calculate_column_width(first_basket_by_team_data, "player_name"), style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      starts = colDef(name = "Starts", defaultSortOrder = 'desc'),
      fgpct_season = percent_column("FG%"),
      usg_season = percent_column("USG%", style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      first_shots_display = colDef(name = "First Shots (Rate)"),
      first_points_display = colDef(name = "First Points (Rate)"),
      prob_points = color_percent_column("First Points Model Prob", first_basket_by_team_data, "prob_points"),
      line_points = colDef(name = "First Points Model Line", defaultSortOrder = 'asc'),
      first_fga_display = colDef(name = "First FGA (Rate)"),
      first_fgm_display = colDef(name = "First FGM (Rate)"),
      prob_fgm = color_percent_column("First FGM Model Prob", first_basket_by_team_data, "prob_fgm"),
      line_fgm = colDef(name = "First FGM Model Line", defaultSortOrder = 'asc')
    ),
    list(
      colGroup(name = "Stats", columns = c("starts", "fgpct_season", "usg_season")),
      colGroup(name = "Points (FD)", columns = c("prob_points", "line_points", "first_shots_display", "first_points_display")),
      colGroup(name = "FGM (CSR/DK/ESPN/MGM)", columns = c("prob_fgm", "line_fgm", "first_fga_display", "first_fgm_display"))
    )
  )

  # Render first basket by team exact reactable
  output$first_basket_by_team_exact <- generate_tab_rendering_logic(
    first_basket_by_team_exact_data,
    list(tipoff = 'asc', game = 'asc', team_abbreviation = 'asc', player_name = 'asc', shot_type_display = 'asc'),
    list(
      game = colDef(name = "Game"),
      tipoff = colDef(name = "Tipoff"),
      team_abbreviation = colDef(name = "Team", width = 60),
      player_name = colDef(name = "Player", width = calculate_column_width(first_basket_by_team_exact_data, "player_name")),
      shot_type_display = colDef(name = "Shot Type", width = calculate_column_width(first_basket_by_team_exact_data, "shot_type_display"), style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      starts = colDef(name = "Starts", defaultSortOrder = 'desc', width = 60),
      fg_type_pct = percent_column("Shot Type FG%"),
      fga_ratio = percent_column("Shot Type Ratio of FGA"),
      usg_season = percent_column("USG%", style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      # first_shots_display = colDef(name = "First Shots (Rate)"),
      # first_points_display = colDef(name = "First Points (Rate)"),
      # line_points = colDef(name = "First Points Model Line", defaultSortOrder = 'asc'),
      # prob_points = color_percent_column("First Points Model Prob", first_basket_by_team_exact_data, "prob_points"),
      first_fga_display = colDef(name = "First FGA (Rate)"),
      first_fgm_display = colDef(name = "First FGM (Rate)"),
      prob_fgm = color_percent_column("First FGM Model Prob", first_basket_by_team_exact_data, "prob_fgm"),
      line_fgm = colDef(name = "First FGM Model Line", defaultSortOrder = 'asc')
    ),
    list(
      colGroup(name = "Stats", columns = c("starts", "fg_type_pct", "fga_ratio", "usg_season")),
      #colGroup(name = "Points", columns = c("prob_points", "line_points", "first_shots_display", "first_points_display")),
      colGroup(name = "FGM (CSR/DK/ESPN)", columns = c("prob_fgm", "line_fgm", "first_fga_display", "first_fgm_display"))
    )
  )

  # Render first three reactable
  output$first_three <- generate_tab_rendering_logic(
    first_three_data,
    list(tipoff = 'asc', game = 'asc', prob_fg3m = 'desc'),
    list(
      game = colDef(name = "Game"),
      tipoff = colDef(name = "Tipoff"),
      team_abbreviation = colDef(name = "Team"),
      player_name = colDef(name = "Player", width = calculate_column_width(first_three_data, "player_name"), style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      starts = colDef(name = "Starts", defaultSortOrder = 'desc'),
      fg_three_pct_season = percent_column("3FG%"),
      fga_three_ratio_season = percent_column("3PA Ratio", style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      first_three_attempts_display = percent_column("First Three Attempts (Rate)"),
      first_three_makes_display = percent_column("First Three Makes (Rate)"),
      prob_fg3m = color_percent_column("First Three Prob", first_three_data, "prob_fg3m"),
      line_fg3m = colDef(name = "First Three Model Line", defaultSortOrder = 'asc')
    ),
    list(
      colGroup(name = "Stats", columns = c("starts", "fg_three_pct_season", "fga_three_ratio_season")),
      colGroup(name = "Three", columns = c("prob_fg3m", "line_fg3m", "first_three_attempts_display", "first_three_makes_display"))
    )
  )

  # Render first three by team reactable
  output$first_three_by_team <- generate_tab_rendering_logic(
    first_three_by_team_data,
    list(tipoff = 'asc', game = 'asc', team_abbreviation = 'asc', prob_fg3m = 'desc'),
    list(
      game = colDef(name = "Game"),
      tipoff = colDef(name = "Tipoff"),
      team_abbreviation = colDef(name = "Team"),
      player_name = colDef(name = "Player", width = calculate_column_width(first_three_by_team_data, "player_name"), style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      starts = colDef(name = "Starts", defaultSortOrder = 'desc'),
      fg_three_pct_season = percent_column("3FG%"),
      fga_three_ratio_season = percent_column("3PA Ratio", style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      first_three_attempts_display = percent_column("First Three Attempts (Rate)"),
      first_three_makes_display = percent_column("First Three Makes (Rate)"),
      prob_fg3m = color_percent_column("First Three Prob", first_three_by_team_data, "prob_fg3m"),
      line_fg3m = colDef(name = "First Three Model Line", defaultSortOrder = 'asc')
    ),
    list(
      colGroup(name = "Stats", columns = c("starts", "fg_three_pct_season", "fga_three_ratio_season")),
      colGroup(name = "Three", columns = c("prob_fg3m", "line_fg3m", "first_three_attempts_display", "first_three_makes_display"))
    )
  )

  # Render first team reactable
  output$first_team <- generate_tab_rendering_logic(
    first_team_data,
    list(tipoff = 'asc', game = 'asc', prob_fgm = 'desc'),
    list(
      game = colDef(name = "Game"),
      tipoff = colDef(name = "Tipoff"),
      team_abbreviation = colDef(name = "Team", width = 60, style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      games = colDef(name = "Games", defaultSortOrder = 'desc', width = 65),
      fgpct_season = percent_column("FG%", style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      first_shots_display = colDef(name = "First Shots (Rate)"),
      first_points_display = colDef(name = "First Points (Rate)"),
      line_points = colDef(name = "First Points Model Line", defaultSortOrder = 'asc'),
      prob_points = color_percent_column("First Points Model Prob", first_team_data, "prob_points"),
      first_fga_display = colDef(name = "First FGA (Rate)"),
      first_fgm_display = colDef(name = "First FGM (Rate)"),
      prob_fgm = color_percent_column("First FGM Model Prob", first_team_data, "prob_fgm"),
      line_fgm = colDef(name = "First FGM Model Line", defaultSortOrder = 'asc')
    ),
    list(
      colGroup(name = "Stats", columns = c("games", "fgpct_season")),
      colGroup(name = "Points (BR)", columns = c("prob_points", "line_points", "first_shots_display", "first_points_display")),
      colGroup(name = "FGM (CSR/DK)", columns = c("prob_fgm", "line_fgm", "first_fga_display", "first_fgm_display"))
    )
  )

  # Render first team exact reactable
  output$first_team_exact <- generate_tab_rendering_logic(
    first_team_exact_data,
    list(tipoff = 'asc', game = 'asc', team_abbreviation = 'asc', shot_type_display = 'asc'),
    list(
      game = colDef(name = "Game"),
      tipoff = colDef(name = "Tipoff"),
      team_abbreviation = colDef(name = "Team", width = 60),
      shot_type_display = colDef(name = "Shot Type", width = calculate_column_width(first_team_exact_data, "shot_type_display"), style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      games = colDef(name = "Games", defaultSortOrder = 'desc', width = 65),
      fg_type_pct = percent_column("Shot Type FG%"),
      fga_ratio = percent_column("Shot Type Ratio of FGA"),
      # first_shots_display = colDef(name = "First Shots (Rate)"),
      # first_points_display = colDef(name = "First Points (Rate)"),
      # line_points = colDef(name = "First Points Model Line", defaultSortOrder = 'asc'),
      # prob_points = color_percent_column("First Points Model Prob", first_team_exact_data, "prob_points"),
      first_fga_display = colDef(name = "First FGA (Rate)"),
      first_fgm_display = colDef(name = "First FGM (Rate)"),
      prob_fgm = color_percent_column("First FGM Model Prob", first_team_exact_data, "prob_fgm"),
      line_fgm = colDef(name = "First FGM Model Line", defaultSortOrder = 'asc')
    ),
    list(
      colGroup(name = "Stats", columns = c("games", "fg_type_pct", "fga_ratio")),
      #colGroup(name = "Points", columns = c("prob_points", "line_points", "first_shots_display", "first_points_display")),
      colGroup(name = "FGM", columns = c("prob_fgm", "line_fgm", "first_fga_display", "first_fgm_display"))
    )
  )

  # Render win tip reactable
  output$win_tipoff <- generate_tab_rendering_logic(
    win_tipoff_data,
    list(tipoff = 'asc', game = 'asc', prob_tip = 'desc'),
    list(
      game = colDef(name = "Game"),
      tipoff = colDef(name = "Tipoff"),
      team_abbreviation = colDef(name = "Team"),
      player_name = colDef(name = "Player", width = calculate_column_width(win_tipoff_data, "player_name"), style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      jumps = colDef(name = "Tipoffs", defaultSortOrder = 'desc'),
      jump_ball_wins_display = percent_column("Tipoffs Won (Rate)"),
      prob_tip = color_percent_column("Win Tip Model Prob", win_tipoff_data, "prob_tip"),
      line_tip = colDef(name = "Win Tip Model Line", defaultSortOrder = 'asc')
    ),
    list(
      colGroup(name = "Tips", columns = c("jumps", "prob_tip", "line_tip", "jump_ball_wins_display"))
    )
  )

  # Render not first basket reactable
  output$not_first_basket <- generate_tab_rendering_logic(
    not_first_basket_data,
    list(tipoff = 'asc', game = 'asc', prob_points = 'desc'),
    list(
      game = colDef(name = "Game"),
      tipoff = colDef(name = "Tipoff"),
      team_abbreviation = colDef(name = "Team", width = 60),
      player_name = colDef(name = "Player", width = calculate_column_width(not_first_basket_data, "player_name"), style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      starts = colDef(name = "Starts", defaultSortOrder = 'desc', width = 60),
      fgpct_season = percent_column("FG%"),
      usg_season = percent_column("USG%", style = list(borderRight = "2px solid rgba(0, 0, 0, 1)")),
      not_first_shots_display = colDef(name = "Not First Shots (Rate)"),
      not_first_points_display = colDef(name = "Not First Points (Rate)"),
      line_points = colDef(name = "Not First Points Model Line", defaultSortOrder = 'asc'),
      prob_points = color_percent_column("Not First Points Model Prob", not_first_basket_data, "prob_points")
      # not_first_fga_display = colDef(name = "Not First FGA (Rate)"),
      # not_first_fgm_display = colDef(name = "Not First FGM (Rate)"),
      # prob_fgm = color_percent_column("Not First FGM Model Prob", not_first_basket_data, "prob_fgm"),
      # line_fgm = colDef(name = "Not First FGM Model Line", defaultSortOrder = 'asc')
    ),
    list(
      colGroup(name = "Stats", columns = c("starts", "fgpct_season", "usg_season")),
      colGroup(name = "Points (ESPN)", columns = c("prob_points", "line_points", "not_first_shots_display", "not_first_points_display"))
      # colGroup(name = "FGM", columns = c("prob_fgm", "line_fgm", "not_first_fga_display", "not_first_fgm_display"))
    )
  )

}
