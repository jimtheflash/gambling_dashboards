
server <- function(input, output, session) {

  # restart if necessary
  restart_app()

  # get update timestamps
  output$win_tip_ts <- renderText({make_timestamp_string(max(win_tip$data$run_timestamp_utc))})
  output$fpts_ts <- renderText({make_timestamp_string(max(fpts$data$run_timestamp_utc))})
  output$fpts_team_ts <- renderText({make_timestamp_string(max(fpts_team$data$run_timestamp_utc))})
  output$fpts_exact_ts <- renderText({make_timestamp_string(max(fpts_exact$data$run_timestamp_utc))})
  output$fpts_ts <- renderText({make_timestamp_string(max(fpts$data$run_timestamp_utc))})
  output$fpts_team_ts <- renderText({make_timestamp_string(max(fpts_team$data$run_timestamp_utc))})
  output$fpts_team_exact_ts <- renderText({make_timestamp_string(max(fpts_team_exact$data$run_timestamp_utc))})
  output$first_three_ts <- renderText({make_timestamp_string(max(fpts$data$run_timestamp_utc))})
  output$first_three_team_ts <- renderText({make_timestamp_string(max(fpts_team$data$run_timestamp_utc))})
  output$ftts_ts <- renderText({make_timestamp_string(max(ftts$data$run_timestamp_utc))})
  output$ftts_exact_ts <- renderText({make_timestamp_string(max(ftts_exact$data$run_timestamp_utc))})

  # tidyup data
  schedule_tidy <- reactive({tidyup_schedule(schedule$data)})
  fpts_tidy <- reactive({tidyup_table_data(fpts$data, 'fpts', schedule = schedule_tidy())})
  fpts_exact_tidy <- reactive({tidyup_table_data(fpts_exact$data, 'fpts_exact', schedule = schedule_tidy())})
  fpts_team_tidy <- reactive({tidyup_table_data(fpts_team$data, 'fpts_team', schedule = schedule_tidy())})
  fpts_team_exact_tidy <- reactive({tidyup_table_data(fpts_team_exact$data, 'fpts_team_exact', schedule = schedule_tidy())})
  first_three_tidy <- reactive({tidyup_table_data(first_three$data, 'first_three', schedule = schedule_tidy())})
  first_three_team_tidy <- reactive({tidyup_table_data(first_three_team$data, 'first_three_team', schedule = schedule_tidy())})
  ftts_tidy <- reactive({tidyup_table_data(ftts$data, 'ftts', schedule = schedule_tidy())})
  ftts_exact_tidy <- reactive({tidyup_table_data(fpts_exact$data, 'ftts_exact', schedule = schedule_tidy())})
  win_tip_tidy <- reactive({tidyup_table_data(win_tip$data, 'win_tip', schedule = schedule_tidy())})

  # output tables
  output$fpts_table <- renderReactable({make_table(fpts_tidy())})
  output$fpts_exact_table <- renderReactable({make_table(fpts_exact_tidy(), exact = TRUE)})
  output$fpts_team_table <- renderReactable({make_table(fpts_team_tidy())})
  output$fpts_team_exact_table <- renderReactable({make_table(fpts_team_exact_tidy(), exact = TRUE)})
  output$first_three_table <- renderReactable({make_table(first_three_tidy())})
  output$first_three_team_table <- renderReactable({make_table(first_three_team_tidy())})
  output$ftts_table <- renderReactable({make_table(ftts_tidy(), type = 'team')})
  output$ftts_exact_table <- renderReactable({make_table(ftts_exact_tidy(), type = 'team', exact = TRUE)})
  output$win_tip_table <- renderReactable({make_table(win_tip_tidy(), win_tip = TRUE)})

}
