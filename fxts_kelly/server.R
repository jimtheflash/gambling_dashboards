server <- function(input, output, session) {
  # restart if necessary
  restart_app()

  # get update timestamps
  output$fpts_ts <- renderText({paste0("First player to score projections updated at: ", max(fpts$data$run_timestamp_utc))})
  output$fpts_team_ts <- renderText({paste0("First player to score by team projections updated at: ", max(fpts_team$data$run_timestamp_utc))})
  output$ftts_ts <- renderText({paste0("First team to score projections updated at: ", max(ftts$data$run_timestamp_utc))})

  # when update button is pushed, get new data
  # TODO: add the timestamps here i think?
  observeEvent(input$updateButton, {
    fpts$data <- read.csv(fpts_path)
    fpts_team$data <- read.csv(fpts_team_path)
    ftts$data <- read.csv(ftts_path)
  })

  # tidyup data
  fpts_tidy <- reactive({tidyup_table_data(fpts$data, 'fpts', filters = input$checkboxes)})
  fpts_team_tidy <- reactive({tidyup_table_data(fpts_team$data, 'fpts_team', filters = input$checkboxes)})
  ftts_tidy <- reactive({tidyup_table_data(ftts$data, 'ftts', filters = input$checkboxes)})

  # output tables
  output$fpts_table <- renderReactable({make_table(fpts_tidy())})
  output$fpts_team_table <- renderReactable({make_table(fpts_team_tidy())})
  output$ftts_table <- renderReactable({make_table(ftts_tidy(), type = 'team')})

}
