
restart_app <- function() {
  if (file.exists('restart.txt')) {
    system('touch restart.txt')
  } else {
    file.create('restart.txt')
  }
}


