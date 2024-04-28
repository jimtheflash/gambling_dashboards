
make_timestamp_string <- function(utc_timestamp) {
  datetime <- as_datetime(utc_timestamp)
  paste0('Table data last updated at: ', format(with_tz(datetime), '%x %I:%M %p %Z'))
}

tidyup_schedule <- function(schedule) {

  # assumes this is still in ET
  schedule %>%
    mutate(tipoff_striptime = strptime(schedule$GAME_STATUS_TEXT, format = "%I:%M %p", tz = "EST5EDT")) %>%
    mutate(datetime_et = with_tz(tipoff_striptime, tzone = "America/New_York")) %>%
    mutate(tipoff = format(datetime_et, "%I:%M %p ET")) %>%
    separate(GAMECODE, c("date", "teams")) %>%
    mutate(game = paste(substring(teams, 1, 3), "@", substring(teams, 4, 6), sep = " ")) %>%
    select(game, tipoff)
    # transmute(
    #   tipoff,
    #   away_team = substr(teams, 1, 3),
    #   home_team = substr(teams, 4, 6)
    # ) %>%
    # pivot_longer(
    #   -tipoff
    # ) %>%
    # transmute(team = value,
    #           tipoff)
}

add_plus_JS <- function() {
  JS("function(cellInfo) {
      if (cellInfo.value > 0) {
       return '+' + cellInfo.value
      } else {
       return cellInfo.value
      }
     }"
  )
}

restart_app <- function() {
  if (file.exists('restart.txt')) {
    system('touch restart.txt')
  } else {
    file.create('restart.txt')
  }
}

read_csv_from_private_repo <- function(csv_path, pat) {
  auth <- httr::authenticate(pat, "")
  resp <- httr::GET(csv_path, auth)
  txt <- httr::content(resp, "text")
  readr::read_csv(txt, show_col_types = FALSE)
}

# Define the orange color palette
orange_pal <- function(x) rgb(colorRamp(c("#ffe4cc", "#ffb54d"))(x), maxColorValue = 255)

# Define a generic function for column styling
column_style <- function(data, column_name) {
  function(value) {
    if (is.na(value)) {
      list(background = "white",
           borderRight = "2px solid rgba(0, 0, 0, 1)")
    } else {
      normalized <- (value - min(data[[column_name]], na.rm = TRUE)) /
        (max(data[[column_name]], na.rm = TRUE) - min(data[[column_name]], na.rm = TRUE))
      color <- orange_pal(normalized)
      list(background = color,
           borderRight = "2px solid rgba(0, 0, 0, 1)")
    }
  }
}

# Function to calculate column width dynamically
calculate_column_width <- function(data, column_name) {
  max_content_length <- max(nchar(as.character(data[[column_name]])), na.rm = TRUE)
  if (max_content_length <= 10) {
    return(10)  # Default width if content length is less than or equal to 10
  } else {
    return(max_content_length * 8.5)  # Adjust width based on content length
  }
}

# Default settings for percent based columns
percent_column <- function(name, style = NULL) {
  colDef(name = name,
         defaultSortOrder = 'desc',
         format = colFormat(percent = TRUE, digits = 1),
         style = style)
}

# Default settings for colored percent columns
color_percent_column <- function(name, data, col) {
  colDef(name = name,
         defaultSortOrder = 'desc',
         format = colFormat(percent = TRUE, digits = 1),
         sortable = TRUE,
         style = column_style(data, col))
}

# Function to generate rendering logic for a specific tab
generate_tab_rendering_logic <- function(data, default_sort, columns, column_groups) {
  renderReactable({
    reactable(
      data,
      #filterable = TRUE,
      borderless = T,
      highlight = T,
      sortable = FALSE,
      pagination = FALSE,
      height = 800,
      fullWidth = FALSE,
      defaultSorted = default_sort,
      columns = columns,
      columnGroups = column_groups
    )
  })
}
