
make_table <- function(table_data, type = 'player') {

  if (type == 'player') {
    output <- reactable(
      table_data %>% select(-is_best_edge),
      defaultColDef = colDef(),
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
        Book = colDef(align = 'left', width = 210, aggregate = "unique"),
        Line = colDef(align = 'right', width = 90, format = colFormat(prefix = '+'), aggregate = "max"),
        `Proj Line` = colDef(align = 'right', width = 120, format = colFormat(prefix = '+'), aggregate = "max"),
        Edge = colDef(align = 'right', width = 75, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Wager = colDef(align = 'right', width = 75, format = colFormat(currency = "USD"), aggregate = "max")
      ))
  }
  if (type == 'team') {
    output <- reactable(
      table_data %>% select(-Player, -is_best_edge),
      defaultColDef = colDef(),
      rownames = FALSE,
      pagination = FALSE,
      filterable = TRUE,
      sortable = TRUE,
      defaultSorted = list(Edge = 'desc'),
      groupBy = c("Team"),
      columns = list(
        Team = colDef(align = 'left', width = 90, aggregate = "max"),
        Date = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(date = TRUE)),
        Tipoff = colDef(align = 'right', width = 105, aggregate = "max", format = colFormat(time = TRUE)),
        Game = colDef(align = 'left', width = 120, aggregate = "max"),
        Book = colDef(align = 'left', width = 210, aggregate = "unique"),
        Line = colDef(align = 'right', width = 90, cell = add_plus_JS(), aggregated = add_plus_JS(), aggregate = "max"),
        `Proj Line` = colDef(align = 'right', width = 120, cell = add_plus_JS(), aggregated = add_plus_JS(), aggregate = "max"),
        Edge = colDef(align = 'right', width = 75, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Wager = colDef(align = 'right', width = 75, format = colFormat(currency = "USD"), aggregate = "max")
      ))
  }

  output
}
