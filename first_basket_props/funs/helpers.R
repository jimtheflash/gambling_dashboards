
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


