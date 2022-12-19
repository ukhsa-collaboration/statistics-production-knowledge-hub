#' Check for small values in tabular data
#'
#' @description `find_small_values` finds locations in your data where the
#' specified cell is less than or equal to a cutoff value of your choosing.
#' The function prints off a list of locations that can optionally be stored as variable.
#'
#' @param obj an `aggregate_data` object
#' @param cutoff numeric. Any entries less than or equal to `cutoff` will be included in the output.
#' @param bycol logical, indicates whether the output should be sorted by column (`TRUE`) or row (`FALSE`).
#'
#' @returns A data frame with one row per value in the input data that is less than or equal to `cutoff`.
#' There are two columns in the matrix, `row` and `col`, which give the row number and column name of each
#' flagged value, respectively.
#'
#'
#' @examples To do
#' @export
find_small_values <- function(obj, cutoff = 5, bycol = TRUE, print = FALSE) {

  c <- as.data.frame(which(obj$original_data <= cutoff & obj$original_data > 0 , arr.ind = TRUE)) %>%
  filter(col != obj$treatment)

  rownames(c) <- NULL

  if(bycol == FALSE) c <- c[order(c$row),]

  c$col <- colnames(obj$original_data)[c$col]

  return(c)
}

