
make_timestamp_string <- function(utc_timestamp) {
  datetime <- as_datetime(utc_timestamp)
  paste0('Table data last updated at: ', format(with_tz(datetime), '%x %I:%M %p %Z'))
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
