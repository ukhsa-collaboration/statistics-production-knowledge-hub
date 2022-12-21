print.aggregate_data <- function(obj) {
  cat('+++++++ OBJECT INFORMATION:', deparse(substitute(obj)), '+++++++\n')
  cat('\n')

  cat('CLASS:', attr(obj,'class'), '\n')
  cat('\n')

  cat('COLUMNS:', ncol(obj$original_data), 'total\n    TREATMENT:', colnames(obj$original_data)[obj$treatment] )
  cat('\n    DATA:', paste(colnames(obj$original_data)[obj$data]), sep = '\n    ')
  if(is.numeric(obj$total_col)) cat('    TOTALS:', colnames(obj$original_data)[obj$total_col])
  cat('\n')
  cat('\n')

  cat("ROWS:", nrow(obj$original_data), "total \n")
}
