# TODO: move the filters here so that they don't completely recreate the data
make_table <- function(table_data, type = 'player') {
  if (type == 'player') {
    output <- reactable(
      table_data,
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
        `Proj Prob` = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Edge = colDef(align = 'right', width = 75, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Units = colDef(align = 'right', width = 75, format = colFormat(digits = 2), aggregate = "max"),
        is_max_edge = colDef(show = FALSE)
      )
    )
    return(output)
  }

  if (type == 'team') {
    output <- reactable(
      table_data %>% select(-Player),
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
        Book = colDef(align = 'left', width = 210, aggregate = "unique"),
        Line = colDef(align = 'right', width = 90, format = colFormat(prefix = '+'), aggregate = "max"),
        `Proj Line` = colDef(align = 'right', width = 120, format = colFormat(prefix = '+'), aggregate = "max"),
        `Proj Prob` = colDef(align = 'right', width = 120, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Edge = colDef(align = 'right', width = 75, format = colFormat(percent = TRUE, digits = 2), aggregate = "max"),
        Units = colDef(align = 'right', width = 75, format = colFormat(digits = 2), aggregate = "max"),
        is_max_edge = colDef(show = FALSE)
      )
    )

    return(output)
  }

}

