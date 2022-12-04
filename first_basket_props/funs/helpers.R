add_plus <- function(x) {
  if (is.na(x)) ''
  else if (x > 0) paste0('+', round(x))
  else if (x <= 0) as.character(round(x))
  else x
}

restart_app <- function() {
  if (file.exists('restart.txt')) {
    system('touch restart.txt')
  } else {
    file.create('restart.txt')
  }
}
