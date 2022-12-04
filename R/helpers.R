find_edges <- function(x) {
  edges <- list()
  for (i in 1:nrow(x)) {
    test_row <- x %>%
      dplyr::filter(dplyr::row_number() == i) %>%
      dplyr::mutate_all(~replace(., is.na(.), -Inf)) %>%
      dplyr::mutate(max_edge_val = max(dplyr::c_across(dplyr::ends_with('edge'))))
    edge_out_vec <- c()
    edge_cols <- test_row %>% select(ends_with('edge'))
    for (j in 1:ncol(edge_cols)) {
      edge_colname <- colnames(edge_cols)[j]
      book <- unlist(str_split(colnames(edge_cols[j]), '_'))[1]
      line_colname <- paste0(book, '_line')
      book_edge <- edge_cols[1, edge_colname]
      if (book_edge > 0) edge_out_vec[book] <- test_row[1, line_colname]
    }
    if (all(is.na(edge_out_vec)) | is.null(edge_out_vec)) {
      edges[[i]] <- 'none'
    } else {
      sorted_edges <- rev(sort(edge_out_vec[which(!is.na(edge_out_vec))]))
      out_string <- paste0(names(sorted_edges), ' +', sorted_edges, collapse = ', ')
      edges[[i]] <- out_string
    }
  }
  return(edges)
}

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
