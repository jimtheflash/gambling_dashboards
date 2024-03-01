make_table <- function(table_data, type = 'player', exact = FALSE, win_tip = FALSE) {
  if (type == 'player' & win_tip == TRUE) {
    output <- reactable(
      table_data %>%
        mutate(Line = ifelse(Line > 0, paste0("+", Line), Line),
               `Proj Line` = ifelse(`Proj Line` > 0, paste0("+", `Proj Line`), `Proj Line`)),
      rownames = FALSE,
      pagination = FALSE,
      filterable = TRUE,
      sortable = TRUE,
      defaultSorted = list(Edge = 'desc'),
      groupBy = c("Player"),
      columns = list(
        Player = colDef(align = 'left', width = 225),
        # Team = colDef(align = 'left', width = 60, aggregate = "max"),
        # Date = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(date = TRUE)),
        # Tipoff = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(time = TRUE)),
        Game = colDef(align = 'left', width = 120, aggregate = "max"),
        Book = colDef(align = 'left', width = 200, aggregate = "unique"),
        Line = colDef(align = 'right', width = 90, aggregate = "max"),
        Prob = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        `Proj Line` = colDef(align = 'right', width = 90, aggregate = "max"),
        `Proj Prob` = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Edge = colDef(align = 'right', width = 75, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Units = colDef(align = 'right', width = 75, format = colFormat(digits = 2), aggregate = "max"),
        is_max_edge = colDef(show = FALSE)
      )
    )
    return(output)
  }
  else if (type == 'player' & exact == FALSE & win_tip == FALSE) {
    output <- reactable(
      table_data %>%
        mutate(Line = ifelse(Line > 0, paste0("+", Line), Line),
               `Proj Line` = ifelse(`Proj Line` > 0, paste0("+", `Proj Line`), `Proj Line`)),
      rownames = FALSE,
      pagination = FALSE,
      filterable = TRUE,
      sortable = TRUE,
      defaultSorted = list(Edge = 'desc'),
      groupBy = c("Player"),
      columns = list(
        Player = colDef(align = 'left', width = 225),
        Team = colDef(align = 'left', width = 60, aggregate = "max"),
        Date = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(date = TRUE)),
        Tipoff = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(time = TRUE)),
        Game = colDef(align = 'left', width = 120, aggregate = "max"),
        Book = colDef(align = 'left', width = 200, aggregate = "unique"),
        Line = colDef(align = 'right', width = 90, aggregate = "max"),
        Prob = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        `Proj Line` = colDef(align = 'right', width = 90, aggregate = "max"),
        `Proj Prob` = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Edge = colDef(align = 'right', width = 75, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Units = colDef(align = 'right', width = 75, format = colFormat(digits = 2), aggregate = "max"),
        is_max_edge = colDef(show = FALSE)
      )
    )
    return(output)
  }
  else if (type == 'player' & exact == TRUE) {
    output <- reactable(
      table_data %>%
        mutate(Line = ifelse(Line > 0, paste0("+", Line), Line),
               `Proj Line` = ifelse(`Proj Line` > 0, paste0("+", `Proj Line`), `Proj Line`)),
      rownames = FALSE,
      pagination = FALSE,
      filterable = TRUE,
      sortable = TRUE,
      defaultSorted = list(Edge = 'desc'),
      columns = list(
        Player = colDef(align = 'left', width = 225),
        Team = colDef(align = 'left', width = 60, aggregate = "max"),
        Date = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(date = TRUE)),
        Tipoff = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(time = TRUE)),
        Game = colDef(align = 'left', width = 120, aggregate = "max"),
        `Shot Type` = colDef(align = 'left', width = 90, aggregate = "unique"),
        Book = colDef(align = 'left', width = 90, aggregate = "unique"),
        Line = colDef(align = 'right', width = 90, aggregate = "max"),
        Prob = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        `Proj Line` = colDef(align = 'right', width = 90, aggregate = "max"),
        `Proj Prob` = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Edge = colDef(align = 'right', width = 75, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Units = colDef(align = 'right', width = 75, format = colFormat(digits = 2), aggregate = "max"),
        is_max_edge = colDef(show = FALSE)
      )
    )
    return(output)
  }
  else if (type == 'team' & exact == FALSE) {
    output <- reactable(
      table_data %>%
        select(-Player) %>%
        mutate(Line = ifelse(Line > 0, paste0("+", Line), Line),
               `Proj Line` = ifelse(`Proj Line` > 0, paste0("+", `Proj Line`), `Proj Line`)),
      defaultColDef = colDef(),
      rownames = FALSE,
      pagination = FALSE,
      filterable = TRUE,
      sortable = TRUE,
      defaultSorted = list(Edge = 'desc'),
      groupBy = c("Team"),
      columns = list(
        Team = colDef(align = 'left', width = 200, aggregate = "max"),
        Date = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(date = TRUE)),
        Tipoff = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(time = TRUE)),
        Game = colDef(align = 'left', width = 120, aggregate = "max"),
        Book = colDef(align = 'left', width = 200, aggregate = "unique"),
        Line = colDef(align = 'right', width = 90, aggregate = "max"),
        Prob = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        `Proj Line` = colDef(align = 'right', width = 90, aggregate = "max"),
        `Proj Prob` = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Edge = colDef(align = 'right', width = 75, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Units = colDef(align = 'right', width = 75, format = colFormat(digits = 2), aggregate = "max"),
        is_max_edge = colDef(show = FALSE)
      )
    )
    return(output)
  }
  else if (type == 'team' & exact == TRUE) {

    output <- reactable(
      table_data %>%
        select(-Player) %>%
        mutate(Line = ifelse(Line > 0, paste0("+", Line), Line),
               `Proj Line` = ifelse(`Proj Line` > 0, paste0("+", `Proj Line`), `Proj Line`)),
      defaultColDef = colDef(),
      rownames = FALSE,
      pagination = FALSE,
      filterable = TRUE,
      sortable = TRUE,
      defaultSorted = list(Edge = 'desc'),
      columns = list(
        Team = colDef(align = 'left', width = 200, aggregate = "max"),
        Date = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(date = TRUE)),
        Tipoff = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(time = TRUE)),
        Game = colDef(align = 'left', width = 120, aggregate = "max"),
        Book = colDef(align = 'left', width = 200, aggregate = "unique"),
        Line = colDef(align = 'right', width = 90, aggregate = "max"),
        Prob = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        `Proj Line` = colDef(align = 'right', width = 90, aggregate = "max"),
        `Proj Prob` = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Edge = colDef(align = 'right', width = 75, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Units = colDef(align = 'right', width = 75, format = colFormat(digits = 2), aggregate = "max"),
        is_max_edge = colDef(show = FALSE)
      )
    )
    return(output)
  }
  else stop('you did something wrong here, check your server args')
}

