
tidyup_schedule <- function(schedule) {

  # assumes this is still in ET
  schedule %>%
    mutate(tipoff = strptime(schedule$GAME_STATUS_TEXT, format = "%I:%M %p", tz = "EST5EDT")) %>%
    separate(GAMECODE, c("date", "teams")) %>%
    transmute(
      tipoff,
      away_team = substr(teams, 1, 3),
      home_team = substr(teams, 4, 6)
    ) %>%
    pivot_longer(
      -tipoff
    ) %>%
    transmute(team = value,
              tipoff)
}
