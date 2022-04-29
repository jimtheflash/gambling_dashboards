library(tidyverse)

# get ftts odds and parse
ftts <- read.csv("https://raw.githubusercontent.com/jimtheflash/gambling_stuff/main/data/02_curated/nba_first_to_score/odds_ftts.csv") %>%
  filter(quarter == '1Q') %>%
  select(-starts_with('ftts')) %>%
  rowwise() %>%
  mutate(min_prob = min(c_across(ends_with('prob')), na.rm = TRUE),
         min_prob_book = list(which(c_across(ends_with('prob')) == min_prob))) %>%
  ungroup()

# run through games and flag arbs
games <- unique(ftts$game)
arbs <- list()
for (g in games) {
  game <- filter(ftts, game == g)
  if (nrow(game) != 2) next
  
  min_prob_sum <- sum(game$min_prob)
  if(min_prob_sum >= 1) next
  
  out_string <- c()
  for (i in 1:2) {
    tm <- game$team[[i]]
    cols_mtch_min_prob <- names(game)[which(unlist(game[i, ]) == game$min_prob[[i]])]
    cols_mtch_min_prob <- as.character(na.omit(gsub("min_prob", NA, cols_mtch_min_prob)))
    book_names <- gsub('_prob', '', cols_mtch_min_prob)
    book_lines <- as.numeric(game[i, paste0(book_names, '_line')])
    book_lines <- as.character(ifelse(book_lines > 0, paste0('+', book_lines), book_lines))
    row_string <- paste0(tm, ': ', paste(book_names, book_lines, sep = ' ', collapse = ', '))
    out_string[[i]] <- row_string
  }
  game_string <- paste(out_string, collapse = '; ')
  arbs[[g]] <- game_string
}

if (length(arbs) == 0) {
  print('sorry no arbs')
} else {
  print(arbs)
}
