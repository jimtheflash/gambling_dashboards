
server <- function(input, output, session) {

  # restart if necessary
  restart_app()

  # get update timestamps
  output$fpts_ts <- renderText({make_timestamp_string(max(fpts$data$run_timestamp_utc))})
  output$fpts_team_ts <- renderText({make_timestamp_string(max(fpts_team$data$run_timestamp_utc))})
  output$ftts_ts <- renderText({make_timestamp_string(max(ftts$data$run_timestamp_utc))})

  # tidyup data
  schedule_tidy <- reactive({tidyup_schedule(schedule$data)})
  fpts_tidy <- reactive({tidyup_table_data(fpts$data, 'fpts', inputs = input, schedule = schedule_tidy())})
  fpts_team_tidy <- reactive({tidyup_table_data(fpts_team$data, 'fpts_team', inputs = input, schedule = schedule_tidy())})
  ftts_tidy <- reactive({tidyup_table_data(ftts$data, 'ftts', inputs = input, schedule = schedule_tidy())})

  # output tables
  output$fpts_table <- renderReactable({make_table(fpts_tidy())})
  output$fpts_team_table <- renderReactable({make_table(fpts_team_tidy())})
  output$ftts_table <- renderReactable({make_table(ftts_tidy(), type = 'team')})

}
