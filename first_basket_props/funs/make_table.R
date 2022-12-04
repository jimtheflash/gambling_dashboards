make_table <- function(table_data, type = 'player') {

  validate(need(nrow(table_data) > 0, "waiting for input..."))

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
        Player = colDef(align = 'left', width = 210),
        Team = colDef(align = 'left', width = 60, aggregate = "max"),
        Date = colDef(align = 'left', width = 90, aggregate = "max"),
        Game = colDef(align = 'left', width = 120, aggregate = "max"),
        Book = colDef(align = 'left', width = 210, aggregate = "unique"),
        Line = colDef(align = 'right', width = 90, format = colFormat(prefix = '+'), aggregate = "max"),
        `Proj Line` = colDef(align = 'right', width = 120, format = colFormat(prefix = '+'), aggregate = "max"),
        Edge = colDef(align = 'right', width = 75, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Units = colDef(align = 'right', width = 75, format = colFormat(suffix = 'u', digits = 2), aggregate = "max")
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
        Date = colDef(align = 'left', width = 105, aggregate = "max"),
        Game = colDef(align = 'left', width = 120, aggregate = "max"),
        Book = colDef(align = 'left', width = 210, aggregate = "unique"),
        Line = colDef(align = 'right', width = 90, cell = add_plus_JS(), aggregated = add_plus_JS(), aggregate = "max"),
        `Proj Line` = colDef(align = 'right', width = 120, cell = add_plus_JS(), aggregated = add_plus_JS(), aggregate = "max"),
        Edge = colDef(align = 'right', width = 75, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Units = colDef(align = 'right', width = 75, format = colFormat(suffix = 'u', digits = 2), aggregate = "max")
      ))
  }

  output
}
